

# Lending Platform

## Project Description
Lending Platform is a decentralized financial application built on blockchain technology that facilitates peer-to-peer lending and borrowing of cryptocurrencies. The platform allows users to deposit assets, earn interest on their deposits, and borrow against collateral in a trustless, transparent environment.

## Project Vision
Our vision is to create an inclusive financial ecosystem that eliminates traditional intermediaries while providing secure, accessible, and efficient lending services to users worldwide. By leveraging smart contracts, we aim to automate loan origination, collateralization, interest accrual, and repayments, reducing costs and increasing accessibility compared to traditional financial institutions.

## Key Features
- **Asset Deposits**: Users can deposit cryptocurrencies into the platform to earn interest or provide liquidity.
- **Collateralized Loans**: Borrowers can obtain loans by providing collateral, with loan-to-value ratios determined by the platform's collateral factor.
- **Automatic Interest Calculation**: Interest accrues based on loan duration with transparent, predefined rates.
- **Secure Repayment System**: Automated processing of loan repayments and collateral release upon successful repayment.
- **Platform Statistics**: Transparency through real-time reporting of total deposits, outstanding loans, and available liquidity.
- **Security Measures**: Implementation of reentrancy guards and best practices to protect user funds.

## Future Scope
- **Multiple Asset Support**: Integration with various ERC20 tokens as both collateral and borrowable assets.
- **Variable Interest Rates**: Dynamic interest rates based on supply and demand of specific assets.
- **Governance Mechanism**: Introduction of a DAO structure allowing stakeholders to vote on platform parameters.
- **Flash Loans**: Implementation of uncollateralized loans for single-transaction use cases.
- **Liquidity Mining**: Incentive programs to attract liquidity providers through token rewards.
- **Cross-Chain Functionality**: Expansion to multiple blockchains for increased interoperability.
- **Advanced Risk Management**: Implementation of sophisticated liquidation mechanisms and insurance pools.
- **Integration with DeFi Ecosystem**: Connecting with other DeFi protocols for enhanced yield strategies.

## Getting Started

### Prerequisites
- Node.js (v16 or later)
- npm or yarn
- Hardhat

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/lending-platform.git
   cd lending-platform
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Configure environment variables:
   - Create a `.env` file based on the `.env.example` template
   - Add your private key for contract deployment

### Deployment
To deploy to Core Testnet 2:
```
npx hardhat run scripts/deploy.js --network coreTestnet2
```

### Testing
```
npx hardhat test
```

Contract Address: 0xb2B0ce526F47C470d89B0Cdd3036Bf7742EB0012

<img width="1520" alt="image" src="https://github.com/user-attachments/assets/fe9ef2ce-2a76-441f-98bb-65bcb673723a" />

