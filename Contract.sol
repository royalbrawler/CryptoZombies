//1. Enter solidity version here
pragma solidity ^0.4.19;

//2. Create contract here
contract ZombieFactory {
    // This will be stored permanently in the blockchain
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // equal to 10^16
    
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    // view - it's only viewing the data but not modifying it
    // pure - not even accessing any data in the app
    function _generateRandomDna(string _str) private view returns (uint) {
        
    }
}