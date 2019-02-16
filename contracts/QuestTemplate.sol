pragma solidity ^0.5.0;


interface QuestInterface{
    function getQuestName() pure external returns (string memory name);
    function getStepInfo(address hacker) view external returns (string memory url);
    function questComplete(address instance) external returns (bool complete);
    function beginQuest(address hacker) external returns (address stepAddress); //only usable by score engine
    function spawnNextStep(address hacker) external returns (address stepAddress);
    function stepsRemaining(address hacker) external view returns (uint steps);
}

contract QuestTemplate is QuestInterface{
    address scoringEngine;
    mapping (address => uint) hackerStep;
    uint constant maxSteps = 1;

    modifier onlyScoring(){
        require(scoringEngine == msg.sender, "can only be called from scoring engine");
        _;
    }
    constructor(address scoringEngine_) public {
        scoringEngine = scoringEngine_;
    }

    function getQuestName() external pure returns (string memory name){
        return "Template Quest";
    }
    //uses msg.sender to determine hacker and step
    function getStepInfo() external view returns (string memory url){
        return stepInfo(hackerStep[msg.sender]);
    }

    //uses msg.sender to determine hacker and step
    function questComplete(address instance) external returns (bool){
        return false;
    }

    function beginQuest(address hacker) external onlyScoring() returns (address) {
        require(hackerStep[hacker] == 0, "Quest already started/complete");
        hackerStep[hacker] = 1;
    }
    //uses msg.sender to determine hacker. Returns 0 address if previous step not complete, or no more steps
    function spawnNextStep() external returns (address stepAddress){
        
    }
    function stepsRemaining(address hacker) external view returns (uint){
        return 0;
    }

    //private functions
    function stepInfo(uint step) internal pure returns (string memory){
        if(step == 0){
            return "Quest not started";
        }else if(step == 1){
            return "Template Quest First Step Info URL";
        }else{
            return "Invalid Quest Step";
        }
    }
}