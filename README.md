# Chain CTF

## Intro

Capture the Flag tournaments are Cyber Security Tournaments used to encourage engineers to learn best security practices. Teams compete with each other to break into as many vulnerable servers as possible to get flags which they can submit to a scoring engine for points. CTFs are can be Red Vs Blue (two teams fight against each other), Classic (multiple teams race for flags), or Cooperative (the goal is to get all the flags within a time frame).

FBCTF Scoring Engine InterfaceOne of the largest problems in smart contract development currently is the lack of security engineers. Every couple of months there is another hack loosing millions of dollars based around blockchains. While CTFs usually teach skills along the lines of physical lockpicking, wifi vulnerabilities, sql injection, windows vulnerabilities, hardware hacks, social engineering etc, there is a lack of content around blockchain based vulnerabilities.

We decided to design and implement a modular CTF engine to teach blockchain vulnerabilities (but has support for non blockchain vulnerabilities too!) built on top of Ethereum. The Engine is meant to be deployed for events and run for a set period of time at the event. During that time, players can race through quests exploiting vulnerable contracts while gaining points and NFT rewards on the way! The system is intended to be extremely customizable and focuses on interfaces and templates which can be extended to fit whatever needs. 

Because of it's modular nature, one could simply deploy a Quest package and attempt to break into it. Or they could attach a scoring engine, and now multiple players can try to break into quests for points. Add the Asset Store and you can reward players with Coins they can use to purchase Assets. What good are assets? Deploy the Meta Game module and now you have a trading card game built on assets you purchase from the store. 

# Modules
## Quest Packages
A self contained template for multi-step exploit checks. Users can try to break the contract or submit zero knowledge flags for off chain steps (breaking into a lockbox, hacking a server, etc) then run the test contract to see if they achieved all the exploits in the contract.

A quest package is a folder that has the following items:
### Manifest
The Manifest file contains metadata about the quest, such as how many steps it has, what the reward is for completing it, what it's ID is, what pre reqs it has etc. It's consumed by the QPS when trying to figure out how best to deploy the quest instance for a given player. 

### Test Contract
The Test Contract is a solidity contract that implements the QuestInterface. 
It has a series of steps that can be used to check if the contract has been exploited or not. These steps can also be zero knowledge flag submission or otherwise off chain vulnerabilities to compound different steps into one 'Quest'.

An example of an easy 'teaching' quest might only have one step and work to find an easy integer overflow/underflow error in an otherwise short contract. A medium

An example of a medium 'challenge' quest might have three to five steps, requiring you (step 1) kill a contract library, (step 2) drain contract, (step 3) use the funds to attack another contract, and (step 4) override the connecing link between the two contracts. 

An example of a challening quest might be (step 1) break a lockbox, (step 2) hack into a server, (step 3) deploy your own contract to attack the original vulnerable contracts, tec. 

### Vulnerable Contracts
A list of vulnerable contracts and their inital state that the Deploy Service should set them up as. 

## Quest Provisioning System:
QPS is an optional off chain deploy service that listens to Scoring Engine events to see when a user wants to start a given quest. An instance of that quest's vulnerable contracts are then deployed and locked so only that user can attack them. It uses Graph QL to listen to the events and pull and read quest package data.

## Scoring Engine:
An optional module that handles a leaderboard and the main interface to players to interact with. Also manages player's quest progressions and requests for a quest to be provisioned for them.

## Asset Store:
Optional module that awards Coins for completed quests that players can use to purchase Admin defined Cards from the store. These cards have specific stats that can be skinned to whatever narrative design you like and can be used for attack/defense meta game.

## Meta Game:
Optional module that focuses on two contracts: Blockchains.sol, and Mutators.sol. This is a specific meta game where enemy AI and players spawn and fight against each other blockchains. Blockchains have attributes and players can 'mine' their blockchain to gain more Coins and Points. They can also burn cards in Mutators.sol to carry out attacks or defend their chain. For example, a 51% attack that reduces the market value of an enemy blockchain might cost them 51% of Attack CPU cards as the target chain has total CPU power. This is used to teach more 'conceptual' vulnerabilities (actually breaking into and gaining control of that many nodes might be tedious work).


# Darknet
One CTF in particular that's interesting to me is the Darknet, usually run at Defcon. You can check it out here: dcdark.net

This CTF engine is meant to expand their CTF engine (hence no time spent on a UI, as we would use theirs). Darknet CTF is designed as a live action RPG, where players take on the role of Daemon Agents, solving quests and learning skills to thwart their adversairies. The narritive elements of the game and the design for the quest structure all come from the organizers who write a storyline for each year. 