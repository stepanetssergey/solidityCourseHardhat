const { expect } = require("chai");
const { ethers } = require("hardhat");
const Test = require("mocha/lib/test");

describe("Test contract", function () {
  let TestContract;
  let testcontract;
  let newbinanceerc;
  let addrs;
  beforeEach(async function() {
    TestContract = await ethers.getContractFactory("TestContract") //
    testcontract = await TestContract.deploy("First Contract from HardHat");
    [...addrs] = await ethers.getSigners()

    //console.log(addrs[0].address)
    //console.log(addrs[0])
    // addrs['address1', 'address2', ....]
  });

  describe("Test case contract name", function () {
    it("Deployment of contract name", async function() {
      const deployContractName = await testcontract.connect(addrs[2]).contractName(); // -> msg.sender = addrs[2].address
      expect(deployContractName).to.equal("First Contract from HardHat")
      await testcontract.PutDeposit(10000);
      expect(await testcontract.deposit()).to.equal(10000)
      await testcontract.addUser(1)
      const userAddress = await testcontract.getUserAddress(1)
      console.log(userAddress)
    });
    // it("Check user by id", async function() {
    //   const userAddress2 = await testcontract.getUserAddress(1)
    //   console.log(userAddress2)
    // })

    it("Check minting burn transfer token", async () => {
      // 1. mint -> 5000
      // 2. transfer -> addrs[1], addrs[2]
      // newbinanceerc.mint(addrs[2], 100000000000);
      // balanceOf
      // newbinanceerc.transfer(addrs[3], 1000000)
      // balanceOf
      // newbinanceerc.balanceOf(addrs2) - после минта должно появится количество указанное в минте
      // после трансвера на одном балансе должно уменьшится на другом увеличится balanceOf
    })
  })
})




