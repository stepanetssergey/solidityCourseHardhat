pragma solidity ^0.8.0;


interface IFactory {
    function Pairs(address _token0, address _token1) external view returns(address);

   function createPair(address token0, address token1) external returns(address);
}