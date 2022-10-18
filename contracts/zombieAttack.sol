// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.1;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;


//var to septup the probability of win
uint attackVictoryProbability = 70;

//We have to build a function that build a random number 
    uint randNonce = 0;
function randMod(uint _modulus) internal returns(uint){
    //increase the randNonce
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus;
    }

//function attack this get the Id of 2 zombies 
function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId){
//declare a storage the look up my zombies
Zombie storage myZombie = zombies[_zombieId];
Zombie storage enemyZombie = zombies[_targetId];
//call ours randon function to determine the outcome of the battles
 uint rand = randMod(100);
//here determine who zombies win and loss and increment de account
 if(rand <= attackVictoryProbability){
    myZombie.winCount = myZombie.winCount.add(1);
    myZombie.level = myZombie.level.add(1);
    enemyZombie.lossCount = enemyZombie.lossCount.add(1);
   //here I call the function an pass how feed the enemy Zombie
    feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
 }else{
    myZombie.lossCount = myZombie.lossCount.add(1);
    enemyZombie.winCount = enemyZombie.winCount.add(1);
    _triggerCooldown(myZombie);

 }

}

}