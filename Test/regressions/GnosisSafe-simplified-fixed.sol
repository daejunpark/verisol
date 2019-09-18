pragma solidity >=0.4.24<0.6.0;
import "./Libraries/VeriSolContracts.sol";

// extremely simplified version of GnosisSafe contract
// https://github.com/gnosis/safe-contracts/blob/development/contracts/GnosisSafe.sol

// model the reentrancy bug found by Runtime Verification, Inc.
// https://github.com/runtimeverification/verified-smart-contracts/blob/master/gnosis/GnosisSafe_RuntimeVerification.pdf

contract GnosisSafe {
    uint256 nonce;
    uint256 balance;

    constructor() public {
        nonce = 0;
        balance = 100;
    }

    function execTransaction(
        uint256 _nonce,
        SignatureChecker checker,
        Executor executor,
        uint256 signatures,
        uint256 value,
        uint256 data
    )
        external
        returns (bool success)
    {
        require(nonce == _nonce);

        nonce++;

        checker.checkSignatures(_nonce, signatures);

        require(balance >= value);
        balance -= value;
        success = executor.execute(_nonce, data);

        assert(balance == VeriSol.Old(balance) - value);
    }
}

contract SignatureChecker {
    GnosisSafe gnosis;
    Executor executor;
    uint256 value;
    uint256 data;
    uint256 count;
    function checkSignatures(uint256 nonce, uint256 signatures)
        public
    {
        if (count < 3) {
            count++;
            gnosis.execTransaction(nonce, this, executor, signatures, value, data);
        }
    }
}

contract Executor {
    GnosisSafe gnosis;
    SignatureChecker checker;
    uint256 value;
    uint256 data;
    uint256 count;
    function execute(uint256 nonce, uint256 signatures)
        public
        returns (bool success)
    {
        if (count < 3) {
            count++;
            success = gnosis.execTransaction(nonce, checker, this, signatures, value, data);
        }
    }
}
