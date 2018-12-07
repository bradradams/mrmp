var RMPcontract = artifacts.require("RMPcontract");
var MRMP = artifacts.require("MRMP");

module.exports = function(deployer) {

  deployer.deploy(RMPcontract).then(function() {
    return deployer.deploy(MRMP, RMPcontract.address);
  });
};
