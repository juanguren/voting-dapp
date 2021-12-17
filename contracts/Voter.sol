//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./structures/Elements.sol";
import "./Proposal.sol";

contract User {
    mapping(address => Voter) public voters;
    address[] public voterList;
    Proposal public proposal;

    constructor(address _proposalId) {
        proposal = Proposal(_proposalId);
    }

    function _getVoterStatus() private view returns (bool) {
        return voters[msg.sender].hasVoted;
    }

    modifier userExists() {
        bool userAlreadyCreated;
        if (voterList.length > 0) {
            for (uint256 i = 0; i < voterList.length; i++) {
                userAlreadyCreated = voterList[i] == msg.sender;
            }
        }

        require(!userAlreadyCreated, "User already exists!");
        _;
    }

    function newVoter(string memory _name, uint256 _age) public userExists {
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

    function getVoters() public view returns (address[] memory) {
        return voterList;
    }

    function getVotersCount() public view returns (uint256) {
        return voterList.length;
    }

    function buildProposal(
        address _voterId,
        string memory _proposalName,
        uint256 _target,
        uint256 _createdAt,
        uint256 _lastVotedAt
    ) public {
        string memory voterName;
        voterName = voters[_voterId].name;

        uint256 proposalId;

        Creator memory creator;
        creator.id = _voterId;
        creator.name = voterName;

        proposal.newProposal(
            proposalId,
            _proposalName,
            _target,
            _createdAt,
            _lastVotedAt,
            creator
        );
    }

    function getProposal(uint256 _id)
        public
        view
        returns (ProposalForm memory)
    {
        bool userHasVoted = _getVoterStatus();
        require(userHasVoted, "User hasn't voted yet");
        return proposal.getProposal(_id);
    }

    function voteProposal(uint256 _proposalId, uint256 _lastVotedAt) public {
        Voter storage voter = voters[msg.sender];
        require(!voter.hasVoted, "User has already voted.");

        voter.hasVoted = true;
        voter.proposalId = _proposalId;

        proposal.proposalVote(_proposalId, _lastVotedAt);
    }
}
