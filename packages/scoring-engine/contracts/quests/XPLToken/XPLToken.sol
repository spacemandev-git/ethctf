pragma solidity ^0.5.0;

//Simplified token interface
interface IToken {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract XPLToken is IToken{
    mapping (address => uint256) balances;
    mapping (address => uint) claims;
    uint constant maxClaims = 10;
    
    //IToken interface functions
    function transfer(address to, uint256 value) external returns (bool){
        if(balances[msg.sender] >= value){
            return false;
        }
        balances[to] += value;
        balances[msg.sender] -= value;
        return true;
    }
    function balanceOf(address who) external view returns (uint256){
        return balances[who];
    }

    //custom functions for XPL
    
    //will claim a payout for address by determining if the revolutionary Fibonacci PoW algorithm has been completed
    function claimPayout(int256 seq, int256 fibNumber) external returns (uint256){
        require(claims[msg.sender] < maxClaims, "Reached claim limit");
        claims[msg.sender]++;
        int256 expected = fib(seq);
        require(expected == fibNumber, "fibNumber must have been calculated");
        
        balances[msg.sender] += uint256(seq);
        return balances[msg.sender];
    }
    
    //The goal of the game is to have everyone send you enough coins so you can become a winner!
    function testWinner(address who) external view returns (bool){
        if(balances[who] > 10000000){
            return true;
        }
        return false;
    }
    
    //TODO: Evaluate why this function crashes with high sequence numbers
    function fib(int256 n) internal pure returns (int256)
    {
        //copy pasted from good stack overflow answer
        if (n < 1)
         return 0;
        else if(n == 1)
         return 1;
        else
         return fib(n - 1) + fib(n - 2);
    }

}


