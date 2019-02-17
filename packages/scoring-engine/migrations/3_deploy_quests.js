const BN = require('bn.js');
const yaml = require('js-yaml');
const path = require('path');
const fs = require('fs');

var ScoringEngine = artifacts.require("./ScoringEngine.sol");
var DeploymentConfigPath = path.resolve(__dirname,'../');
var DeploymentConfig = yaml.safeLoad(fs.readFileSync(path.join(DeploymentConfigPath, 'deployment.yaml'), 'utf8'));

module.exports = function (deployer) {
    var scoringEngineInstance = await ScoringEngine.deployed();
    var quests = DeploymentConfig.quests || [];
    quests.forEach((quest)=>{
        fs.exists(path.resolve(DeploymentConfigPath, quest.package, './quest.yaml'),()=>{
            var questConfig = yaml.safeLoad(path.resolve(DeploymentConfigPath, 'deployment.yaml'));
            var questConfig = yaml.safeLoad(fs.readFileSync(path.join(DeploymentConfigPath, 'deployment.yaml'), 'utf8'));
Object.assign({}, )
        })
        quest.package
        scoringEngineInstance.addQuest(
            new BN(quest.id),


        )
    });
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
            scoringEngineInstance.addQuest.transaction
            (new BN(2), _questContract, uint256 _steps, 
            uint256[] memory _questPreReqs, uint256 _questReward)
        }
    );
    //TODO: update deploy service address
};