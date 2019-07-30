pragma solidity >=0.4.24 <0.6.0;

//This is a draft: the test does not compile
contract Sender {

    constructor () public {}
    function Send(address _receiver) payable {
    if (!_receiver.send(msg.value))
	{
		assert(false);
	}
  }
  
}
contract Receiver {
	constructor () public {}
    //uint public balance = 0;
    event Receive(uint value);
  
  function () payable {
    Receive(msg.value);
  }
}
contract testSend(uint amount) public {
	Sender sender = new(Sender);
	Receiver receiver = new (Receiver);
	uint senderBalance = 500;                       //?
	unit recBalance = 100;
	sender.balance = senderBalance;
	uint sendAmount = 300;
	sender.send(sendAmount);
	assert (sender.balance == 200);
	assert(receiver.balance == 300);
}