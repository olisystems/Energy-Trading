pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";
contract DynamicGridFee is mortal{
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    
    //should have floor and ceiling grid fee and also basd on percentage loading.
    //Ability to unaccept load in case of overloading.
    //local grid fee based on ckt its loading.
    //transmission grid fee based on trafo loading.
    
    mapping (uint32 => address) GSO;
    
    //gridFee
    mapping (address => uint8[]) gridFee; //index-> 0:min trafoload Fee; 1:max trafoload Fee; 2:min cktload Fee; 3:max cktload Fee; 4:tFee 5:dFee

    
    mapping (uint32 => uint64[]) cktcamount; //trafoid -> ckt

    mapping (uint32 => uint64[]) cktramount;
    
    mapping (uint32 => uint64) trafocamount;
    
    mapping (uint32 => uint64) traforamount;
    
    uint8 perLoading;

    //Set Min/Max Grid Fee
    function set_minmaxgfee(address _address, uint8[] _amount) onlyowner {
        gridFee[_address] = _amount;
    }
    function set_cktcamount(address _addr, uint64 _amount) { 
        cktcamount[origin.get_oliTrafoid(_addr)][origin.get_oliCkt(_addr)] += _amount;
    }
    function set_cktramount(address _addr, uint64 _amount){
        cktramount[origin.get_oliTrafoid(_addr)][origin.get_oliCkt(_addr)] += _amount;
    }
    function addGSO(uint32 _tid, address _address) {
        GSO[_tid] = _address;
    }
    function set_dgridFee(uint32 _tid) {
        for(var b=0; b<origin.get_oliCkt(GSO[_tid]); b++) {
                perLoading = uint8(((uint128(cktcamount[_tid][b]-cktramount[_tid][b]))/origin.get_oliPeakLoad(GSO[_tid], (b+1)))*100);
                gridFee[GSO[_tid]][b+5] = perLoading*(gridFee[GSO[_tid]][3]);
        }
    }
    function set_trafocamount(address _addr, uint64 _amount){
        trafocamount[origin.get_oliTrafoid(_addr)] += _amount;
    }
    function set_traforamount(address _addr, uint64 _amount){
        traforamount[origin.get_oliTrafoid(_addr)] += _amount;
    }
    function set_tgridFee(uint32 _tid) {
        perLoading = uint8(((uint128(trafocamount[_tid]-traforamount[_tid]))/origin.get_oliPeakLoad(GSO[_tid],0))*100);
        gridFee[GSO[_tid]][4] = perLoading*(gridFee[GSO[_tid]][1]);
    }
    function get_dGFee(address _gso) constant returns (uint8) {
        return gridFee[_gso][origin.get_oliCkt(tx.origin)+5];
    }
    function get_tGFee(address _gso) constant returns (uint8) {
        return gridFee[_gso][4];
    }
}
