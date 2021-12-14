//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./structures/Elements.sol";

contract Proposal {

    mapping (uint => ProposalForm) public proposals;
    uint[] public proposalList;

    constructor () {
        console.log("Proposal contract deployed");
    }

    modifier proposalExists(uint _id) {
        string memory duplicatedProposalMessage = "Proposal with same ID already exists!";
        bool proposalAlreadyCreated;
        if(proposalList.length > 0) {
            for(uint i = 0; i < proposalList.length; i++) {
                proposalAlreadyCreated = proposalList[i] == _id;
            }
        }
        require(!proposalAlreadyCreated, duplicatedProposalMessage);
        _;
    }

    modifier proposalIsActive(uint _id) {
        bool propIsActive = proposals[_id].isActive;
        require(!propIsActive || propIsActive, "Proposal doesn't exist");

        require(propIsActive, "Proposal is inactive");
        _;
    }

    function newProposal(
        uint _id,
        string memory _name,
        uint _goal,
        uint _createdAt,
        uint _lastVotedAt,
        Creator memory _creator
        ) public proposalExists(_id) {
            proposals[_id].name = _name;
            proposals[_id].goal = _goal;
            proposals[_id].createdAt = _createdAt;
            proposals[_id].isActive = true;
            proposals[_id].lastVotedAt = _lastVotedAt;
            proposals[_id].voteCount = 0;
            proposals[_id].createdBy = _creator;

            proposalList.push(_id);
    }

    function getProposal(uint _id) public view proposalIsActive(_id) returns (ProposalForm memory) {
        ProposalForm memory proposal = proposals[_id];
        return proposal;
    }

    function getProposalStatus(uint _id) public view returns (bool) { return proposals[_id].isActive; }

    function getProposalCount() public view returns (uint) { return proposalList.length; }

    function proposalVote(uint _id, uint _lastVotedAt) public proposalIsActive(_id) {
        ProposalForm storage prop = proposals[_id];
        uint vote = 1;

        prop.voteCount += vote;
        prop.lastVotedAt = _lastVotedAt;
    }
}