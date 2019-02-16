# Meta

* Level: 1
* Name: XPLToken
* Steps 1

## Step 1 Contracts

* XPLToken.sol

# Step description
XPLToken is a simple token contract which is designed to encourage hackers to go outside and talk to people in order to accumulate coins so that they can be a winner. A lot of coins are required, so this may take a very long time. 

Coins are initially brought into the ecosystem by using a Fibonacci PoW system. Unfortunately, unlike hashes, it's completely impossible to determine what the number is without computing it. So there is an efficient Fibonacci solver implemented in the contract. You must send the "claimPayout" function a sequence number and the matching Fibonacci number matching that sequence number.

Become a winner in order to complete this quest by having your address with the "testWinner" function return true with your address. 

# Exploit description

Despite the numerous little jokes and false starts based on terrible coding practices, this exploit is extremely simple. Generating large Fibonacci numbers is possible to do locally, but becomes completely impossible to validate on the blockchain after sequence number 20 or so due to bad algorithm design of the Fibonacci validator. The key is to bypass this validation by providing a sequence number less than 0, like -1. Any sequence number less than 0 will return 0 as the Fibonacci number. This causes the validation to be bypassed and then for the sequence number to be added to the balance of msg.sender. Afterwards, testWinner will return true for msg.sender



