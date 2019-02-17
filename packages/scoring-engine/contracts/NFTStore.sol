pragma solidity >=0.5.0 <=0.6.0; 

contract NFTStore{
  // DATA \\
  //playerInventory[playerAddr][tokenID] for how many cards of type X the player has
  mapping(address => mapping(uint256 => uint256)) playerInventory;
  //coins used to buy tokens. awarded by Scoring Engine or by owner
  mapping(address => uint256) playerCoins; 
  uint256[] internal allAssetIDs; //maintains tokenId list
  mapping(uint256 => Asset) assetsById; 
  address public owner; //should and can be a Scoring Engine normally, but also fine as a person for modularity
  bool exists;
  struct Asset{
    string name;
    string description;
    string imgLink;
    uint256 cardType; // can be changed based on stuff, for us 1: attack, 2: defense
    uint256 forceLevel;
    uint256 cunningLevel;
    uint256 wealthLevel;
    uint256 price;
    uint256 globalID; //when spawning new cards try to get them their preferred global ID rather than just increment
  }


  // EVENTS \\
  event TransferWithQuantity(address indexed from, address indexed to, uint256 indexed tokenID, uint256 quanity);
  event BatchTransfer(address indexed from, address indexed to, uint256[] tokenTypes, uint256[] amounts);
  event PlayerBoughtCards(address indexed hacker, uint256 indexed tokenID, uint256 quantity);
  event AssetCreated(uint256 indexed tokenID, string indexed name, uint256 price);

  //Mods
  modifier isOwner() {
    require(msg.sender == owner, "This function can only be run by the owner");
    _;
  }

  modifier assetExists(uint256 tokenID) {
    require(assetsById[tokenID].globalID != 0, "Asset doesn't exist");
    _;
  }
  // FUNCTIONS \\
  constructor() public{
    owner = msg.sender;
    exists = true;
  }
  function cExists() public view returns(bool) {return exists;}
  function updateOwner(address newOwner) public isOwner() {
    owner = newOwner;
  }

  function transfer(address to, uint256 _tokenID, uint256 quantity) public returns(bool){
    require(playerInventory[msg.sender][_tokenID] > quantity, "Not enough cards of that type to transfer");
    playerInventory[msg.sender][_tokenID] -= quantity;
    playerInventory[to][_tokenID] += quantity;

    emit TransferWithQuantity(msg.sender, to, _tokenID, quantity);
    return true;
  }

  function balanceOf(address _owner, uint256 _tokenID) public view returns (uint256 tokenBalance) {
    return playerInventory[_owner][_tokenID];  
  }

  function buyAsset(uint256 _tokenID, uint256 quantity) public assetExists(_tokenID) {
    //1. Cost = _tokenID.price * quantity, see if player has enough Coins
    uint256 costOfPurchase = assetsById[_tokenID].price * quantity;
    require(playerCoins[msg.sender] > costOfPurchase, "Not enough coins to buy cards!");
    //2. Issue cards
    playerCoins[msg.sender] -= costOfPurchase;
    playerInventory[msg.sender][_tokenID] += quantity;
    emit PlayerBoughtCards(msg.sender, _tokenID, quantity);
  } 

  function rewardCoinsToPlayer(address hacker, uint256 quantity) public isOwner() returns(uint256 newBalance){
    playerCoins[hacker] += quantity;
    return playerCoins[hacker];
  }

  function addAsset(
    string memory _name,
    string memory _description,
    string memory _imgLink,
    uint256 _cardType,
    uint256 _forceLevel,
    uint256 _cunningLevel,
    uint256 _wealthLevel,
    uint256 _price,
    uint256 _globalID
  ) public isOwner() {
    // Maybe do data santization on the inputs?
    // ID can't be 0
    require(_globalID != 0, "ID can't be 0");
    // Check if asset by that id already exists
    require(assetsById[_globalID].globalID != _globalID, "Asset ID already exists");
    
    //Add asset to AssetByID mapping
    assetsById[_globalID] = Asset({
      name: _name,
      description: _description,
      imgLink: _imgLink,
      cardType: _cardType,
      forceLevel: _forceLevel,
      cunningLevel: _cunningLevel,
      wealthLevel: _wealthLevel,
      price: _price,
      globalID: _globalID
    });
    //Add ID to allAssetIDs
    allAssetIDs.push(_globalID);
    // emit New Asset Added event (id, name, price)
    emit AssetCreated(_globalID, _name, _price);
  }

  //sets Asset ID to 0 so it can be overwritten with another asset of it's 
  // IF YOU DON'T REPLACE THE ASSET IT'LL BREAK A LOT OF THINGS
  // MAYBE REPLACE WITH NEW ASSET INFO FUNCTION
  //TODO: function disableAsset(uint256 tokenID)  isOwner() assetExists(tokenID) public {}

  function getAssetDescriptors(uint256 tokenID) public view assetExists(tokenID) 
  returns(string memory name, string memory description, string memory imgLink) {
    return(
      assetsById[tokenID].name,
      assetsById[tokenID].description,
      assetsById[tokenID].imgLink
    );
  }
  function getAssetStats(uint256 tokenID) public view assetExists(tokenID) 
  returns(uint256 cardType,uint256 forceLvl,uint256 cunningLvl,uint256 wealthLvl) {
    return(
      assetsById[tokenID].cardType,
      assetsById[tokenID].forceLevel,
      assetsById[tokenID].cunningLevel,
      assetsById[tokenID].wealthLevel
    );
  }
  function getAssetPrice(uint256 tokenID) public view assetExists(tokenID) returns(uint256 priceInCoins){
    return assetsById[tokenID].price;
  }

}
