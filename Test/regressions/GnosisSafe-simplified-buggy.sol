pragma solidity >=0.4.24<0.6.0;
import "./Libraries/VeriSolContracts.sol";

// extremely simplified version of GnosisSafe contract
// https://github.com/gnosis/safe-contracts/blob/development/contracts/GnosisSafe.sol

// model the reentrancy bug found by Runtime Verification, Inc.
// https://github.com/runtimeverification/verified-smart-contracts/blob/master/gnosis/GnosisSafe_RuntimeVerification.pdf

contract GnosisSafe {
    uint256 nonce;
    mapping (address => bool) public isOwner;

    // to simulate transfer
    uint256 balance;

    constructor(
        bytes32 txDataHash, uint256 signatures // to simulate ecrecover
    )
        public
    {
        nonce = 0;
        balance = 100;
        isOwner[msg.sender] = true;
        // to simulate ecrecover
        recoverMap[keccak256(abi.encodePacked(txDataHash, signatures))] = msg.sender;
    }

    function execTransaction(
        SignatureChecker checker,
        Executor executor,
        uint256 signatures,
        uint256 value,
        uint256 data
    )
        external
        returns (bool success)
    {
        bytes memory txData = abi.encodePacked(data, nonce);
        bytes32 txDataHash = keccak256(txData);
        address owner = recover(txDataHash, signatures);
        require(isOwner[owner]);

        checker.checkSignatures(this, executor, signatures);

        nonce++;

        require(balance >= value);
        balance -= value;

        success = executor.execute(this, checker, data);

        assert(balance == VeriSol.Old(balance) - value);
    }

    // to simulate ecrecover

    mapping (bytes32 => address) public recoverMap;
    /* FIXME: nested mappings are not properly initialized
    mapping (bytes32 => mapping (uint256 => address)) public recoverMap;
    */

    function recover(bytes32 txDataHash, uint256 signatures)
        internal
        returns (address owner)
    {
        owner = recoverMap[keccak256(abi.encodePacked(txDataHash, signatures))];
        /*
        owner = recoverMap[txDataHash][signatures];
        */
    }

}

// to model attack vectors

contract SignatureChecker {
    // these storage values are unknown but fixed
    uint256 value;
    uint256 data;
    uint256 count;
    function checkSignatures(
        GnosisSafe gnosis, Executor executor, // to avoid multiple instances
        uint256 signatures
    )
        public
    {
        if (count < 3) {
            count++;
            gnosis.execTransaction(this, executor, signatures, value, data);
        }
    }
}

contract Executor {
    // these storage values are unknown but fixed
    uint256 signatures;
    uint256 value;
    uint256 count;
    function execute(
        GnosisSafe gnosis, SignatureChecker checker, // to avoid multiple instances
        uint256 data
    )
        public
        returns (bool success)
    {
        if (count < 3) {
            count++;
            success = gnosis.execTransaction(checker, this, signatures, value, data);
        }
    }
}
