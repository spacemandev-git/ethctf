pragma solidity ^0.5.0;
import "./InstanceContracts.sol";

interface QuestInterface{
  function testStep(uint step, RootQuestInstance instance) external returns (bool);
}