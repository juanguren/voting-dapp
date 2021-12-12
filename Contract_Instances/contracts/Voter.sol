//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./structures/Elements.sol";
import "./Proposal.sol";

contract User {

    mapping (address => Voter) public voters;
    address[] public voterList;
    Proposal public proposal;

    constructor(address _proposalId) {
        proposal = Proposal(_proposalId);
    }

    function getVoterStatus(address _id) private view returns (bool) {
        return voters[_id].hasVoted;
    }

    function newVoter(address _id, string memory _name, uint _age) public {
        bool userExists;
        if(voterList.length > 0) {
            for(uint i = 0; i < voterList.length; i++) {
                userExists = voterList[i] == _id;
            }
        }

        require(!userExists, "User already exists!");

        voters[_id].name = _name;
        voters[_id].age = _age;
        voters[_id].hasVoted = false;
        voters[_id].proposalId = "";

        voterList.push(_id);
    }

    function getVoter(address _id) public view returns (Voter memory) {
        Voter memory voter = voters[_id];
        return voter;
    }

    function getVoters() public view returns (address[] memory) { return voterList; }

    function getVotersCount() public view returns (uint) { return voterList.length; }

    function buildProposal(
        address _voterId,
        string memory _proposalName,
        uint _target,
        uint _createdAt,
        uint _lastVotedAt
        ) public {
        string memory voterName;
        voterName = voters[_voterId].name;

        uint proposalId;

        Creator memory creator;
        creator.id = _voterId;
        creator.name = voterName;

        proposal.newProposal(proposalId, _proposalName, _target, _createdAt, _lastVotedAt, creator);
    }
}