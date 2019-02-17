const BN = require('bn.js');

var ScoringEngine = artifacts.require("./ScoringEngine.sol");

module.exports = function (deployer) {
    var scoringEngineDeployment = deployer.deploy(ScoringEngine);
    scoringEngineDeployment.then(
        function () {
            //ScoringEngine.address;
            var scoringEngineInstance = await ScoringEngine.at(ScoringEngine.address);
            scoringEngineInstance.addQuest.transaction(new BN(1), _questContract, uint256 _steps, uint256[] memory _questPreReqs, uint256 _questReward)
        }
    );
    scoringEngineDeployment.then(
        function () {
            //ScoringEngine.address;
            var scoringEngineInstance = await ScoringEngine.at(ScoringEngine.address);
            scoringEngineInstance.addQuest.transaction(new BN(2), _questContract, uint256 _steps, uint256[] memory _questPreReqs, uint256 _questReward)
        }
    );
    //TODO: update deploy service address
};