pragma solidity >=0.4.24 <0.6.0;

contract A {
    uint x;
    address addr;
  
    constructor() public
    { 
       x = 1;
    }

    function foo(uint _x) public {
       x = _x;
    }

    function foo(address _x) public {
       addr = _x;
    }


  
}