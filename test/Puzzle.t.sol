// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {Test, console2} from "@forge-std/Test.sol";
import {Puzzle} from "../src/Puzzle.sol";

contract PuzzleTest is Test {
    bytes32 constant ROOT = 0xd2d6f4d12c85c4e1a8b28d0cf4854755c9bc42408aba6e50c926afe9160cf128; // keccak(puzzle)
    string constant DESCRIPTION = "testboi";
    uint256 constant PRIZE = 1 ether;
    address constant SENDER = 0xd698e31229aB86334924ed9DFfd096a71C686900;
    string constant ANSWER = "puzzle";

    Puzzle public puzzle;

    function setUp() public {
        puzzle = new Puzzle{value: PRIZE}(ROOT, DESCRIPTION);
        console2.log(address(puzzle).balance);
    }

    function test_Solve() public {
        vm.prank(SENDER);
        puzzle.solve(ANSWER);
        assertEq(SENDER.balance, PRIZE);
    }
}
