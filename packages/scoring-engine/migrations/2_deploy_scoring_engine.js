const BN = require('bn.js');
const Yaml = require('js-yaml');
const Path = require('path')

var ScoringEngine = artifacts.require("./ScoringEngine.sol");
var DeploymentConfigPath = Path
var DeploymentConfig = Yaml.safeLoad(__dirname,'../deployment.yaml');

module.exports = function (deployer) {
    var scoringEngineDeployment = deployer.deploy(ScoringEngine);
    //TODO: update deploy service address
};