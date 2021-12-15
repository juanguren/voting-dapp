//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./structures/Elements.sol";

contract Proposal {
    mapping(uint256 => ProposalForm) public proposals;
    uint256[] public proposalList;

    constructor() {
        console.log("Proposal contract deployed");
    }

    modifier proposalIsDuplicated(uint256 _id) {
        string
            memory duplicatedProposalMessage = "Proposal with same ID already exists!";
        bool proposalAlreadyCreated;
        if (proposalList.length > 0) {
            for (uint256 i = 0; i < proposalList.length; i++) {
                proposalAlreadyCreated = proposalList[i] == _id;
            }
        }
        require(!proposalAlreadyCreated, duplicatedProposalMessage);
        _;
    }

    modifier proposalIsActive(uint256 _id) {
        bool propIsActive = proposals[_id].isActive;
        require(!propIsActive || propIsActive, "Proposal doesn't exist");

        require(propIsActive, "Proposal is inactive");
        _;
    }

    function _proposalHasReachedGoal(uint256 _id) private view returns (bool) {
        uint256 votes = proposals[_id].voteCount;
        uint256 goal = proposals[_id].goal;

        if (votes == goal) return true;
        return false;
    }

    function newProposal(
        uint256 _id,
        string memory _name,
        uint256 _goal,
        uint256 _createdAt,
        uint256 _lastVotedAt,
        Creator memory _creator
    ) public proposalIsDuplicated(_id) {
        proposals[_id].name = _name;
        proposals[_id].goal = _goal;
        proposals[_id].createdAt = _createdAt;
        proposals[_id].isActive = true;
        proposals[_id].lastVotedAt = _lastVotedAt;
        proposals[_id].voteCount = 0;
        proposals[_id].createdBy = _creator;

        proposalList.push(_id);
    }

    function getProposal(uint256 _id)
        public
        view
        proposalIsActive(_id)
        returns (ProposalForm memory)
    {
        ProposalForm memory proposal = proposals[_id];
        return proposal;
    }

    function getProposalStatus(uint256 _id) public view returns (bool) {
        return proposals[_id].isActive;
    }

    function getProposalCount() public view returns (uint256) {
        return proposalList.length;
    }

    function proposalVote(uint256 _id, uint256 _lastVotedAt)
        public
        proposalIsActive(_id)
    {
        bool goalReached = _proposalHasReachedGoal(_id); // event below...
        require(!goalReached, "Proposal has reached its target");

        ProposalForm storage prop = proposals[_id];
        uint256 vote = 1;

        prop.voteCount += vote;
        prop.lastVotedAt = _lastVotedAt;
    }
}
