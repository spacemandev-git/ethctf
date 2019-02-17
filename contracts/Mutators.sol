pragma solidity >=0.5.0 <0.6.0;
  
contract Mutators{
  struct Blockchain{
    uint256 chainID;
    uint256 chainType;
    address chainOwner;

    //"Health", goes down if during a mine your market value is less than some 'attractive value' or your computation power is too low
    //if it goes below 1, your blockchain dies
    uint256 nodes; 

    uint256 blockHeight;
    //modified by difficulty - computation power
    uint256 baseMineSpeed; 
    uint256 lastBlockNum;

    uint256 computationPower;
    uint256 patches;
    uint256 difficulty;
    uint256 marketValue; 
    
    mapping(address => uint256) playerRewards; 
    mapping(address => mapping(uint256 => uint256)) playerContributions; 
  }

}  
  