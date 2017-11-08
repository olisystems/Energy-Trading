pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

//Agents, DNO,TNOs mapping
contract OliOrigin is mortal{ 

    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }
    
    mapping (address => Details) OliAddressMapping;

    event newAddedOli(address paymentAddress, uint32 latOfLocation, uint32 longOfLocation, uint32 indexed trafoid, uint8 indexed ckt);
    
    struct Details {
        uint32 latitude;
        uint32 longitude;
        uint32 trafoid; //create 2D array with ckt id & trafo id
        uint8 ckt;
        uint8[] _type; //0:PV, 1:Wind, 2:CCP, 3:CHP, 4:Coal, 5:battery+, 6: battery-, 7:Consumer, 8:DNO (could be 
                       //an array in future in case of hybrid)
        uint64[] _pload; // if _type:7 then index:0->trafoload
    }
    
    function addOli(address oli, uint32 lat, uint32 long, uint32 trafo, uint8 ckt, uint8[] typex, uint64[] pload) onlyowner{
        OliAddressMapping[oli] = Details(lat, long, trafo, ckt, typex, pload);
        newAddedOli(oli, lat, long, trafo, ckt);
        if (typex[0]==7){
            dgfee.addGSO(trafo,oli);
        }
    }
    
    //Oli types passing to Daughter Auction
    function get_oliType(address _account) constant returns (uint8[]) {
        return OliAddressMapping[_account]._type;
    }
    //Oli amount passing to Daughter Auction
    function get_oliPeakLoad(address _account, uint8 _type) constant returns (uint64) {
        return OliAddressMapping[_account]._pload[_type];
    }

    function get_oliCkt(address _account) constant returns (uint8) {
        return OliAddressMapping[_account].ckt;
    }

    function get_oliTrafoid(address _account) constant returns (uint32) {
        return OliAddressMapping[_account].trafoid;
    }
}
