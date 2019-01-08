// Given the following election contract which uses the hash-commit-reveal scheme,
// implement the logic for the constructor, commitVote() and revealVote() functions.
// Assume that vote hashes are generated using keccak256,
// and votes are submitted in the format: “1-somepassword” (if voting for choice1 )
// or “2-someotherpassword” (if voting for choice2).
// Voters can only submit one vote and reveal one vote.
// All submitted votes must be revealed before announcing a winner.
// Add any state variables or functions you need, and emit the ElectionWinner event to announce the winner.

pragma solidity 0.4.24;

contract CommitRevealElection {
    string public candidate1;
    string public candidate2;
    uint   public commitPhaseEndTime;

    event ElectionWinner(string winner, uint voteCount);

    // Add any other state variables you need
    uint public votesForCandidate1;
    uint public votesForCandidate2;
    uint public numberOfVotesCast = 0;

    bytes32[] public voteCommits;
    mapping (bytes32 => string) voteStatuses;

    constructor(uint _commitPhaseDurationInMinutes, string _candidate1, string _candidate2) public {
        commitPhaseEndTime = now + _commitPhaseDurationInMinutes * 1 minutes;
        candidate1 = _candidate1;
        candidate2 = _candidate2;
    }

    // _voteHash is computed based on the keccak256 of user's
    // vote and their password of their choice
    // e.g. keccak256('1-votersPassword')
    function submitVote(bytes32 _voteHash) public {
        require (now < commitPhaseEndTime, "voting period has ended");

        // make sure this hasn't voted before
        bytes memory voteCommit = bytes(voteStatuses[_voteHash]);
        require (voteCommit.length == 0);

        voteCommits.push(_voteHash);
        voteStatuses[_voteHash] = "Committed";
        numberOfVotesCast++;
    }

    // _vote is the msg that was hashed in submitVote (e.g. '1-votersPassword')
    // Add checks to make sure the _vote is in the correct format,
    // otherwise don't count the vote.
    function revealVote(string _vote) public {
        require(now > commitPhaseEndTime, "voting period not ended yet");

        // verify vote is valid
        bytes memory voteStatus = bytes(voteStatuses[_voteHash]);
        if (voteStatus.length == 0) {
            // vote not cast
        } else if (voteStatus[0] != "C") {
            // vote already cast
            return;
        }

        // Check vote format here
        require (_vote[0] == "1" || _vote[1] == "2", "vote not in correct format");

        if (_vote[0] == "1") {
            votesForCandidate1 = votesForCandidate1 + 1;
        } else if (_vote[0] == "2") {
            votesForCandidate2 = votesForCandidate2 + 1;
        }

        // !!! TBD - change vote status to "Revealed" here
        //
        //
    }

    // Only announce winner when everyone who submitted their vote has revealed their vote
    function announceWinner() public {
    }
}
