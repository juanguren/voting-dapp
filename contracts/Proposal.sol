//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./structures/Elements.sol";

contract Proposal {
    mapping(uint256 => ProposalForm) public proposals;
    uint256[] public proposalList;

    event ProposalVoted(
        uint256 indexed proposalId,
        address user,
        uint256 _lastVotedAt
    );
    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed createdBy,
        string name,
        uint256 createdAt
    );
    event ProposalReachedTarget(uint256 indexed proposalId, uint256 target);
    event VoteWasRetrieved(
        uint256 indexed proposalId,
        address indexed user,
        uint256 time
    );

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
        require(propIsActive, "Prop inactive or none existant");
        _;
    }

    /// @notice Checks all existing proposals to see if any is stagnated. If so, it marks those as inactive.
    /// @dev This is meant to be called by a cron job implemented in an independant lambda function. Time: 3 days
    function proposalIsStagnated() external {
        if (proposalList.length > 0) {
            for (uint16 i = 0; i < proposalList.length; i++) {
                if(proposals[i].lastVotedAt == proposals[i].createdAt) {
                    ProposalForm storage prop = proposals[i];
                    prop.isActive = false;
                }
            }
        }
    }

    function _proposalHasReachedGoal(uint256 _id) private returns (bool) {
        uint256 votes = proposals[_id].voteCount;
        uint256 goal = proposals[_id].goal;

        if (votes == goal) {
            emit ProposalReachedTarget(_id, goal);

            ProposalForm storage prop = proposals[_id];
            prop.isActive = false;
            return true;
        }
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

        emit ProposalCreated(_id, msg.sender, _name, _createdAt);

        proposalList.push(_id);
    }

    function getProposal(uint256 _id)
        public
        view
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

        emit ProposalVoted(_id, msg.sender, _lastVotedAt);
    }

    function liquidVote(uint256 _id, uint256 time)
        public
        proposalIsActive(_id)
    {
        ProposalForm storage prop = proposals[_id];
        uint256 vote = 1;

        prop.voteCount -= vote;
        prop.lastVotedAt = time;
        emit VoteWasRetrieved(_id, msg.sender, time);
    }

    /// @notice Implements the proposal deletion only if total vote count isn't greater than 35% of the target
    /// @dev Looks like solidity doesn't handle float numbers well, so a little hack was necessary (see: percentageAchieved)
    function proposalErase(uint _id) public proposalIsActive(_id) {
        uint256 votes = proposals[_id].voteCount;
        uint256 goal = proposals[_id].goal;
        uint256 percentageAchieved = (votes * 100) / goal;

        require(percentageAchieved < 35, "35% vote treshold achieved.");

        delete proposals[_id];
    }
}
