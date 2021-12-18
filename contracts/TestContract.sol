pragma solidity ^0.8.0;


contract TestContract {

    // uint8 - uint256 
    // string = 'string'
    // address payable - send ether
    // address - 
    // 1. memory 
    // 2. storage
    // msg.sender
    // msg.value
    // 1. only integer (1.2 is not possible)
    // 2. -1
    // call api - 
    // wait (20s) -> function -> wait (20s) -> 
    // block -> shash -> block -> shash 
    // contract (block gas 4000000 - 5000000)
    // 80s
    // 


    address public owner;
    uint public deposit; // function deposit() returns(uint);
    string public depositName;
    string public contractName;

    constructor (string memory _contractName) {
       owner = msg.sender;
       contractName = _contractName;
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _; // function
    }

    function createDeposit(string memory _deposit_name) public onlyOwner {
        depositName = _deposit_name;
    }

    function PutDeposit(uint _deposit) public {
         deposit += _deposit;
         // deposit += _deposit
         // deposit = deposit + _deposit;   
    }

    function ExperementMinus(uint _first, uint _second) public pure returns(uint) {
        uint result = _first - _second;
        return result;
    }

    function ExperementFloat(uint _first, uint _second) public pure returns(uint) {
        uint result2 = _first/_second;
        return result2;
    }

}