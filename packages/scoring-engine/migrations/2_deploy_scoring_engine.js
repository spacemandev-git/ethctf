var ScoringEngine = artifacts.require("./ScoringEngine.sol");

module.exports = function (deployer) {
    var scoringEngineDeployment = deployer.deploy(ScoringEngine);
    //TODO: update deploy service address
};