pragma solidity ^0.8.0;

interface INewBinancePair {
    function initialize(address _token0, address _token1) external;
    function mint(address to) external returns(uint);
}