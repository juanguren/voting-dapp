//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

struct Creator {
    address id;
    string name;
}

struct ProposalForm {
    string name;
    uint goal; // vote count
    uint createdAt; // timestamp
    bool isActive;
    uint lastVotedAt; // timestamp
    uint voteCount;
    Creator createdBy;
    // mapping(uint => Proposal) voteCount;
}

struct Voter {
    string name;
    uint age;
    bool hasVoted;
    string proposalId;
}
