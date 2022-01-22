pragma solidity ^0.8.0;

import './ITRC20.sol';

contract DepositWithdraw {
    
    address public owner;
    address public tokenAddress;
    
    mapping(address => bool) public Admins;
    
    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }
    
    struct user {
        uint depositAmount;
        uint amountForWithdraw;
        uint withdrawed;
    }
    
    mapping(address => user) public Users;
    
    modifier onlyAdmin() {
        require(Admins[msg.sender] == true, "Only admin");
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    function setAdmin(address _address, bool _state) public onlyOwner {
        Admins[_address] = _state;
    }
    
    function setTokenAddress(address _address) public onlyOwner {
        tokenAddress = _address;
    }
    
    function depositTokens(uint _value, address _address) public {
        // ITRC20 _token = ITRC20(tokenAddress);
        ITRC20(tokenAddress).transferFrom(msg.sender, address(this), _value);
        Users[_address].depositAmount += _value;
    }
    
    function setUserWithdrawAmount(uint _value, address _address) public onlyAdmin {
        Users[_address].amountForWithdraw = _value;
    }
    
    function withdraw() public {
        require(Users[msg.sender].amountForWithdraw > 0, "amount for withdraw is 0");
        ITRC20 _token = ITRC20(tokenAddress);
        _token.transfer(msg.sender, Users[msg.sender].amountForWithdraw);
        Users[msg.sender].withdrawed += Users[msg.sender].amountForWithdraw;
        Users[msg.sender].amountForWithdraw = 0;
    }
}