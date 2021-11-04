//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    
    mapping(address => uint256) public voteRegistry;
    mapping(address => bool) public hasVoted;

    uint256 votes;

    constructor(string memory _greeting) {
        console.log("Deploying...");
    }

    function castVote(string memory _voter) public view returns (bool) {
        bool voteProof = hasVoted[_voter];
        console.log(voteProof);

        //voteRegistry[_voter] = block.timestamp;

    }
}

/**
contract Greeter {
    string private greeting;

    constructor(string memory _greeting) {
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }
}
*/
