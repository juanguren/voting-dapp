//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

struct Proposal {
    string ID;
    string name;
    uint goal; // vote count
    uint createdAt; // timestamp
    bool isActive;
    uint lastVotedAt; // timestamp
    uint totalVoteCount;
    // mapping(uint => Proposal) voteCount;
}

struct Voter {
    address ID;
    string name;
    uint age;
    bool hasVoted;
    string proposalId;
}
