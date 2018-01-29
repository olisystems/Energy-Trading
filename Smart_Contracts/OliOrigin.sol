pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract OliOrigin is mortal{
  
    mapping (address => Details) OliAddressMapping;
    mapping (uint32 => address) GSO;


    event newAddedOli(address paymentAddress, uint32 latOfLocation, uint32 longOfLocation);
    
    struct Details {
        uint32 latitude;
        uint32 longitude;
        uint32 trafoid;
        uint8 ckt; //In case of Prosumers' ckt rep. --> 1st ckt:0; 2nd ckt:1; In case of Trafo 4branches --> 4 ckt
        uint8 _type; //0:PV, 1:Wind, 2:CCP, 3:CHP, 4:Coal, 5:battery+, 6: battery-, 7:Consumer, 8:DNO
        uint16[] _pload; // if _type=8 then index:0->trafoload
    }

    function addOli(address oli, uint32 lat, uint32 long, uint32 trafo, uint8 ckt, uint8 typex, uint16[] pload) onlyowner{
        OliAddressMapping[oli] = Details(lat, long, trafo, ckt, typex, pload);
        newAddedOli(oli, lat, long);
        if (typex==8){
            GSO[trafo]=oli;
        }
    }

    //Oli types passing to Daughter Auction
    function get_oliType(address _account) constant returns (uint8) {
        return OliAddressMapping[_account]._type;
    }
    //Oli amount passing to Daughter Auction
    function get_oliPeakLoad(address _account, uint8 _index) constant returns (uint16) {
        return OliAddressMapping[_account]._pload[_index];
    }

    function get_oliCkt(address _account) constant returns (uint8) {
        return OliAddressMapping[_account].ckt;
    }

    function get_oliTrafoid(address _account) constant returns (uint32) {
        return OliAddressMapping[_account].trafoid;
    }
    function get_gsoAddr(uint32 _tid) constant returns (address) {
        return GSO[_tid];
    }
    
}
