var NFTStore = artifacts.require("./NFTStore.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};