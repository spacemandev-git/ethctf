pragma solidity ^0.5.4;
import "./InstanceContracts.sol";

interface QuestInterface{
  function testStep(uint step, RootQuestInstance instance) external returns (bool);
}