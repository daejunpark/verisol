pragma solidity ^0.5.0;

import "./IERC20.sol";
import "./SafeMath.sol";


/**
 * A highly simplified Token to express basic specifications
 * 
 * - totalSupply() equals the Sum({balanceOf(a) | a is an address })
 * 
 */
contract ERC20 is IERC20 {

    mapping (address => uint256) private _balances;
    uint256 private _totalSupply;


    /**
     * A dummy constructor
     */
    constructor (uint256 totalSupply) public {
       require(msg.sender != address(0));
       _totalSupply = totalSupply;
       _balances[msg.sender] = totalSupply;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        uint oldBalanceSender = _balances[msg.sender];

        _transfer(msg.sender, recipient, amount); 

        assert (/* msg.sender == recipient ||  */ _balances[msg.sender] == oldBalanceSender - amount);
        
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount);

        _balances[sender] = SafeMath.sub(_balances[sender], amount);
        _balances[recipient] = SafeMath.add(_balances[recipient], amount);
    }
}

