pragma solidity ^0.8.0;

import "hardhat/console.sol";


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
    uint public userId;
    string public depositName;
    string public contractName;
    
    // 
    struct user {
        string name;
        uint user_id;
        uint depositValue;
        uint votes;
        bool active;
    }

    mapping(address => user) public Users;

    mapping(uint => address) public UserById;


    mapping(address => mapping(address => address)) public Pairs;

    // mapping(address (token0) => mapping(address (token1) => address (liqudity token))) public Pairs;

    // UserById[_id]


    // list -> (address, user), (address, user), (address, user),........(address i, user i)
    // Users[address].name, Users[address].active


    
    // (address, balance), (address, balance)
    // _balances[address] -= value; _balances[address] += value;
    // A -> B
    

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
         console.log("Deposit check", _deposit);
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

    // function addUser to mapping Users

    function addUser(uint _id) public {
        userId += 1;
        UserById[_id] = msg.sender;
    }

    function getUserAddress(uint _id) public view returns(address) {
        return UserById[_id];
    }

    function pureFunction(uint _test) public pure returns(uint) {
        uint _result = _test * 10000;
        return _result;
    }

    // input _test 10 ---> 10 * 10000;

    // function setActive change active in Users active 

    // function getUserAddress by ID

}