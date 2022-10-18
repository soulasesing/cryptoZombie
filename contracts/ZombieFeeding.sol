// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.1;
import "./ZombieFactory.sol";

//declare a interface to use the CryptoKitties contract 
interface  KittyInterface  {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}


//this contract inheritance from ZombieFactory
contract ZombieFeeding is ZombieFactory{
    //cryptoKitty Address
    //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    
    //declate contract variable
    KittyInterface kittyContract;

    //create modifiers to validete the zombie's owners
    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }
    
    //this function permit changes the adress of the kitty smarcontract
    function setKittyContractAddress (address _address) external onlyOwner{

        kittyContract = KittyInterface(_address);

    }
// function the set the cooldown of the zombies
    function _triggerCooldown(Zombie storage _zombie) internal{
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);

    }

// function to put ready my zombie
    function _isReady(Zombie storage _zombie) internal view returns(bool){
        return(_zombie.readyTime <= block.timestamp);
    }


    function feedAndMultiply (uint _zombieId, uint _targetDna, string memory _species ) internal onlyOwnerOf(_zombieId) {

        //validate if this is ours zombies no ones can feed my zombies
       // require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        //validate if the zombie is ready 
        require(_isReady(myZombie));
        //to make sure ours zombies only take the last 16 digits
        _targetDna = _targetDna % dnaModulus;
        //calculate the new DNA zombie
        uint newDna = (_targetDna + myZombie.dna) / 2;
        //compare hashes _species with string kitty 
        if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
            //add digits 99 to DNA 
            newDna = newDna - newDna % 100 + 99;
        //we call the function _triggerCooldown to put my zombie down 
        _triggerCooldown(myZombie);
        }

        //call the function to create a new zombie
        ZombieFactory._createZombie("NoName", newDna);

    }

    //function to get de DNA from cryptokitty Contract 
    function feedOnKitty (uint _zombieId, uint _kittyId) public{
        uint256 kittyDna;

        //call the kitty function to take the genes
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        //call the function to feed my zombie with a crypto kitty
        feedAndMultiply(_zombieId, kittyDna, "kitty");


    }

    
}

