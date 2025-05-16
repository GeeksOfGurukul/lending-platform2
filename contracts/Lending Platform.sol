// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title LendingPlatform
 * @dev A simple lending platform that allows users to deposit collateral,
 * borrow assets, and repay loans with interest
 */
contract LendingPlatform is Ownable, ReentrancyGuard {
    // Constants
    uint256 public constant INTEREST_RATE = 5; // 5% interest rate
    uint256 public constant COLLATERAL_FACTOR = 75; // 75% loan-to-value ratio
    uint256 public constant LIQUIDATION_THRESHOLD = 85; // 85% threshold for liquidation

    // Structs
    struct Loan {
        uint256 loanAmount;     // Amount borrowed
        uint256 collateralAmount; // Amount of collateral provided
        uint256 timestamp;      // When the loan was created
        bool active;            // Whether the loan is currently active
    }

    // Mappings
    mapping(address => uint256) public deposits; // User deposits
    mapping(address => Loan) public loans;       // User loans
    
    // Platform balances
    uint256 public totalDeposits;
    uint256 public totalLoans;
    
    // Events
    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);
    event LoanCreated(address indexed borrower, uint256 loanAmount, uint256 collateralAmount);
    event LoanRepaid(address indexed borrower, uint256 repaidAmount, uint256 interest);
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Deposit assets into the lending platform
     */
    function deposit() external payable nonReentrant {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
        
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @dev Borrow assets by providing collateral
     * @param borrowAmount The amount to borrow
     */
    function borrow(uint256 borrowAmount) external payable nonReentrant {
        require(borrowAmount > 0, "Borrow amount must be greater than 0");
        require(msg.value > 0, "Collateral must be provided");
        require(loans[msg.sender].active == false, "You already have an active loan");
        require(totalDeposits >= borrowAmount, "Not enough liquidity in the platform");
        
        // Calculate the maximum borrowable amount based on collateral
        uint256 maxBorrowableAmount = (msg.value * COLLATERAL_FACTOR) / 100;
        require(borrowAmount <= maxBorrowableAmount, "Insufficient collateral for requested loan amount");
        
        loans[msg.sender] = Loan({
            loanAmount: borrowAmount,
            collateralAmount: msg.value,
            timestamp: block.timestamp,
            active: true
        });
        
        totalLoans += borrowAmount;
        totalDeposits -= borrowAmount;
        
        // Transfer the borrowed amount to the borrower
        (bool success, ) = payable(msg.sender).call{value: borrowAmount}("");
        require(success, "Failed to send borrowed amount");
        
        emit LoanCreated(msg.sender, borrowAmount, msg.value);
    }
    
    /**
     * @dev Repay a loan with interest
     */
    function repayLoan() external payable nonReentrant {
        Loan storage loan = loans[msg.sender];
        require(loan.active, "No active loan found");
        
        // Calculate interest
        uint256 loanDuration = block.timestamp - loan.timestamp;
        uint256 daysElapsed = loanDuration / 1 days;
        uint256 interest = (loan.loanAmount * INTEREST_RATE * daysElapsed) / (365 * 100);
        uint256 totalRepayment = loan.loanAmount + interest;
        
        require(msg.value >= totalRepayment, "Insufficient repayment amount");
        
        // Return collateral
        uint256 collateral = loan.collateralAmount;
        loan.active = false;
        
        // Update platform balances
        totalDeposits += totalRepayment;
        totalLoans -= loan.loanAmount;
        
        // Return collateral to borrower
        (bool success, ) = payable(msg.sender).call{value: collateral}("");
        require(success, "Failed to return collateral");
        
        // Return excess payment if any
        if (msg.value > totalRepayment) {
            uint256 excess = msg.value - totalRepayment;
            (bool refundSuccess, ) = payable(msg.sender).call{value: excess}("");
            require(refundSuccess, "Failed to refund excess payment");
        }
        
        emit LoanRepaid(msg.sender, loan.loanAmount, interest);
    }
    
    /**
     * @dev Withdraw deposited assets
     * @param amount The amount to withdraw
     */
    function withdraw(uint256 amount) external nonReentrant {
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        require(totalDeposits >= amount, "Insufficient platform liquidity");
        
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Failed to send withdrawal");
        
        emit Withdrawal(msg.sender, amount);
    }
    
    /**
     * @dev Get loan details for a borrower
     * @param borrower The address of the borrower
     * @return loanAmount The amount borrowed
     * @return collateralAmount The collateral provided
     * @return timestamp When the loan was created
     * @return active Whether the loan is active
     */
    function getLoanDetails(address borrower) external view returns (
        uint256 loanAmount,
        uint256 collateralAmount,
        uint256 timestamp,
        bool active
    ) {
        Loan memory loan = loans[borrower];
        return (
            loan.loanAmount,
            loan.collateralAmount,
            loan.timestamp,
            loan.active
        );
    }
    
    /**
     * @dev Get current platform statistics
     * @return _totalDeposits Total deposits in the platform
     * @return _totalLoans Total loans outstanding
     * @return _availableLiquidity Available liquidity for lending
     */
    function getPlatformStats() external view returns (
        uint256 _totalDeposits,
        uint256 _totalLoans,
        uint256 _availableLiquidity
    ) {
        return (
            totalDeposits,
            totalLoans,
            totalDeposits - totalLoans
        );
    }
}
