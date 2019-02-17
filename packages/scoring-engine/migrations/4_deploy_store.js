var NFTStore = artifacts.require("./NFTStore.sol");
var ScoringEngine = artifacts.require("./ScoringEngine.sol");

module.exports = function(deployer) {
  deployer.deploy(NFTStore).then(()=>{
    var nftStoreInstance = await NFTStore.deployed();
    var scoringEngineInstance = await ScoringEngine.deployed();
    nftStoreInstance.updateOwner(ScoringEngine.address)
  });
};