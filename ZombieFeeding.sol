pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        // storage - written permanently to the blockchain
        // memory - will disappear when the function call ends
        Zombie storage myZombie = zombies[_zombieId];

    }
    
}