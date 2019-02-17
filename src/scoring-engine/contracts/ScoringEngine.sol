pragma solidity >=0.5.0 <=0.6.0;
//import Quest Interface
//import NFT Shop
//vulnerability contract
//blockchain interface

interface QuestInterface{
  function getQuestName() external pure returns (string memory name);
  function getStepInfo(uint step) external pure returns (string memory url);
  function deployStep(uint step) external returns (address _step);
  function testStep(uint step, address rootQuestInstance) external returns (bool);
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
  address payable deployWallet;
  address assetShop; //replace with AssetShop interface type
  address mutations; //replace with Mutations type 

  mapping(address => uint256) ethWallet; //used to deploy contracts


  event NewQuestAdded(uint indexed questID,  QuestInterface indexed questContract, uint questSteps, uint questReward, uint[] questPreReqs);
  event QuestNewReward(uint indexed questID, uint newQuestRewards);
  event NewQuestProgress(uint indexed questID, address indexed hacker, uint changedProgress);
  event QuestCompleted(uint indexed questID, address indexed hacker);
  event DeployedContract(uint indexed _questID, address indexed deployedFor, string description, address contractAddress, string contractSource);
  event RequestQuest(uint indexed _questID, address indexed hacker);
  event QuestDeployed(uint indexed _questID, address indexed hacker, address rootContractInstance);

  constructor() public {
    owner = msg.sender;
  }

  modifier isOwner(){
    require(msg.sender == owner, "This function can only be called by the owner"); 
    _;
  }

  modifier onlyDeployWallet(){
    require(msg.sender == deployWallet, "This function can only be caleld by the deploy service");
    _;
  }

  modifier doesQuestExist(uint _questID) {
    require(quests[_questID].rewardPoints > 0, "Quest doesn't exist");
    _;
  }

  modifier isQuestInProgress(uint _questID){
    require(quests[_questID].progressByPlayer[msg.sender] > 0, "Quest is not in progress");
    _;
  }

  function setDeployServiceWalletAddress(address payable _deployWallet) isOwner() public {
    deployWallet = _deployWallet;
  }


  function addQuest(uint256 _newQuestID, QuestInterface _questContract, uint256 _steps, uint256[] memory _questPreReqs, uint256 _questReward) public isOwner(){
    //break if quest already exists; opposite from doesQuestExist which breaks if quest DOESN'T EXIST
    require(quests[_newQuestID].rewardPoints == 0, "QuestID already exist");
    //1.5 Check to make sure the new rewards is greater than 0
    require(_questReward > 0, "Reward cannot be 0 points");
    //2. Check if Prereqs exist in the system
    for(uint i = 0; i<_questPreReqs.length; i++){
      require(quests[i].rewardPoints == 0, "Some pre reqs don't exist");
    }
    //3. Create new quest, add to quests lists 
    quests[_newQuestID] = Quest({
      contractAddress: _questContract,
      steps: _steps,
      preReqs: _questPreReqs,
      rewardPoints: _questReward
    });

    emit NewQuestAdded(_newQuestID, _questContract, _steps, _questReward, _questPreReqs);
    
  }
  function modifyQuestReward(uint256 _questID, uint256 _rewards) public isOwner() doesQuestExist(_questID){
    //change the reward value
    quests[_questID].rewardPoints = _rewards;

    emit QuestNewReward(_questID, _rewards);
  }
  //TODO: function questResetForPlayer(){}

  function startQuest(uint256 _questID) doesQuestExist(_questID) public { 
    /// quest isn't in progress or completed (quest is available)
    require(quests[_questID].progressByPlayer[msg.sender] == 0);
    
    //quest PreReqs are completed
    for(uint i=0; i<quests[_questID].preReqs.length; i++){
      require(quests[i].progressByPlayer[msg.sender] > quests[i].steps, "A quest pre req is not finished");
    }

    // launch player quest // TODO: REQUEST CONTRACT DEPLOYMENT BY ORACLE
    //address vulnerableContract = quests[_questID].contractAddress.deployStep(1, msg.sender); //deploy first step for hacker
    //emit QuestStarted(_questID, msg.sender, vulnerableContract)

    emit RequestQuest(_questID, msg.sender);
  }

  function testCurrentStep(uint256 _questID, address _rootQuestInstance) doesQuestExist(_questID) isQuestInProgress(_questID) public returns(bool success){
    //increment progress
    if(quests[_questID].contractAddress.testStep(quests[_questID].progressByPlayer[msg.sender], _rootQuestInstance)){
      quests[_questID].progressByPlayer[msg.sender]++;
      return true;
      emit NewQuestProgress(_questID, msg.sender, quests[_questID].progressByPlayer[msg.sender]);
    } else {
      return false;
    }
  }

  //TODO: Award Coins to player (requires Bank)
  function completeQuest(uint256 _questID) isQuestInProgress(_questID) public {
    //check quest steps to see if it's higher than total steps
    require(quests[_questID].progressByPlayer[msg.sender] > quests[_questID].steps, "Not all steps completed");
    //award points to player
    leaderboard[msg.sender] += quests[_questID].rewardPoints; //should probably safe math all of this later
    //TODO: award coins to player
    emit QuestCompleted(_questID, msg.sender);
  }  

  function depositIntoWallet() payable public returns (uint256 newBalance){
    //should safemath this
    ethWallet[msg.sender] += msg.value;
    return ethWallet[msg.sender];
  }

  function getWalletBalance() public view returns(uint256 balance){
    return ethWallet[msg.sender];
  }

  function widrawFromWallet(uint256 weiAmt) public {
    require(weiAmt < ethWallet[msg.sender], "Not enough Wei to widraw");
    msg.sender.transfer(weiAmt);
  }

  //Deploy service calls this every time it finishes a deploy
  //Take cost of deploy (find cost by doing fake deploy on node)
  function reserveDeployFunds(uint256 cost) public onlyDeployWallet() returns (bool success){
    require(ethWallet[msg.sender] > cost, "Hacker does not have enough funds to deploy this contract"); 
    ethWallet[msg.sender] -= cost;
    return true;
  }

  //contractSource should be a link to the source code for that contract
  function deployedContract(uint256 _questID, address deployedFor, string memory description, address contractAddress, string memory contractSource, uint256 cost) onlyDeployWallet() public {
    //call events and take money
    deployWallet.transfer(cost); //already subtracted from hacker wallet in reserve step
    emit DeployedContract(_questID, deployedFor, description, contractAddress, contractSource);
  } 

  function questDeployFinished(uint256 _questID, address deployedFor, address rootContractInstance) public{
    emit QuestDeployed(_questID, deployedFor, rootContractInstance);
  } 

}

