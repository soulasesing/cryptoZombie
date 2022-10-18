// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.1;
import "./ownable.sol";
import "./safemath.sol";

contract ZombieFactory is Ownable{

    //using safeMath to avoid over/under float
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewZombie(uint zombieId, string name, uint dna);

    //DNA for zombies
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    //var to cooldown the zombies feeds
    uint cooldownTime = 1 days;

    struct Zombie{
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }
    //Array of the struct Zombie  we stored zombies here
    Zombie[] public zombies;

    //mappins to  tracks of address that owns zombie
    mapping (uint => address) public zombieToOwner;

    //mapping to tracks how many zombies an owner has
    mapping (address => uint)  ownerZombieCount;

    // this function we able to create new zombies 
   function _createZombie  (string memory _name, uint _dna) internal {

    //add new zombie to the array Zombie[] and save the id's zombie y the other date of the struct
      zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0 )); 
      uint id = zombies.length - 1;
     //stored the address in a mapping  who in own/create a new zombie 
      zombieToOwner[id] = msg.sender;
      //I count how many zombies has the owner of the contracts
      ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
    
      
      //uint id = zombies.push(Zombie(_name, _dna)) - 1;
     //emit event "new zombie has been created
     emit NewZombie(id, _name, _dna);

   }

   //function to generate a Randow DNA 
    function _generateRandomDna(string memory _str)private view returns (uint){

        //ganerate a seudo randons
       uint rand = uint(keccak256(abi.encodePacked(_str)));
       return rand % dnaModulus;
    }

    //function that take a names' zombies to create a new zombies using the name
    function createRandomZombie(string memory _name) public{
        //validate if the user has been created a zombie 
        require(ownerZombieCount[msg.sender] == 0, "Error: you only have able to create 1 zombie ");
 
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
 
    }
}

