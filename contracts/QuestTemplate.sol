pragma solidity ^0.5.0;


interface QuestTemplate{
    function getQuestName() view external returns (string memory name);
    function testQuest(address instance) external returns (bool success);
    function spawnNextStep(address hacker) external returns (address stepAddress);
    function stepComplete(address stepAddress) external returns (bool complete);
    function stepsRemaining(address hacker) external view returns (uint steps);
}