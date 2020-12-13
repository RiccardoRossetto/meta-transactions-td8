pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ERC721TD is ERC721 {
	

    uint public nextTokenId = 0;
    mapping(address => bool) public whitelist;

    constructor(string memory name_, string memory symbol_) public ERC721(name_, symbol_) {
    	_addMinter(msg.sender, true);
    }

	function mint(address to) public onlyWhitelisted
	{
		_safeMint(to, nextTokenId);
		nextTokenId += 1;
	}

	function manageMinter(address newMinter, bool isMinter) public onlyWhitelisted
	{
		_addMinter(newMinter, isMinter);
	}

	function _addMinter(address newMinter, bool isMinter) internal
	{
		whitelist[newMinter] = isMinter;
	}

	modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Account Not Whitelisted");
        _;
    }
}

