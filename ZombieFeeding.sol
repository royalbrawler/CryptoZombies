pragma solidity ^0.4.19;

import "./zombiefactory.sol";

//interface CrytoKitties
contract KittyInterface {
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

contract ZombieFeeding is ZombieFactory {
   
    KittyInterface kittyContract;

    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // external - can only be called outside the contract
    // onlyOwner calls first, setKitty... calls second
    function setKittyContractAddress (address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown (Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady (Zombie storage _zombie) internal view returns (bool){
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
        // storage - written permanently to the blockchain
        // memory - will disappear when the function call ends
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // comparing hashes
        if(keccak256(_species) == keccak256("kitty")){
            // 99 - indicates that is a cat-zombie(VFX) eater thingy 
            // example - 334455 >> (newDna % 100) = 334400 >> +99 = 334499
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna); 
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        // gets the 'genes' (10th place)
        (,,,,,,,,,kittyDna) =  kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
    
}