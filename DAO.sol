// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }

    address public chairperson;
    mapping(address => bool) public members;
    Proposal[] public proposals;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(address voter, uint256 proposalId);
    event ProposalExecuted(uint256 proposalId);

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Not chairperson");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    constructor() {
        chairperson = msg.sender;
    }

    function addMember(address member) external onlyChairperson {
        members[member] = true;
    }

    function createProposal(string memory description) external onlyMember {
        proposals.push(Proposal({description: description, voteCount: 0, executed: false}));
        emit ProposalCreated(proposals.length - 1, description);
    }

    function vote(uint256 proposalId) external onlyMember {
        require(proposalId < proposals.length, "Invalid proposal");

        proposals[proposalId].voteCount += 1;
        emit Voted(msg.sender, proposalId);
    }

    function executeProposal(uint256 proposalId) external onlyChairperson {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > members.length / 2, "Not enough votes");

        proposal.executed = true;
        // Add proposal execution logic here
        emit ProposalExecuted(proposalId);
    }

    function getProposal(uint256 proposalId) external view returns (string memory description, uint256 voteCount, bool executed) {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.description, proposal.voteCount, proposal.executed);
    }
}
