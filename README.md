# TD8: Meta Transactions

#### 1) Create a Truffle Project and Configure it on Infura.

As in the previous TDs, we initiated our Truffle Project, and configured it with our Infura API key and the mnemonic from our Metamask wallet suitably put in an environment file from which we imported them into the truffle-config.js file.

#### 2) Create a Mintable ERC721 Smart Contract.

The contract is called ERC721MNT, and its symbol is MNT. 

The token is mintable only if whoever tries to mint it has been added to the white-list from another white-listed account. To keep track of the white-listed accounts, a mapping has been used where every address has its own corresponding status, true or false. 

MNT Address: [0x731b48468FDBC484A90e5A8dFe7Bd1EdAC3844Fb](https://rinkeby.etherscan.io/address/0x731b48468FDBC484A90e5A8dFe7Bd1EdAC3844Fb)

Deployment TX: [0x2ca1a9f42b1758e5a33fb50096e7f0b98b419286a0f668c928c300914a1f2246](https://rinkeby.etherscan.io/tx/0x2ca1a9f42b1758e5a33fb50096e7f0b98b419286a0f668c928c300914a1f2246)

#### 3) Create a Minter Contract that is Allowed to Mint ERC721 Tokens.

The contract can be found in this repo with the name MinterContract.sol.

MinterContract Address: [0x12C2e59e746a173ed0f34a826350F4085dB1B92F](https://rinkeby.etherscan.io/address/0x12C2e59e746a173ed0f34a826350F4085dB1B92F)

Deployment TX: [0xff0b94be7fa0d88785fee8b5cb24a2c93643008a3a45fb34bc742f4d65405224](https://rinkeby.etherscan.io/tx/0xff0b94be7fa0d88785fee8b5cb24a2c93643008a3a45fb34bc742f4d65405224)

#### 4) Integrate signerIsWhitelisted from bouncerProxy in your Contract with all the associated variable.

The function has been integrated in MinterContract.sol, as it can be seen in its code, the function takes an hash and the corresponding signature, it extract the address corresponding to said hash and signature, and access the white-list mapping returning true or false, depending whether the address is white-listed or not.

#### 5) Get White-listed on contract [0x53bb77F35df71f463D1051061B105Aafb9A87ea1](https://rinkeby.etherscan.io/address/0x53bb77f35df71f463d1051061b105aafb9a87ea1)

In order to get white-listed on said contract, we had to sign a given hash and provide the signature produced.

```bash
truffle(rinkeby)> let acc = await web3.eth.getAccounts()
truffle(rinkeby)> acc[0]
'0xCB93e3b2bc29Ed71062626360888f358A4C95045'
truffle(rinkeby)> message = "You need to sign this string"
'You need to sign this string'
truffle(rinkeby)> hash = await web3.eth.utils.fromAscii(message)
truffle(rinkeby)> hash
'0x596f75206e65656420746f207369676e207468697320737472696e67'
truffle(rinkeby)> encodedMessage = await web3.eth.abi.encodeParameters(['bytes32'],[hash])
'0x596f75206e65656420746f207369676e207468697320737472696e6700000000'
truffle(rinkeby)> signature = await web3.eth.sign(encodedMessage, acc[0])
truffle(rinkeby)> signature
'0x9345bfe90c256e9b9ece51d8390913ad55f0b2d6794ddb7cabd48281d2354bac701a883fb7b1e302be1e6a30838d0666b4'
```

By using the truffle console, we first got all of our accounts into the acc array, where our main account is the first one (i.e. [acc[0]](https://rinkeby.etherscan.io/address/0xCB93e3b2bc29Ed71062626360888f358A4C95045)), then by using web3 we hashed the message "You need to sign this string", encoded it into bytes32, and finally signed it with our main account.

To get white-listed on the professor's contract, we went on its etherscan page, connected to Web3 with Metamask, and used the function getWhiteListed, providing the signature we produced.

Transaction: [0xeb197a083915f35c29be97bba1c47706a229f7fbe0a710ddaa39d351055047e3](https://rinkeby.etherscan.io/tx/0xeb197a083915f35c29be97bba1c47706a229f7fbe0a710ddaa39d351055047e3)

#### 6) Claim a Token on contract [0x3e2E325Ffd39BBFABdC227D31093b438584b7FC3](https://rinkeby.etherscan.io/address/0x3e2e325ffd39bbfabdc227d31093b438584b7fc3) through contract [0x53bb77F35df71f463D1051061B105Aafb9A87ea1](https://rinkeby.etherscan.io/address/0x53bb77f35df71f463d1051061b105aafb9a87ea1)

To claim a token we had to sign a hash with our main account which was white-listed in the previous point, then send said message with another account, so as before we got our accounts:

```{bash}
truffle(rinkeby)> let acc = await web3.eth.getAccounts()
truffle(rinkeby)> acc[0]
'0xCB93e3b2bc29Ed71062626360888f358A4C95045' # signer
truffle(rinkeby)> acc[1]
'0x80f312BB7cf1DbBdFA8d2339aA025816dBe03Ccc' # sender
```

The hash to sign is the one produced encoding the address of the professor's ERC721 token, and the token ID that would be minted, so first we got these two values:

```{bash}
truffle(rinkeby)> token = "0x3e2E325Ffd39BBFABdC227D31093b438584b7FC3"
'0x3e2E325Ffd39BBFABdC227D31093b438584b7FC3'
truffle(rinkeby)> tokenID = "4" # obtained calling the nextTokenId field of the contract.
'4' 
```

Now we instantiated the professors MetaTxExercice contract:

```{bash}
truffle(rinkeby)> let cont = MetaTxExercice.at("0x53bb77F35df71f463D1051061B105Aafb9A87ea1")
```

So now we have to our disposal all that is needed to claim a token from the professor's contract:

```{bash}
truffle(rinkeby)> encodedMessage = await web3.eth.abi.encodeParameters(['address','uint'],[token, tokenID])
truffle(rinkeby)> encodedMessage
'0x0000000000000000000000003e2e325ffd39bbfabdc227d31093b438584b7fc30000000000000000000000000000000000'
truffle(rinkeby)> hash = web3.utils.keccak256(encodedMessage)
'0xfab9c5b6ebe289eabeaf29f3b4caa4f010d22c23325044d723a84bd2fb908190'
truffle(rinkeby)> signature = await web3.eth.sign(hash, acc[0])
truffle(rinkeby)> signature
'0x387c73acff2adb44c7de1f1576e061596a4a64dfce9edfa7474869af34967601044af2fde23acb96ec3193e1a010afec85'
truffle(rinkeby)> cont.claimAToken(sig, {from: acc[1]})
```

Transaction: [0x45cfb89060407c698cbbcc5467f78251ea9ea017ffa31612178891dafe2061b5](https://rinkeby.etherscan.io/tx/0x45cfb89060407c698cbbcc5467f78251ea9ea017ffa31612178891dafe2061b5)

#### 7) Create on Your Contract a claimToken Function.

