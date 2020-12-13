//var ERC721MNT = artifacts.require("./ERC721MNT");
//var MinterContract = artifacts.require("./MinterContract");
//var ERC20MNT = artifacts.require("./ERC20MNT");
var BouncerProxy = artifacts.require("./BouncerProxy");

module.exports = function(deployer) {
//	deployer.deploy(ERC721MNT, "MintableToken", "MNT");
//	deployer.deploy(MinterContract, "0x731b48468FDBC484A90e5A8dFe7Bd1EdAC3844Fb");
//	deployer.deploy(ERC20MNT, "10000000000000000000");
	deployer.deploy(BouncerProxy);

}
