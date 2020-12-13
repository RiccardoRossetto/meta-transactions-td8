pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20MNT is ERC20 {

	constructor(uint256 initialSupply) public ERC20("MNT-ERC20", "MNT") {
		_mint(msg.sender, initialSupply);
	}

	function claimTokens(uint _amount) public {
		_mint(msg.sender, _amount);
	}

}
