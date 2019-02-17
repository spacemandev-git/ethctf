pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/QuestTemplate.sol";

contract TestQuestSample{
    function testStepStart() public{
        QuestTemplate quest = QuestTemplate(DeployedAddresses.QuestTemplate());
        Assert.equal(quest.beginQuest(msg.sender), true, "beginQuest must succeed");
    }
}
