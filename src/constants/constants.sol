pragma solidity ^0.8.20;

// Points per tasks as for now 

contract Constants {
    uint public decimals = 4;
    uint public power = 10 ** decimals; // arbitrary points for later complex calc
    uint public dailyLoginPoints = 1 * power; 
    uint public referalPoint = 7 * power;
    uint public oneDollarLotteryWin = 4 * power;
    uint public fiveDollarLotteryWin = 22 * power;
    uint public tenDollarLotteryWin = 55 * power;
    uint public hundredDollarLotteryWin = 555 * power;
}