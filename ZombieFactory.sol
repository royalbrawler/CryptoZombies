//1. Enter solidity version here
pragma solidity ^0.4.19;

import "./ownable.sol";

//2. Create contract here
contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    // This will be stored permanently in the blockchain
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; // equal to 10^16
    uint cooldownTime = 1 days;
    
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    //key-value pairs
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    //internal - accessible to contracts that inherit from this contract
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        //msg.sender = address of the person
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    // view - it's only viewing the data but not modifying it
    // pure - not even accessing any data from the blockchain
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus; // 16 digits long
    }

    function createRandomZombie(string _name) public {        
        require(ownerZombieCount[msg.sender] == 0); //require - if (true) proceed
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }
}