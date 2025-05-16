const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying LendingPlatform contract...");

  // Get the contract factory
  const LendingPlatform = await ethers.getContractFactory("LendingPlatform");
  
  // Deploy the contract
  const lendingPlatform = await LendingPlatform.deploy();
  
  // Wait for deployment to finish
  await lendingPlatform.waitForDeployment();
  
  // Get the contract address
  const lendingPlatformAddress = await lendingPlatform.getAddress();
  
  console.log(`LendingPlatform deployed to: ${lendingPlatformAddress}`);
  console.log("Deployment completed successfully!");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
