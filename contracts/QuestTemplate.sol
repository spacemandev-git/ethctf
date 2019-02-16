pragma solidity ^0.5.0;


interface QuestInterface{
    function getQuestName() external pure returns (string memory name);
    function getStepInfo() external view returns (string memory url);
    function isQuestComplete() external view returns (bool complete);
    function beginQuest(address hacker) external returns (bool success); //only usable by score engine
    function spawnStep(address hacker) external returns (address stepAddress);
    function stepsRemaining(address hacker) external view returns (uint steps);
    function testStep(address step) external returns (bool);
}

contract QuestTemplate is QuestInterface{
    address scoringEngine;
    mapping (address => uint) hackerStep;
    mapping (address => address) hackerContract;
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

    function isQuestComplete(address hacker) external view returns (bool){
        if(hackerStep[hacker] > maxSteps){
            return true;
        }
        return false;
    }

    function beginQuest(address hacker) external onlyScoring() returns (bool) {
        require(hackerStep[hacker] == 0, "Quest already been started or is complete");
        hackerStep[hacker] = 1;

        spawnStepInternal(1, hacker);
        return true;
    }

    //uses msg.sender to determine hacker.  Spawns new version of current step contract as fresh default one
    //for if the hacker fails in an unrecoverable way and needs to reset the state of the step
    function spawnStep() external returns (address){
        require(hackerStep[msg.sender] > 0, "Quest has not been started");
        require(hackerStep[msg.sender] < maxSteps, "Quest is already complete");
        //spawn child, then update hackerContract to new address
        return spawnStepInternal(hackerStep[msg.sender], msg.sender);
    }

    function stepsRemaining(address hacker) external view returns (uint){
        return maxSteps - hackerStep[hacker];
    }

    function testStep() external returns (bool){
        require(hackerStep[msg.sender] > 0, "quest not started");
        require(hackerStep[msg.sender] <= maxSteps, "quest already complete");
        require(hackerContract[msg.sender] != address(0), "No step spawned");
        bool success = false;

        // ... magic
        if(hackerStep[msg.sender] == 1){
            success = testStep1(hackerContract[msg.sender]);
        }else{
            revert("should be impossible");
        }

        if(success){
            //update to new step etc
            hackerStep[msg.sender] += 1;
            hackerContract[msg.sender] = address(0);
        }
        return success;
    }

    //private functions
    function testStep1(address step) internal view returns (bool){
        StepTemplate s = StepTemplate(step);
        return !s.test();
    }
    function stepInfo(uint step) internal pure returns (string memory){
        if(step == 0){
            return "Quest not started";
        }else if(step == 1){
            return "Template Quest First Step Info URL";
        }else{
            return "Invalid Quest Step";
        }
    }
    function spawnStepInternal(uint step, address hacker) internal returns (address){
        require(step > 0, "quest not started");
        require(step < maxSteps, "quest already complete");
        if(step == 1){
            return hackerContract[hacker] = address(new StepTemplate(hacker));
        }else{
            revert("should be impossible"); //shouldn't reach here
        }
    }
}

contract StepTemplate
{
    bool testVar=true;
    address ownerHacker;
    modifier onlyHacker(){
        require(msg.sender == ownerHacker, "only usable by owner/hacker");
        _;
    }
    constructor(address hacker) public{
        ownerHacker = hacker;
    }
    //target: make test() return false
    function test() external view returns (bool){
        return testVar;
    }
    function setVar(int v) external onlyHacker(){
        //v must be collapsed into a boolean
        //"tricky" code
        testVar = v >= 0;
    }
}




