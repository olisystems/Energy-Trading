pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract DynamicGridFee is mortal{
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    
    //should have floor and ceiling grid fee and also basd on percentage loading.
    //local grid fee based on ckt its loading.
    //transmission grid fee based on trafo loading.

    //gridFee
    mapping (address => mapping(uint8 => uint8)) gridFee; //address:GSO | index-> 0:min trafoload Fee; 1:max trafoload Fee; 2:min cktload Fee; 3:max cktload Fee; 4:tFee 5:dFee

    mapping (uint32 => mapping(uint8=>int16)) cktamount; //trafoid -> ckt(+:prod;-:cons)

    mapping (uint32 => int16) trafoamount; //(+:prod;-:cons)

    //Set Min/Max Grid Fee
    function set_minmaxgfee(address _address, uint8[] _fee) onlyowner {
        for(var a=0;a<_fee.length;a++){
            gridFee[_address][a] = _fee[a];
        }
    }
    function set_cktcamount(address _addr, uint16 _amount) { 
        cktamount[origin.get_oliTrafoid(_addr)][origin.get_oliCkt(_addr)] += int16(_amount);
    }
    function set_cktramount(address _addr, uint64 _amount) {
        cktamount[origin.get_oliTrafoid(_addr)][origin.get_oliCkt(_addr)] -= int16(_amount);
    }
    function set_dgridFee(uint32 _tid) {
        for(var b=0; b<origin.get_oliCkt(origin.get_gsoAddr(_tid)); b++) {
            gridFee[origin.get_gsoAddr(_tid)][b+5] = uint8(gridFee[origin.get_gsoAddr(_tid)][2]) + (gridFee[origin.get_gsoAddr(_tid)][3]*uint8(((uint16(cktamount[_tid][b]))*100)/origin.get_oliPeakLoad(origin.get_gsoAddr(_tid), (b+1)))/100);
            cktamount[_tid][b] =0;
        }
    }
    function set_trafocamount(address _addr, uint16 _amount){
        trafoamount[origin.get_oliTrafoid(_addr)] += int16(_amount);
    }
    function set_traforamount(address _addr, uint16 _amount){
        trafoamount[origin.get_oliTrafoid(_addr)] -= int16(_amount);
    }
    function set_tgridFee(uint32 _tid) {
        gridFee[origin.get_gsoAddr(_tid)][4] = uint8(gridFee[origin.get_gsoAddr(_tid)][0]) + (gridFee[origin.get_gsoAddr(_tid)][1]*uint8(((uint16(trafoamount[_tid]))*100)/origin.get_oliPeakLoad(origin.get_gsoAddr(_tid),0))/100);
        delete trafoamount[_tid];
    }
    function get_trafoAmount(address _addr) constant returns(int16) {
        return trafoamount[origin.get_oliTrafoid(_addr)];
    }
    function get_dGFee(address _addr) constant returns (uint8) {
        return gridFee[origin.get_gsoAddr(origin.get_oliTrafoid(_addr))][origin.get_oliCkt(_addr)+5];
    }
    function get_tGFee(address _addr) constant returns (uint8) {
        return gridFee[origin.get_gsoAddr(origin.get_oliTrafoid(_addr))][4];
    }
    function get_gridFee(uint32 _tid, uint8 _index) constant returns (uint8) {
            return gridFee[origin.get_gsoAddr(_tid)][_index];
    }
    function get_cktAmount(uint32 _tid, uint8 _index) constant returns (int16) {
            return cktamount[_tid][_index];
    }
    
}
