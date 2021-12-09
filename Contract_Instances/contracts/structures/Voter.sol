//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface IVoter {
    function newVoter(
        address _id,
        string memory _name,
        uint _age,
        bool _hasVoted,
        string memory _proposalId
    ) public;
    function getVoterStatus(address _id) public;
}