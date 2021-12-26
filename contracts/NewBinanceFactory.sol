pragma solidity ^0.8.0;

import './NewBinancePair.sol';

contract Factory {


    uint public lengthAllPairs;
    mapping(address => mapping(address => address)) public Pairs;
    // (address1,(address -> address of pair)),()

    constructor() {

    }
    
    // createPair(address,address)
    function createPair(address token0, address token1) public returns(address) {
       // 1 create of pair
       NewBinancePair _pool = new NewBinancePair{salt: keccak256(abi.encode(token0, token1))}();
       // initialize
       lengthAllPairs += 1;
       Pairs[token0][token1] = address(_pool);
       Pairs[token1][token0] = address(_pool);
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