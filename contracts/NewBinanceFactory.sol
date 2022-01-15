pragma solidity ^0.8.0;

import './NewBinancePair.sol';
// import './interfaces/INewBinancePair.sol';

contract Factory {


    uint public lengthAllPairs;
    address[] public allPairs; // [ пара1, пара2, пара3]
    // allPairs(0) , allPairs(1) 
    mapping(address => mapping(address => address)) public Pairs;
    // (address1,(address -> address of pair)),()

    constructor() {

    }
    
    // createPair(address,address)
    function createPair(address token0, address token1) public returns(address) {
       // 1 create of pair
       NewBinancePair _pool = new NewBinancePair{salt: keccak256(abi.encode(token0, token1))}();
       // initialize
        _pool.initialize(token0, token1);
       // INewBinancePair _newPool = INewBinancePair(address(_pool)); // =  на этом адресе есть контракт с функцией и как ее вызвать
       // что мы можем вызвать (название функции) + как эту функцию вызывать ()
       // _newPool.initialize(token0, token1); - address(this)
       lengthAllPairs += 1;
       Pairs[token0][token1] = address(_pool);
       Pairs[token1][token0] = address(_pool);
       allPairs.push(address(_pool));
       // Pairs(usdt-address, courseToken address) = address пары
       return address(_pool);
    }

    function getSalt(address token0, address token1) public returns(bytes32) {
        return keccak256(abi.encode(token0, token1));
    }

    // 0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B
    // 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47

    // address 0xA0eF43653D867F81fCd57Fbc85de993333d6Ef25
    // 0x8Ac8247AB94da88B042bFc47299dfF4aE58E3638
}