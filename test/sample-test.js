const { expect } = require("chai");
const { ethers } = require("hardhat");
const Test = require("mocha/lib/test");

describe("Test contract", function () {
  let TestContract;
  let testcontract;
  
  beforeEach(async function() {
    TestContract = await ethers.getContractFactory("TestContract")
    testcontract = await TestContract.deploy("First Contract from HardHat")
  });

  describe("Test case contract name", function () {
    it("Deployment of contract name", async function() {
      const deployContractName = await testcontract.contractName();
      expect(deployContractName).to.equal("First Contract from HardHat")
      await testcontract.PutDeposit(10000);
      expect(await testcontract.deposit()).to.equal(10000)
    });
  })
})




