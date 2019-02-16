var Migrations = artifacts.require("./Migrations.sol");
var QuestTemplate = artifacts.require("./QuestTemplate.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(QuestTemplate, "0x36afe7e4f84bf8fccca461f4ccd850d90813ea44");
};
