pragma solidity >=0.5.0 <=0.6.0;
//import Quest Interface
//import NFT Shop
//vulnerability contract
//blockchain interface

interface QuestInterface{
    function getQuestName() external pure returns (string memory name);
    function getStepInfo(uint step) external pure returns (string memory url);
    function deployStep(uint step) external returns (address step);
    function testStep(uint step, address stepContract) external returns (bool);
    function stepMaxCount() external pure returns (uint);
}


contract ScoringEngine{

  struct Quest{
    QuestInterface contractAddress;
    mapping(address => uint256) progressByPlayer;
    uint256 steps;
    uint256[] preReqs;
    uint256 rewardPoints;
  }
  mapping(uint256 => Quest) quests; //questID => questContract address

  mapping(address => uint256) leaderboard; //user addresses to their respective points
  mapping(uint256 => address) blockchains; //blockchainID => address of the blockchain contract
  address owner; 
  address AssetShop; //replace with AssetShop interface type
  address Mutations; //replace with Mutations type 

  event NewQuestAdded(uint indexed questID,  address indexed questContract, uint questSteps, uint questReward, uint[] questPreReqs);
  event QuestNewReward(uint indexed questID, uint newQuestRewards);
  event QuestStarted(uint indexed questID, address indexed hacker);


  constructor() public {
    owner = msg.sender;
  }

  modifier isOwner(){
    require(msg.sender == owner, "This function can only be called by the owner"); 
    _;
  }

  modifier doesQuestExist(_questID) {
    require(quests[_questID] != 0, "Quest doesn't exist");
    _;
  }

  modifier isQuestInProgress(_questID){
    require(quests[_questID].progressByPlayer[msg.sender] == 1, "Quest is not in progress");
    _;
  }
  function addQuest(uint256 _newQuestID, address _questContract, uint256 _steps, uint256[] memory _questPreReqs, uint256 _questReward) public isOwner() does{
    //1. Check if questID exists
    require(quests[_questID] == 0, "QuestID already exist");
    //1.5 Check to make sure the new rewards is greater than 0
    require(_questReward > 0, "Reward cannot be 0 points");
    //2. Check if Prereqs exist
    for(uint i = 0; i<_questPreReqs.length; i++){
      require(quests[i] != 0, "Some pre reqs don't exist");
    }
    //3. Create new quest, add to quests lists 
    quests[_newQuestID] = new Quest({
      contractAddress: _questContract,
      steps: _steps,
      preReqs: _questPreReqs,
      rewardPoints: _questReward
    });

    emit NewQuestAdded(_newQuestID, _questContract, _steps, _questReward, _questPreReqs);
    
  }
  function modifyQuestReward(uint256 _questID, uint256 _rewards) public isOwner() doesContractExist(_questID){
    //change the reward value
    quests[_questID].rewardPoints = _rewards;

    emit QuestNewReward(_questID, _rewards);
  }
  //TODO: function questResetForPlayer(){}

  function startQuest(uint256 _questID) doesQuestExist(_questID) public { 
    /// quest isn't in progress or completed (quest is available)
    require(quests[_questID].progressByPlayer[msg.sender] == 0);
    
    //quest PreReqs are completed
    for(uint i=0; i<quests[_questID].preReqs.length; ++){
      require(quest[i].progressByPlayer[msg.sender] == quest[i].steps, "A quest pre req is not finished");
    }

    // launch player quest // TODO: REQUEST CONTRACT DEPLOYMENT BY ORACLE
    address vulnerableContract = quests[_questID].contractAddress.deployStep(1, msg.sender); //deploy first step for hacker

    emit QuestStarted(_questID, msg.sender)
  }


  //TODO: function completeQuest(uint256 _questID) public {
    //check if quest is in progress
    require(questProgress[msg.sender][_questID] == 1, "Quest is not in progress");    
    //check quest contract to see if it's complete
    require(questContracts[_questID].isQuestComplete[msg.sender] == true, "Not all quest steps completed");
    //change quest progress to completed
    //award points to player
    //award coins to player
  }  

}

