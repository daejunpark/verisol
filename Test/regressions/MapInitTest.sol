pragma solidity >=0.4.24<0.6.0;

contract MapInitTest1 {
    mapping (uint256 => uint256) public recoverMap1;

    constructor(uint256 owner, uint256 key)
        public
    {
        require(owner != 0);
        recoverMap1[key] = owner;
    }

    function test(uint256 key)
        external
    {
        uint256 owner1 = recoverMap1[key];
        uint256 owner2 = recoverMap1[key + 1];
        require(owner1 != 0);

        assert(owner1 != owner2);
    }
}

contract MapInitTest2 {
    mapping (uint256 => mapping (uint256 => uint256)) public recoverMap2;

    constructor(uint256 owner, uint256 key1, uint256 key2)
        public
    {
        require(owner != 0);
        recoverMap2[key1][key2] = owner;
    }

    function test(uint256 key1, uint256 key2)
        external
    {
        uint256 owner1 = recoverMap2[key1][key2];
        uint256 owner2 = recoverMap2[key1][key2 + 1];
        require(owner1 != 0);

        assert(owner1 != owner2);   // <--- false positive corral runs
    }
}

