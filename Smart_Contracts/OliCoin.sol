pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract OliCoin is mortal{
    //Energy Balance Mapping
    mapping (address => int32) OliCoinBalance; //Produce->inc & Consume->dec
    
    mapping (address =>bool) ContractAddress;
    
    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint16 _value);

    //set contract access
    function set_ContractAddress(address _contract, bool _tf) onlyowner{
        ContractAddress[_contract] = _tf;
    }

    modifier onlyvalidcontract() {
        require(ContractAddress[msg.sender]);
        _;
    }

    //Update CoinBalance
    function set_OliCoinBalance(address _account, int32 _change) onlyvalidcontract {
        OliCoinBalance[_account] += _change;
    }
    
    // Transfer the balance from owner's account to another account
    function transfer(address _to, uint16 _amount) returns (bool success) {
        if (OliCoinBalance[msg.sender] > 0
        && uint32(OliCoinBalance[msg.sender]) >= _amount
        && _amount > 0
        && uint32(OliCoinBalance[_to]) + _amount > uint32(OliCoinBalance[_to])) {
            OliCoinBalance[msg.sender] -= int32(_amount);
            OliCoinBalance[_to] += int32(_amount);
            Transfer(msg.sender, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }
    //
    function get_coinBalance(address caddress) constant returns (int32) {
        return OliCoinBalance[caddress];
    }
}
