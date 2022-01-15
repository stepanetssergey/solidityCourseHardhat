
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  
  const TestContract = await hre.ethers.getContractFactory("TestContract");
  const testContract = await TestContract.deploy("First Contract from HardHat");
  await testContract.deployed();

  const WBNB = await hre.ethers.getContractFactory("WBNB");
  const wbnb = await WBNB.deploy();
  await wbnb.deployed();


  // DEPLOY TEST TOKENS
  const USDT = await hre.ethers.getContractFactory("USDT")
  const usdttoken = await USDT.deploy();
  await usdttoken.deployed();
  console.log('TEST USDT:', usdttoken.address);

  const CourseToken  = await hre.ethers.getContractFactory("CourseToken")
  const coursetoken = await CourseToken.deploy();
  await coursetoken.deployed();
  console.log('COURSE TOKEN:', coursetoken.address);

  // DEPLOY FACTORY CONTRACT
  const Factory = await hre.ethers.getContractFactory("Factory")
  const factorycontract = await Factory.deploy();
  await factorycontract.deployed()
  console.log("FACTORY CONTRACT:", factorycontract.address);

  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
