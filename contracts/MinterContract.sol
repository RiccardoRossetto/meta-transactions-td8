pragma solidity ^0.6.0;

import "./ERC721MNT.sol";

contract MinterContract {
	
	address public ERC721MNTaddress;
	address public owner;

	mapping(address => bool) public whitelist;

	constructor(address _ERC721MNTaddress) public {
		owner = msg.sender;
		whitelist[owner] = true;
		ERC721MNTaddress = _ERC721MNTaddress;
	}

	function claimToken(bytes memory _signature) public {
		
		// MNT token contract instance:
		ERC721MNT tokenMNT = ERC721MNT(ERC721MNTaddress);
		uint tokenToMintID = tokenMNT.tokenToMintID();

		// Reproduce hash with the MNT contract's address, and the next tokenID:
		bytes32 _hash = keccak256(abi.encode(ERC721MNTaddress, tokenToMintID));

		// Check that the signature provided is valid:
		require(signerIsWhitelisted(_hash, _signature), 
				"The signature is invalid, or the signer is not whitelisted.");

		// Check that the signer is the owner of this contract:
		require(owner == extractAddress(_hash, _signature), 
				"Only the owner of this contract can sign messages to mint tokens.");

		// Check that the call to the function is not from the owner:
		require(msg.sender != extractAddress(_hash, _signature),
				"Sender and Signer must be different.");

		tokenMNT.mint(msg.sender);
	}




    function extractAddress(bytes32 _hash, bytes memory _signature) internal view returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        // Check the signature length
        if (_signature.length != 65) {
            return address(0);
        }
        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }
        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return address(0);
        } else {
            // solium-disable-next-line arg-overflow
            return ecrecover(keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
                ), v, r, s);
        }
    }


	function signerIsWhitelisted(bytes32 _hash, bytes memory _signature) internal view returns (bool){
    bytes32 r;
    bytes32 s;
    uint8 v;
    // Check the signature length
    if (_signature.length != 65) {
      return false;
    }
    // Divide the signature in r, s and v variables
    // ecrecover takes the signature parameters, and the only way to get them
    // currently is to use assembly.
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      r := mload(add(_signature, 32))
      s := mload(add(_signature, 64))
      v := byte(0, mload(add(_signature, 96)))
    }
    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }
    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
      return false;
    } else {
      return whitelist[ecrecover(keccak256(
        abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
      ), v, r, s)];
    }
  }

}
