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
    WBNB = await ethers.getContractFactory("WBNB");
    wbnb = await WBNB.deploy();

    [...addrs] = await ethers.getSigners()

    //console.log(addrs[0].address)
    //console.log(addrs[0])
    // addrs['address1', 'address2', ....]
  });

  describe("Test case contract name", function () {
    
    it("Add coint for getting WBNB", async () => {
      // send 1 ether to WBNB
      const admin = addrs[0]
      console.log('WBNB address', wbnb.address)
      const transactionHash = await admin.sendTransaction({
        to: wbnb.address,
        value: ethers.utils.parseEther("1.0"), // Sends exactly 1.0 ether
      });
      const balance = await wbnb.balanceOf(addrs[0].address);
      console.log(balance.toString());
      console.log(addrs[0].address)
      await wbnb.connect(addrs[0]).withdraw(ethers.utils.parseEther("1.0"))
      const balanceAfter = await wbnb.balanceOf(addrs[0].address);
      console.log('Balance after', balanceAfter.toString())
    })

  })
})




