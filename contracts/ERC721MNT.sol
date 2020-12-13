pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ERC721MNT is ERC721 {
	
    uint public tokenToMintID = 0;
    mapping(address => bool) public whitelist;

    constructor(string memory name_, string memory symbol_) public ERC721(name_, symbol_) {
	whitelist[msg.sender] = true;
    }

	function mint(address to) public msgSenderWhiteListed
	{
		_safeMint(to, tokenToMintID);
		tokenToMintID += 1;
	}

	function manageWhiteList(address addressToManage, bool isMinter) public msgSenderWhiteListed
	{
		whitelist[addressToManage] = isMinter;
	}

	modifier msgSenderWhiteListed() {
        require(whitelist[msg.sender], "Account Not Whitelisted");
        _;
    }
}
