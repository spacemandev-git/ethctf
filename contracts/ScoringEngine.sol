pragma solidity >=0.5.0 <=0.6.0;

contract ScoringEngine{
  mapping(address => uint256) leaderboard; //user addresses to their respective points
  mapping(uint256 => address) quests; //quest_id to quest testing contract deployment
  address owner; 


  constructor() public {
    owner = msg.sender;
  }

  modifier isOwner(){
    require(msg.sender == owner, "This function can only be called by the owner"); 
    _;
  }

  function addQuest(address questContract) isOwner(){

  }

}

