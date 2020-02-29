pragma solidity ^0.5.0;

contract VoteOption {
    VoteProposal creator;
    address owner;
    uint32 deadline;
    string name;
    string option;

    constructor(uint32 _deadline, string memory _name, string memory _option) public {
        owner = msg.sender;
        creator = VoteProposal(msg.sender);
        deadline = _deadline;
        name = _name;
        option = _option;
    }

    event AnonymousDeposit(address indexed from, uint value, string name, string option);

    function () external payable {
	    emit AnonymousDeposit(msg.sender, msg.value, name, option);
    }
}

contract VoteProposal {
    VoteProposalPool creator;
    address owner;
    uint32 deadline;
    string name;
    string data;

    mapping(uint => address) public options;

    constructor(uint32 _deadline, string memory _name, string memory _data) public {
        owner = msg.sender;
        creator = VoteProposalPool(msg.sender);
        deadline = _deadline;
        name = _name;
        data = _data;
    }

    function createOptions(uint32 _deadline, string calldata _name)
        external
        returns (VoteOption yes, VoteOption no)
    {
        yes = new VoteOption(_deadline, _name, "yes");
        no = new VoteOption(_deadline, _name, "no");
        options[0] = address(yes);
        options[1] = address(no);
    }
}

contract VoteProposalPool {

    function newVoteProposal(
        string calldata _name,
        string calldata _data,
        uint32 _deadline
    )
        external
        validateDeadline(_deadline)
        returns (VoteProposal newProposal)
    {
        newProposal = new VoteProposal(_deadline, _name, _data);
        newProposal.createOptions(_deadline, _name);
        emit newProposalIssued(
            address(newProposal),
            msg.sender,
            _deadline,
            _name,
            _data,
            "yes",
            newProposal.options(0),
            "no",
            newProposal.options(1));
    }


    modifier validateDeadline(uint32 _newDeadline) {
      require(_newDeadline > now);
      _;
    }

    event newProposalIssued(
        address proposal,
        address issuer,
        uint32 deadline,
        string name,
        string data,
        string optionA,
        address optionAaddr,
        string optionB,
        address optionBaddr);
}
