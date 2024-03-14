// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {Test, console2} from "@forge-std/Test.sol";
import {Puzzle} from "../src/Puzzle.sol";

contract PuzzleTest is Test {
    bytes32 constant ROOT = 0xd2d6f4d12c85c4e1a8b28d0cf4854755c9bc42408aba6e50c926afe9160cf128; // keccak(puzzle)
    string constant DESCRIPTION = "testboi";
    uint256 constant PRIZE = 1 ether;
    address constant OWNER = 0xd698e31229aB86334924ed9DFfd096a71C686900;
    address constant NONOWNER = 0xd74c5aE80A3A8d3e0Be234aebD2348f255190B99;
    string constant ANSWER = "puzzle";

    Puzzle public puzzle;

    function setUp() public {
        puzzle = new Puzzle{value: PRIZE}(ROOT, DESCRIPTION);
        vm.prank(puzzle.owner());
        puzzle.transferOwnership(OWNER);
    }

    function test_Solve() public {
        vm.prank(OWNER);
        puzzle.solve(ANSWER);
        assertEq(OWNER.balance, PRIZE);
    }

    function test_OwnerSend() public {
        vm.deal(OWNER, 100);
        vm.prank(OWNER);
        payable(address(puzzle)).transfer(100);
        assertEq(address(puzzle).balance, PRIZE + 100);
    }

    function test_NonOwnerSend() public {
        vm.deal(NONOWNER, 100);
        vm.prank(NONOWNER);
        vm.expectRevert(abi.encodeWithSelector(Puzzle.OnlyOwnerCanPutPrizeMoneyIn.selector));
        payable(address(puzzle)).transfer(100);
    }
}
