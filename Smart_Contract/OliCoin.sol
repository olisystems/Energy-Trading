pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract OliCoin is mortal{
    //Energy Balance Mapping
    mapping (address => int) OliCoinBalance; //Produce->inc & Consume->dec
    //Update CoinBalance
    function set_OliCoinBalance(address _account, int _change) {
        OliCoinBalance[_account] += _change;
    }
    
    /// Withdraw earned OliCoins.
    function withdraw() returns (bool) {
        int amount = OliCoinBalance[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            OliCoinBalance[msg.sender] = 0;
            if (!msg.sender.send(uint(amount))) {
                // No need to call throw here, just reset the amount owing
                OliCoinBalance[msg.sender] = amount;
                return false;
            }
        }
        else {
            return false;
        }
        return true;
    }
    
    //Deposit OliCoins
    function deposit(uint _value) onlyowner {
        OliCoinBalance[msg.sender] += int(_value);
    }
    //
    function get_coinBalance(address caddress) constant returns (int) {
        return OliCoinBalance[caddress];
    }
}

