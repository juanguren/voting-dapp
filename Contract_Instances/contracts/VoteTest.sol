//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract VoteTest {
    
    mapping(address => uint256) public voteRegistry;
    mapping(address => bool) public hasVoted;
    event voteTallied(address voter, uint256 timestamp);

    uint256 votes;

    constructor() {
        console.log("DEPLOYED");
    }

    function _triggerEvent(address _voter) private {
        emit voteTallied(_voter, block.timestamp);
    }

    function castVote(address _voter) public {
        bool voteProof = hasVoted[_voter];
        require(voteProof == false, "User has already voted");

        voteRegistry[_voter] = block.timestamp;
        hasVoted[_voter] = true;
        votes += 1;
        _triggerEvent(_voter);
    }

    function checkVote(address _voter) public view returns (bool, uint256) {
        bool voted = hasVoted[_voter];
        uint256 timestamp = voteRegistry[_voter];

        return (voted, timestamp);
    }

    function retrieveLiquidVote(address _voter) public {
        bool voteProof = hasVoted[_voter];
        require(voteProof == true, "User has not voted yet");

        hasVoted[_voter] = false;
        votes -= 1;
    }

    function checkTotalVotes() public view returns (uint256 total) { total = votes; }
}
