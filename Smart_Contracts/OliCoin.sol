pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract OliCoin is mortal{
    //Energy Balance Mapping
    mapping (address => int) OliCoinBalance; //Produce->inc & Consume->dec
    
    mapping (address =>bool) ContractAddress;
    
    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint64 _value);

    //set contract access
    function set_ContractAddress(address _contract, bool _tf) onlyowner{
        ContractAddress[_contract] = _tf;
    }

    modifier onlyvalidcontract() {
        require(ContractAddress[msg.sender]);
        _;
    }

    //Update CoinBalance
    function set_OliCoinBalance(address _account, int _change) onlyvalidcontract {
        OliCoinBalance[_account] += _change;
    }
    
    // Transfer the coins from owner's account to another account
    function transfer(address _to, uint64 _amount) returns (bool success) {
        if (OliCoinBalance[msg.sender] > 0
        && uint64(OliCoinBalance[msg.sender]) >= _amount
        && _amount > 0
        && uint64(OliCoinBalance[_to]) + _amount > uint64(OliCoinBalance[_to])) {
            OliCoinBalance[msg.sender] -= int128(_amount);
            OliCoinBalance[_to] += int128(_amount);
            Transfer(msg.sender, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }

    //get coinbalance
    function get_coinBalance(address caddress) constant returns (int) {
        return OliCoinBalance[caddress];
    }
}
