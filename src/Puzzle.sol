// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import "@openzeppelin/utils/Address.sol";
import "@openzeppelin/access/Ownable.sol";

contract Puzzle is Ownable {
    bytes32 public root;
    string public description;

    error OnlyOwnerCanPutPrizeMoneyIn();
    error IncorrectAnswer();

    constructor(bytes32 root_, string memory description_) payable Ownable() {
        root = root_;
        description = description_;
    }

    receive() external payable {
        if (msg.sender != owner()) revert OnlyOwnerCanPutPrizeMoneyIn();
    }

    function updateRoot(bytes32 newRoot_) public onlyOwner {
        root = newRoot_;
    }

    function updateDescription(string memory newDescription_) public onlyOwner {
        description = newDescription_;
    }

    function withdraw() public onlyOwner {
        Address.sendValue(payable(owner()), address(this).balance);
    }

    function solve(string memory answer) public {
        if (!(keccak256(abi.encodePacked(answer)) == root)) revert IncorrectAnswer();
        Address.sendValue(payable(msg.sender), address(this).balance);
    }
}
