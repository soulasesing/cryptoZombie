// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.1;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding{

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    //Define a var with the amount of fee needed to levelUp your zombie
    uint levelUpFee = 0.001 ether;

//modifiers to control the skills of the zombies accordenly with its level.
modifier aboveLevel(uint _level, uint _zombieId){
    require(zombies[_zombieId].level >= _level);
    _;
}
//function to withdraw the ether from the contract
    function withdraw() external onlyOwner {
    address payable _owner =  payable(address (uint160(owner())));
    // address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }

//funtion to set up the fee to our games 
function setLevelUpFee(uint _fee) external onlyOwner{
    levelUpFee = _fee;
}

//function that able to player level Up their zombies paying a small fee
function levelUp(uint _zombieId) external payable{
    require(msg.value == levelUpFee);
    zombies[_zombieId].level =  zombies[_zombieId].level.add(1);
}


//function that permit to players change de name of its zombie if it's level 2 
function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId){
    //require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
}

//function to change the DNA to player with level 20
function changeDNA(uint _zombieId, uint  _newDNA) external aboveLevel (20, _zombieId) onlyOwnerOf(_zombieId){
    //require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDNA;
}
//this function is returns all the zombie Armies for a particular address(player)
function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
 uint[] memory result  = new uint[](ownerZombieCount[_owner]);
// we declare a loop to iterate through all the Zombie in our Dapp compare owner
 uint counter = 0;
        for(uint i = 0; i < zombies.length; i++){
            if(zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
 return result;
    }
}