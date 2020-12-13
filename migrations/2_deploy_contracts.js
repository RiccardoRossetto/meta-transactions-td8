//var ERC721MNT = artifacts.require("./ERC721MNT");
var MinterContract = artifacts.require("./MinterContract");

module.exports = function(deployer) {
//	deployer.deploy(ERC721MNT, "MintableToken", "MNT");
	deployer.deploy(MinterContract, "0x731b48468FDBC484A90e5A8dFe7Bd1EdAC3844Fb");
}
