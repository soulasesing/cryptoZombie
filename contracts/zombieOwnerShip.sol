// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.1;

import "./zombieAttack.sol";
import "./erc721.sol";

/// @title A contract to manages de ownershio of assest 
/// @author Amilcar Rosario
/// @notice 
/// @dev a compliance with OpenZeppelin's imlementation of the ERC721 spec

//this contract inherits from to contracts 
contract ZombieOwnership is ZombieAttack, ERC721 {
    using SafeMath for uint256;

    //define mapping to lookup quickly if the address is approve.
    mapping(uint => address) zombieApprovals;

//return the number of zombies that _owner has
function  balanceOf(address _owner) external override view returns (uint256) {
   return ownerZombieCount[_owner];


  }
function  ownerOf(uint256 _tokenId) external override view returns (address) {
    return zombieToOwner[_tokenId];

  }

  //function transfer this's in charge of tranfer the assesst 
  function  _transfer(address _from, address _to, uint _tokenId) private  {
    //sum one zombie to the target address using the mapping 
    ownerZombieCount[_to]= ownerZombieCount[_to].add(1);
    //discount one zombie to the origen address using the mapping 
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    //assign the new zombie to the target address
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);

  }

function  transferFrom(address _from, address _to, uint256 _tokenId) external override payable {
    //here we valide that the address have approve to trade the assesst
    require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);

  }

function approve(address _approved, uint256 _tokenId) external override payable  onlyOwnerOf(_tokenId) {

    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
