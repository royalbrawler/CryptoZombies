//1. Enter solidity version here
pragma solidity ^0.4.19;

//2. Create contract here
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    // This will be stored permanently in the blockchain
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // equal to 10^16
    
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    // view - it's only viewing the data but not modifying it
    // pure - not even accessing any data in the app
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus; // 16 digits long
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}