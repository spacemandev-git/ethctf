pragma solidity >=0.5.0 <0.6.0;

contract Blockchains{
  mapping(uint256 => Blockchain) blockchainsById;
  address owner;
  address mutator; 

  struct Blockchain{
    uint256 chainID;
    uint256 chainType;
    address chainOwner;

    //"Health", goes down if during a mine your market value is less than some 'attractive value' or your computation power is too low
    //if it goes below 1, your blockchain dies
    uint256 nodes; 

    uint256 blockHeight;
    uint256 baseMineSpeed;     //modified by difficulty - computation power
    uint256 lastBlockNum;

    uint256 computationPower;
    uint256 patches;
    uint256 difficulty;
    uint256 marketValue; 
    
    mapping(address => uint256) playerRewards; //how many rewards the player has earned from mining
    mapping(address => uint256) playerContributions; //doesn't keep track of what cards were contributed, only how many
  }
  uint[] internal allBlockchains;

  constructor() public {
    owner = msg.sender;
  }

  modifier isOwner() {
    require(msg.sender == owner, "This function can only be called by the owner");
    _;
  }
  modifier isMutator(){
    require(msg.sender == mutator, "This function can only be called by the mutator contract");
    _;
  }
  modifier chainExists(uint256 chainID){
    require(blockchainsById[chainID].chainID != 0, "Chain does not exist");
    _;
  }

  function updateMutator(address _mutator) public isOwner(){
    mutator = _mutator;
  }

  function spawnBlockchain(
    address _chainOwner,
    uint256 _chainType,
    uint256 _baseMineSpeed,
    uint256 _startingNodes,
    uint256 _startingComputationPower,
    uint256 _startingPatches,
    uint256 _startingDifficulty,
    uint256 _startingMarketValue
  ) public isMutator() returns(uint256 bID){
    bID = allBlockchains.length;
    Blockchain memory newChain = Blockchain({
      chainID: bID,
      chainType: _chainType,
      chainOwner: _chainOwner,
      nodes: _startingNodes,
      blockHeight: 0,
      lastBlockNum: 0,
      baseMineSpeed: _baseMineSpeed,
      computationPower: _startingComputationPower,
      patches: _startingPatches,
      difficulty: _startingDifficulty,
      marketValue: _startingMarketValue
    });

    blockchainsById[bID] = newChain;
  }


  // Get Chain Stats
  function getChainInfo(uint256 chainID) public view chainExists(chainID)
  returns( address chainOwner, uint256 chainType){
    return (blockchainsById[chainID].chainOwner,blockchainsById[chainID].chainType);
  }

  function getChainNodes(uint256 chainID) public view chainExists(chainID) returns(uint256 _nodes){
    return blockchainsById[chainID].nodes;
  }

  function getChainAttributes(uint256 chainID) public view chainExists(chainID) 
  returns(uint256 _cpu, uint256 _patches, uint256 _diff, uint256 value)
  {
    return(
      blockchainsById[chainID].computationPower,
      blockchainsById[chainID].patches,
      blockchainsById[chainID].difficulty,
      blockchainsById[chainID].marketValue
    );
  }
  
  function getChainBlockCreationInfo(uint256 chainID) public view chainExists(chainID)
  returns(uint256 _base, int _mod, uint256 _lastMined){ 
    return(
      blockchainsById[chainID].baseMineSpeed,
      getChainMineModifier(chainID),
      blockchainsById[chainID].lastBlockNum
    );
  }

  function getChainMineModifier(uint256 chainID) public view chainExists(chainID) returns(int mod){
    mod = int(blockchainsById[chainID].difficulty) - int(blockchainsById[chainID].computationPower); 
  }

  function getPlayerRewards(uint256 chainID, address hacker) public view chainExists(chainID) returns(uint256 _playerRewards){
    return blockchainsById[chainID].playerRewards[hacker];
  }

  function cardsContributedByPlayer(uint256 chainID, address hacker) public view returns(uint256 cardsContributed){
    cardsContributed = blockchainsById[chainID].playerContributions[hacker];
  }

  function isBlockchainAlive(uint256 chainID) public view chainExists(chainID)returns(bool){
    if(blockchainsById[chainID].nodes>0){
      return true;
    } else {
      return false;
    }
  }


  // Mutator Functions \\
  function mutateChainType(uint256 chainID, uint256 newType) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].chainType = newType;
  }

  function mutateChainOwner(uint256 chainID, address newOwner) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].chainOwner = newOwner;
  }
  function mutateChainNodes(uint256 chainID, uint256 newNodes) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].nodes = newNodes;
  }
  function mutateChainBlockHeight(uint256 chainID, uint256 newHeight) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].blockHeight = newHeight;
  }
  function mutateChainBaseMineSpeed(uint256 chainID, uint256 newSpeed) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].baseMineSpeed = newSpeed;
  }
  function mutateChainLastBlockNum(uint256 chainID, uint256 newNum) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].lastBlockNum = newNum;
  }
  function mutateChainComputationPower(uint256 chainID, uint256 newCpu) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].computationPower = newCpu;
  }
  function mutateChainPatches(uint256 chainID, uint256 newPatches) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].patches = newPatches;
  }
  function mutateChainDifficulty(uint256 chainID, uint256 newDiff) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].difficulty = newDiff;
  }
  function mutateChainMarketValue(uint256 chainID, uint256 newValue) public isMutator() chainExists(chainID) {
    blockchainsById[chainID].marketValue = newValue;
  }

  //playerrewards playercontributions

  function mutatePlayerRewards(uint256 chainID, address hacker, uint256 newRewards) public isMutator() chainExists(chainID){
    blockchainsById[chainID].playerRewards[hacker] = newRewards;
  }
  function mutatePlayerContributions(uint256 chainID, address hacker, uint256 newContributions) public isMutator() chainExists(chainID){
    blockchainsById[chainID].playerContributions[hacker] = newContributions;
  }
}