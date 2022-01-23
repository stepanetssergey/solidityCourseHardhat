pragma solidity ^0.8.4;


contract DataStorage {

    mapping(address => string) public AddressName;
    mapping(address => uint) public AddressDeposit;
    uint public totalContractDeposit;
    event AddToStorage(address _address);

    function addAddressName(address _address, string memory _name) public {
        AddressName[_address] = _name;
        emit AddToStorage(_address);
    }

    function addAddressDeposit(address _address, uint _deposit) public {
        AddressDeposit[_address] += _deposit;
        totalContractDeposit += _deposit;
    }
}