// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/TronCoin.sol";

contract testTronCoin is Test {
    TronCoin c;

    function setUp() public {
        c = new TronCoin(address(this));
    }

    function testmint() public {
        c.mint(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9, 10);
        assert(c.balanceOf(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9) == 10);
    }

    function testFailMint() public {
        vm.startPrank(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9);
        c.mint(0xfF1D73Ea47222386fE482BAadb1f3d5755ea55c9, 10);
    }

    function testupdateStakingContract() public {
        c.updateStakingContract(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9);

        vm.startPrank(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9);
        c.mint(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9, 10);

        assert(c.balanceOf(0x786ba2E5eBA763A3EA4A53cDa52eF4E4f02F20A9) == 10);
    }
}
