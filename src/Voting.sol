//SPDX-License-Identifier:MIT
pragma solidity 0.8.28;

contract VotingSystem {
    struct proposal{
        string title;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        address creator;
        mapping(address =>bool) voters;
        bool isDeleted;
    }

    proposal[] public proposals;

    event proposalCreated(uint proposalId, string title, string description);
    event proposalDeleted(uint256 proposald, string title);
    event voteCast(uint256 proposalId,address voter, bool vote);


    //Create Proposal
    function createProposal (
        string memory _title,
        string memory _description
    ) public {
        proposal storage newProposal = proposals.push();
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.creator = msg.sender;
        


        emit proposalCreated(proposals.length -1,_title,_description);

        
    }

    //Function to vote for a proposal
    function vote(
        uint256 _proposalId,
        bool _vote
    ) public {
        require( _proposalId <= proposals.length ,"Invalid Proposal Id");

        proposal storage _proposal = proposals[_proposalId];


        require(!_proposal.voters[msg.sender], "You have already voted");

        _proposal.voters[msg.sender] = true;

        if (_vote){
            _proposal.yesVotes++;
        }else {
            _proposal.noVotes++;
        }
        emit voteCast(_proposalId,msg.sender,_vote);
    }

    //Function to get the Proposal results
    function getProposal(
        uint256 _proposalId
    ) public view returns(
        string memory title,
        string memory description,
        uint256 yesVotes,
        uint256 noVotes
    ){
        require(_proposalId < proposals.length, "Invalid Proposal Id");
        proposal storage _proposal = proposals[_proposalId];
        return (
            _proposal.title,
            _proposal.description,
            _proposal.yesVotes,
            _proposal.noVotes

        );
    }

function deleteProposal(uint256 _proposalId) public {
    require(_proposalId < proposals.length, "Invalid Proposal Id");

    proposal storage _proposal = proposals[_proposalId];

    require(msg.sender == _proposal.creator, "Only the creator can delete this proposal");

    // Mark the proposal as deleted
    _proposal.isDeleted = true;

    emit proposalDeleted(_proposalId, _proposal.title);
}

    }