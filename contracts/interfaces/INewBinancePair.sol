pragma solidity ^0.8.0;

interface INewBinancePair {
    function initialize(address _token0, address _token1) external;
    function mint(address to) external returns(uint);
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}