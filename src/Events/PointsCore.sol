// SPDX-License-Identifier:  MIT

pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract EventCore is Ownable{

uint internal totalPoints;
uint internal totalUsers;

constructor()
    Ownable(msg.sender)
{}

struct USER {
    bytes username;
    uint points;
    uint referalCount;
    bool pohVerified;
    bool accountInitialized;
}

mapping (address => USER) internal users;
mapping (address => bool) public operators;

modifier isOp(){
    require(operators[msg.sender]== true,"not op");
    _;
}

function getUser(address user) public view returns(USER memory){
    return users[user];
}

function getTotalPoints() public view returns (uint){
    return totalPoints;
}

function getTotalUsers() public view returns (uint){
    return totalUsers;
}

function userActivated(address addr) public view returns(bool){
    return users[addr].accountInitialized;
}

function setOpStat(address _of , bool state) public onlyOwner{
    operators[_of] = state;
}

function setUserName(address user , bytes memory _name) public isOp returns(bool){
    require(user != address(0) && _name.length >0);
    users[user].username = _name;
    return true;
}

function addPoints(address _of , uint _amount) public isOp returns(bool){
    if(_of == address(0) || _amount == 0){
        revert();
    }
    users[_of].points += _amount;
    totalPoints += _amount;
    return  true;
}

function subPoints(address _of , uint _amount) public isOp returns(bool){
    if(_of == address(0) || _amount == 0){
        revert();
    }
    users[_of].points -= _amount;
    totalPoints -= _amount;
    return  true;
}

function addRef(address _of) public isOp returns (bool){
    users[_of].referalCount += 1;
    return  true;
}

function createAcc(address _for) public isOp returns(bool){
    users[_for].accountInitialized = true;
    totalUsers +=1;
    return true;
}

function setVerificationStat(address _for, bool stat) public isOp returns (bool){
    users[_for].pohVerified = stat;
    return true;
}

}