pragma solidity ^0.5.0;

interface RootQuestInstance{
    function getStepContract(uint id) external view returns (address);
    function getHacker() external view returns (address);
}

interface PhisherInterface{
    function goPhish(address to, uint seed) external returns (uint256);
    function deposit() external payable returns (uint);
    event PhisherPaid(address indexed _from, uint256 value, uint bag);
}

contract PhisherMan is PhisherInterface{
    uint256[] bags;
    mapping (address => uint) tries;
    constructor() public{
        for(uint i = 0; i < 10; i++){
            //bags is always 10 long
            bags.push(0);
        }
    }
    //pays out eth for "caught" inputs  
    function goPhish(address to, uint seed) external returns (uint256) {
        require(tries[msg.sender] > 0, "Need to deposit for more tries");
        uint256 random = seed + block.timestamp;
        uint256 winnings = bags[random % bags.length];
        winnings = winnings;
        (bool success,) = to.call.value(winnings)("");
        require(success, "payment transaction failed");
        emit PhisherPaid(to, winnings, random % bags.length);
        bags[random % bags.length] -= winnings;
        tries[msg.sender]--;
        return winnings;
    }
    //will create deposit inputs
    function deposit() external payable returns (uint){
        require(msg.value > 0, "Must deposit money!");
        uint256 val = msg.value;
        for(uint i = 0; i < 10; i++){
            val = val / 10;
            bags[i] += msg.value / 10;
        }
        //put non-divisible funds in 7th bag
        if(val > 0){
            bags[7] = val;
        }
        tries[msg.sender] += ((msg.value * 10) / address(this).balance);
        return tries[msg.sender];
    }

    //returns false when something has gone wrong
    function sanityCheck() external view returns (bool){
        uint256 total;
        for(uint i = 0; i < bags.length; i++){
            total += bags[i];
            if(bags[i] > address(this).balance){
                return false;
            }
        }
        return total == address(this).balance;
    }
    
}




