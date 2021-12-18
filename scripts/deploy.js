
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  
  const TestContract = await hre.ethers.getContractFactory("TestContract");
  const testContract = await TestContract.deploy("First Contract from HardHat");

  await testContract.deployed();

  console.log("Test contract deployed to:", testContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
