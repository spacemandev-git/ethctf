pragma solidity ^0.5.0;

interface QuestInterface{
    function getQuestName() external pure returns (string memory name);
    function getStepInfo() external view returns (string memory url);
    function isQuestComplete(address hacker) external view returns (bool complete);
    function beginQuest(address hacker) external returns (bool success); //only usable by score engine
    function spawnStep() external returns (address stepAddress);
    function stepsRemaining(address hacker) external view returns (uint steps);
    function testStep() external returns (bool);
    function getStep() external view  returns (address step);
}

