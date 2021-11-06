//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract VoteTest {
    
    mapping(address => uint256) public voteRegistry;
    mapping(address => bool) public hasVoted;

    uint256 votes;

    constructor() {
        console.log("DEPLOYED");
    }

    function castVote(address _voter) public {
        bool voteProof = hasVoted[_voter];
        require(voteProof == false, "User has already voted");

        voteRegistry[_voter] = block.timestamp;
        hasVoted[_voter] = true;
        votes += 1;
    }

    function checkVote(address _voter) public view returns (bool, uint256) {
        bool voted = hasVoted[_voter];
        uint256 timestamp = voteRegistry[_voter];

        return (voted, timestamp);
    }

    function checkTotalVotes() public view returns (uint256 total) {
        total = votes;
    }
}
