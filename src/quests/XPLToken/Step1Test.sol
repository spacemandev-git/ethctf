pragma solidity ^0.5.0;

contract XPLTokenQuest{
    //metadata goes in here somehow... 

    function testStep1(XPLToken token, address hacker) internal returns (bool){
        return token.testWinner(hacker);
    }    
}
