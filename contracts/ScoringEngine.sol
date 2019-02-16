pragma solidity >=0.5.0 <=0.6.0;
//import Quest Interface
//import NFT Shop
//vulnerability contract
//blockchain interface

contract ScoringEngine{
  mapping(address => uint256) leaderboard; //user addresses to their respective points
  mapping(address => mapping(uint256 => uint256)) quests; // user.questID.questprogress  //0: unavailable, 1:inprogress, 2: complete
  mapping(uint256 => uint256[]) questPreReqs; //questID => ids of prereq quests
  mapping(uint256 => uint256) questRewards; 
  mapping(uint256 => address) blockchains; //blockchainID => address of the blockchain contract
  address owner; 


  constructor() public {
    owner = msg.sender;
  }

  modifier isOwner(){
    require(msg.sender == owner, "This function can only be called by the owner"); 
    _;
  }

  function addQuest(address _questContract, uint256[] memory _questPrereqs, uint256 _questReward) public isOwner(){}
  function modifyQuestReward(uint256 _questID, uint256 _rewards) public isOwner() {}

  function startQuest(uint256 _questID) public {}
  function completeQuest(uint256 _questID) public {}  

}

