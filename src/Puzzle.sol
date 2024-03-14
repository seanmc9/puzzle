// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.24;

import "@openzeppelin/utils/Address.sol";
import "@openzeppelin/access/Ownable.sol";

contract Puzzle is Ownable {
    bytes32 public root;
    string public description;

    constructor(bytes32 root_, string memory description_) Ownable(msg.sender) payable {
        root = root_;
        description = description_;
    }

    receive() external payable {}

    function updateRoot(bytes32 newRoot_) public onlyOwner {
        root = newRoot_;
    }

    function updateDescription(string memory newDescription_) public onlyOwner {
        description = newDescription_;
    }

    function solve(string memory answer) public {
        if (keccak256(abi.encodePacked(answer)) == root) Address.sendValue(payable(msg.sender), address(this).balance);
    }
}
