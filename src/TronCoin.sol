// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TronCoin is ERC20 {
    address public stackContractAddress;
    address owner;
    constructor(address _stackContractAddress) ERC20("TRON", "TronCoin") {
        stackContractAddress = _stackContractAddress;
        owner = msg.sender;
    }

    function mint(address _stackContractAddress, uint256 _amount) public {
        require(msg.sender == stackContractAddress);
        _mint(_stackContractAddress, _amount);
    }

    function updateStakingContract(address _newcontarctAddress) public {
        require(msg.sender == owner);
        stackContractAddress = _newcontarctAddress;
    }
}
