pragma solidity ^0.5.4;

interface PhisherInterface{
    function goPhish(uint seed) external returns (uint256);
    function deposit() external payable;
    event PhisherPaid(address indexed _from, uint256 value, uint bag);
}

contract PhisherMan is PhisherInterface{
    uint256[] bags;

    constructor() public{
        for(uint i = 0; i < 10; i++){
            //bags is always 10 long
            bags.push(0);
        }
    }
    //pays out eth for "caught" inputs  
    function goPhish(uint seed) external returns (uint256) {
        uint256 random = seed + block.timestamp;
        uint256 winnings = bags[random % bags.length];
        winnings = winnings / 2; //you only ever win half of the bag
        (bool success,) = msg.sender.call.value(winnings)("");
        require(success);
        emit PhisherPaid(msg.sender, winnings, random % bags.length);
        bags[random % bags.length] -= winnings;
        return winnings;
    }
    //will create deposit inputs
    function deposit() external payable{
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
    }

    //returns false when something has gone wrong
    function sanityCheck() external view returns (bool){
        uint256 total;
        for(uint i = 0; i < bags.length; i++){
            total += bags[i];
        }
        return total == address(this).balance;
    }
    
}


