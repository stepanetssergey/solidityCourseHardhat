pragma solidity ^0.8.0;
import './NewBinanceERC20.sol';

contract NewBinancePair {

    address public factory;
    address public token0;
    address public token1;


    constructor() {
      factory = msg.sender;
    }

    function initialize(address _token0, address _token1) public {
        require(msg.sender == factory, "Only factory");
        token0 = _token0;
        token1 = _token1;
    }
}