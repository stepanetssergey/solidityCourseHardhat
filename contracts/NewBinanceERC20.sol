pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract NewBinanceERC20 {

   // token name - 
   // symbol - 
   // tokenSupply - 

   string public name = "NewBinanceLP";
   string public symbol = "NFLP";
   uint totalSupply;
   address public owner;

   // balance for address
   mapping(address => uint) public _balance; 
   mapping(address => mapping(address => uint)) public _allowance;

   constructor () {
      owner = msg.sender;
   }

   /*
      address = owner [ address -> mapping ]
      (address, mapping), (address, mapping) .....

      mapping -> (address, value), (address, value)
      [
          (address, (address, value)),(address, (address, value)),(address, (address, value)),(address, (address, value))...
      ]
      _allowance[address][address] = value
   */

   modifier onlyOnwer() {
       require(msg.sender == owner, "Only owner");
       _;
      
   }
 

   function approve(address _sender, uint _value) public {
       _allowance[msg.sender][_sender] = _value;
   }

   
   function _mint(address _to, uint _value) internal {
       totalSupply += _value;
       _balance[_to] += _value;
   }

   function _burn(address _owner, uint _value) public onlyOnwer {
       totalSupply -= _value;
       _balance[_owner] -= _value;
   }

   function transfer(address _to, uint _value) public {
       require(_balance[msg.sender] >= _value, "Not enought amount");
       _transfer(msg.sender, _to, _value);
   }

   function transferFrom(address _from, address _to, uint _value) public {
       require(_balance[_from] >= _value, "Not enought amount");
       _allowance[_from][_to] -= _value;
       _transfer(_from, _to, _value);
   }

   function _transfer(address _from, address _to, uint _value) internal {
       _balance[_from] -= _value;
       _balance[_to] += _value;
   }

   function balanceOf(address _owner) public view returns(uint) {
       return _balance[_owner];
   }

}