const { expect } = require("chai");
const { ethers } = require("hardhat");
const Test = require("mocha/lib/test");
const BEB20Abi = require('../artifacts/contracts/interfaces/IBEP.sol/IBEP20.json');
// address - rpc (fuction, input, output)

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

    // get test tokens
    USDT = await ethers.getContractFactory("USDT")
    usdttoken = await USDT.deploy();

    CourseToken  = await ethers.getContractFactory("CourseToken")
    coursetoken = await CourseToken.deploy();

    // factory contract
    Factory = await ethers.getContractFactory("Factory")
    factory = await Factory.deploy();

    // router contract
    Router = await ethers.getContractFactory("NewBinanceRouter")
    router = await Router.deploy(factory.address);



    [...addrs] = await ethers.getSigners()

    //console.log(addrs[0].address)
    //console.log(addrs[0])
    // addrs['address1', 'address2', ....]
  });

  describe("Test case contract name", function () {
    
    it("Add coin for getting WBNB", async () => {
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

    it("Add pair for tokens", async () => {
      await factory.createPair(usdttoken.address, coursetoken.address);
      const allPairsLength = await factory.lengthAllPairs();
      console.log(allPairsLength.toString());
      const pairAddress = await factory.Pairs(usdttoken.address, coursetoken.address)
      console.log(pairAddress)
      const pairAddressByIndex = await factory.allPairs(0)
      console.log(pairAddressByIndex);
    })

    it("Balance tokens checking", async () => {
       const usdtBalance = await usdttoken.balanceOf(addrs[0].address);
       console.log(usdtBalance.toString());
       const coursetokenBalance = await coursetoken.balanceOf(addrs[0].address)
       console.log('Balance course:', coursetokenBalance.toString())
    })

    it("Add liquidity", async () => {
      var liquidityAmount = ethers.utils.parseEther("1");
      await usdttoken.connect(addrs[0]).approve(router.address,liquidityAmount)
      await coursetoken.connect(addrs[0]).approve(router.address,liquidityAmount)
      const liquidityTrx = await router.connect(addrs[0])
                                 .addLiquidity(usdttoken.address, coursetoken.address,liquidityAmount,liquidityAmount)
      const liquidity = await liquidityTrx.wait();
      // console.log('Liquidity:', liquidity);
      const pairAddress = await factory.Pairs(usdttoken.address, coursetoken.address);
      console.log('Created pair', pairAddress);
      let provider = await ethers.getDefaultProvider();
      const lpContract = new ethers.Contract(pairAddress, BEB20Abi.abi, provider);
      console.log(lpContract)
      console.log(addrs[0].address)
      const balanceLp = await lpContract.connect(addrs[0]).balanceOf(addrs[0].address);
      console.log(balanceLp.toString())
    })

    it("Swap in pair", async () => {
      // check balance usdt
      // check balance coursetoken
      // call router swap 
      // check balacne after swap of both tokens
      
    })

  })
})




