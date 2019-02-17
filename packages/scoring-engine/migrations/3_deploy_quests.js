var ScoringEngine = artifacts.require('./ScoringEngine.sol')

module.exports = function(deployer) {
    
    deployer.deploy(ScoringEngine);
    //TODO: update deploy service address
  };