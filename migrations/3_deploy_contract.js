// Note to Ben, Brad added this file and is not sure it is correct

var MRMP = artifacts.require("MRMP");

module.exports = function(deployer) {
  deployer.deploy(MRMP);
};
