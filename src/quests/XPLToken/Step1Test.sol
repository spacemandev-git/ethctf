pragma solidity ^0.5.0;

interface QuestInterface{
  function testStep(uint step, RootQuestInstance instance) external returns (bool);
}
interface RootQuestInstance{
    function getStepContract(uint id) external view returns (address);
    function getHacker() external view returns (address);
}

contract XPLTokenQuest is QuestInterface{
    //metadata goes in here somehow... 
    function testStep(uint step, RootQuestInstance instance) external returns (bool){
        return testStep1(XPLToken(instance.getStepContract(0)), instance.getHacker());
    }
    function testStep1(XPLToken token, address hacker) internal returns (bool){
        return token.testWinner(hacker);
    }    
}
