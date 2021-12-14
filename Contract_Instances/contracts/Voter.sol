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

    function _getVoterStatus(address _id) private view returns (bool) {
        return voters[_id].hasVoted;
    }

    modifier userExists() {
        bool userAlreadyCreated;
        if(voterList.length > 0) {
            for(uint i = 0; i < voterList.length; i++) {
                userAlreadyCreated = voterList[i] == msg.sender;
            }
        }

        require(!userAlreadyCreated, "User already exists!");
        _;
    }

    function newVoter(string memory _name, uint _age) public userExists {
        address id = msg.sender;

        voters[id].name = _name;
        voters[id].age = _age;
        voters[id].hasVoted = false;
        voters[id].proposalId = 0;

        voterList.push(id);
    }

    function getVoter() public view returns (Voter memory) {
        Voter memory voter = voters[msg.sender];
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

    function getProposal(uint _id) public view returns (ProposalForm memory) {
        return proposal.getProposal(_id);
    }

    function voteProposal(uint _proposalId, uint _lastVotedAt) public {
        Voter storage voter = voters[msg.sender];
        require(!voter.hasVoted, "User has already voted.");

        voter.hasVoted = true;
        voter.proposalId = _proposalId;

        proposal.proposalVote(_proposalId, _lastVotedAt);
    }
}