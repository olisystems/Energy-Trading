var OliDetail  = artifacts.require("OliDetail");
var OliCoin    = artifacts.require("OliCoin");
var ParentAuction = artifacts.require("ParentAuction");
var DaughterAuction = artifacts.require("DaughterAuction");
var BilateralTrading = artifacts.require("BilateralTrading");
var DynamicGridFee = artifacts.require("DynamicGridFee");



module.exports = function(deployer) {
  deployer.deploy(OliDetail);
  deployer.deploy(OliCoin);
  deployer.deploy(ParentAuction);
  deployer.deploy(DaughterAuction);
  deployer.deploy(BilateralTrading);
  deployer.deploy(DynamicGridFee);
};
