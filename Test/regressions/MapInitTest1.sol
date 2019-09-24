pragma solidity >=0.4.24<0.6.0;

contract MapInitTest1 {
    mapping (uint256 => uint256) public recoverMap1;

    constructor(uint256 owner, uint256 key)
        public
    {
     // require(owner != 0); // not necessary
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
