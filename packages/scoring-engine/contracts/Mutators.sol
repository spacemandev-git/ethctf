pragma solidity >=0.5.0 <0.6.0;
//import "./Blockchains.sol";
//
//contract Mutators{
//  address owner;
//  Blockchains blockchains;
//
//  constructor(Blockchains bAddr) public {
//    owner = msg.sender;
//    blockchains = bAddr;
//  }
//
//  function createBlock(uint256 chainID) public {
//    //1. Check in enough blocktime has elapsed
//    require(int(block.number) > blockchains.getNextBlockAvailable(chainID),"Block can't be created yet");
//    //2. Rewards = nodes * marketValue //maybe replace with blockRewards for chains?
//    uint rewards = blockchains.getChainNodes(chainID) * blockchains.getChainMarketValue(chainID);
//    //reward players equal to their contribution points //contributions points should not be 1 card = 1 point
//    
//  }  
//
//
//}