// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Submission is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    mapping(address => bool) private hasClaimed;
    Issue[] private issues;

    error TokensClaimed();
    error NoTokensHeld();
    error AlreadyVoted();

    constructor() ERC20("VoteToken", "VTK") {}

    function claim() external {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(
        string memory _issueDesc,
        uint256 _quorum
    ) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(
        uint256 _id
    ) external view returns (ReturnableIssue memory) {
        Issue storage issue = issues[_id];
        return
            ReturnableIssue(
                issue.voters.values(),
                issue.issueDesc,
                issue.votesFor,
                issue.votesAgainst,
                issue.votesAbstain,
                issue.totalVotes,
                issue.quorum,
                issue.passed,
                issue.closed
            );
    }

    function vote(uint256 _issueId, Vote _vote) external {
        Issue storage issueToVote = issues[_issueId];
        if (issueToVote.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voteWeight = balanceOf(msg.sender);
        issueToVote.voters.add(msg.sender);

        if (_vote == Vote.FOR) {
            issueToVote.votesFor += voteWeight;
        } else if (_vote == Vote.AGAINST) {
            issueToVote.votesAgainst += voteWeight;
        } else {
            issueToVote.votesAbstain += voteWeight;
        }

        issueToVote.totalVotes += voteWeight;

        if (issueToVote.totalVotes >= issueToVote.quorum) {
            issueToVote.closed = true;
            if (issueToVote.votesFor > issueToVote.votesAgainst) {
                issueToVote.passed = true;
            }
        }
    }
}
