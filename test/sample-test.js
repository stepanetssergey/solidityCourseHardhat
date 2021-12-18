const { expect } = require("chai");
const { ethers } = require("hardhat");
const Test = require("mocha/lib/test");

describe("Test contract" , function () {
  it("Deployment of contract name", async function() {
      //const [owner] = await ethers.getSigner()
      const TestContract = await ethers.getContractFactory("TestContract")
      const testcontract = await TestContract.deploy("First Contract from HardHat")
      const deployContractName = await testcontract.contractName();
      expect(deployContractName).to.equal("First Contract from HardHat")
      await testcontract.PutDeposit(10000);
      expect(await testcontract.deposit()).to.equal(10000)
  });
  
})




