const BN = require('bn.js');
const yaml = require('js-yaml');
const path = require('path');
const fs = require('fs');
const solc = require('solc');
const contract = require('truffle-contract');

var ScoringEngine = artifacts.require("./ScoringEngine.sol");
var DeploymentConfigPath = path.resolve(__dirname,'../');
var DeploymentConfig = yaml.safeLoad(fs.readFileSync(path.join(DeploymentConfigPath, 'deployment.yaml'), 'utf8'));

module.exports = function (deployer) {
    var scoringEngineInstance = ScoringEngine.deployed();
    var quests = DeploymentConfig.quests || [];
    quests.forEach((questDeployment)=>{
        var manifestPath = path.resolve(DeploymentConfigPath, questDeployment.package, './manifest.yaml');
        var questContract = { abi: JSON.parse(
            fs.readFileSync(path.resolve(DeploymentConfigPath, questDeployment.package, './Quest.abi')
        ))};
        // create quest contract
        const QuestContract = contract(questContract);
        QuestContract
            .setProvider(web3.currentProvider);

            var questManifest = yaml.safeLoad(fs.readFileSync(manifestPath, 'utf8'));

            var instance = QuestContract.new(); 
            deployer.deploy(QuestContract).then(()=>{
                scoringEngineInstance.addQuest(
                    new BN(questDeployment.id),
                    instance.address,
                    new BN(questManifest.steps.length),
                    [],
                    new BN(questDeployment.reward)
                );
            })
    });
    //TODO: update deploy service address
};