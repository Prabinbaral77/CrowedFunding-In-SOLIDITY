//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract CrowedFunding {
    mapping(address => uint) public contributer;
    address public manager;
    uint public minContribution;
    uint public target;
    uint public deadline;
    uint public noOfContributer;
    uint public raisedAmount;


    struct Request {
        string description;
        address payable recipient;
        uint noOfVoters;
        bool completed;
        uint value;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public noOfRequests;

    // giving the default value in constructor for testing
    uint targetValue = 10000;
    uint deadlineValue = 36000;
    mapping(address => uint) balances;


    constructor() {
        manager = msg.sender;
        deadline = block.timestamp + deadlineValue;
        target = targetValue;
        minContribution = 100 wei;

        //for suitable testcases
        balances[msg.sender] = 100000 wei;
    }

    //only for test case
    function makeTransaction(address to, uint amount) external {
        balances[to] += amount;
        balances[msg.sender] -= amount;
    }

    function balanceOf(address account) external view returns(uint) {
        return balances[account];
    }

    function sendEth() external payable {
        require(block.timestamp < deadline, "You cannot donate after deadline.");
        require(msg.value > minContribution, "Minimum contribution of 100 wei required.");
        if(contributer[msg.sender] == 0) {
            noOfContributer += 1;
        }
        contributer[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }


    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }

    function refund() public {
        require(block.timestamp > deadline && raisedAmount < target, "You are not eligible to refund.");
        require(contributer[msg.sender] > 0, "You didnot contribute for this project.");
        address payable user = payable(msg.sender);
        user.transfer(contributer[msg.sender]);
        contributer[msg.sender] = 0;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyManager {
        Request storage newRequest = requests[noOfRequests];
        noOfRequests ++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public {
        require(contributer[msg.sender] > 0, "You must contribute to vote");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You have already voted.");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters ++;
    }

    function makePayment(uint _requestNo) public {
        require(raisedAmount >= target, "Required Amount is not raised.");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request has already been completed.");
        require(thisRequest.noOfVoters > noOfContributer / 2, "Majority vote is required to proceed payment.");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }
}