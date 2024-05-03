// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./PointsCore.sol";
import "../BOB-NFT.sol";

contract DailyLoginsV1 is Ownable{
    uint internal pointPerDay = 10;
    uint internal pointPerReferal = 50;
    uint internal day = 1 days;

    EventCore public core;

    struct User{
        uint lastSignIn;
        uint userTotalSignIns;
    }
    mapping (address => User) internal user;
    mapping (address => address) internal referer;

    constructor()
    Ownable(msg.sender)
    {
        core =new EventCore();
    }

    function dailyLogin() public payable{
        if(!core.userActivated(msg.sender)){
            core.createAcc(msg.sender);
        }
        require(user[msg.sender].lastSignIn + day >= block.timestamp,"already sign in today");
        core.addPoints(msg.sender, pointPerDay);
        if(referer[msg.sender] != address(0)){
            core.addPoints(referer[msg.sender], pointPerDay/2);
        }
        user[msg.sender].lastSignIn = block.timestamp;
        user[msg.sender].userTotalSignIns +=1;
    }

    function createAccount(address referal) public payable {
        if(referal != address(0)){
            require(core.userActivated(referal) == true);
            referer[msg.sender] = referal;   
        }
        core.createAcc(msg.sender);
    } 

}