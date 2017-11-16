pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract ParentAuction is mortal{
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    //Earn OliCoins
    OliCoin coin;
    function setOliCoin(address addr) { coin = OliCoin(addr); }
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    uint auctionStart;    uint biddingTime;
    uint8[]  priceC;    address[] _producer;    uint64 camount;
    uint8[] priceR;    address[] _consumer;    uint64  ramount;
    uint8 bPrice;    address[] beneficiary;
    struct Details {
        uint8 rate; // cents/KWh
        uint64 amount; // Kwh
    }
    function() payable {
    }
    //Bidders Mapping
    mapping (address => Details) GenBid;
    mapping (address => Details) ConsBid;
    //Winners Mapping
    //Bidders event recording
    event NewGenBid(address gbidder, uint8 grate, uint64 gamount);
    event NewConBid(address cbidder, uint8 crate, uint64 camount);
    //Losers event recording
    event NewGenLosBid(address glbidder, uint8 glrate, uint64 glamount);
    event NewConLosBid(address clbidder, uint8 clrate, uint64 clamount);
    //New mcp
    event NewMcp(uint8 cbid);

/*    modifier validRequirement(uint64 oliAmount) {
        if (oliAmount > origin.get_oliPeakLoad(msg.sender,0))
            throw;
        _;
    }*/

    function bid(address baddress, uint64 _amount, uint8 _rate) {
        //Mapping Producer's bidding
        if ((origin.get_oliType(baddress) >= 0)&&(origin.get_oliType(baddress) <= 5)) {
            GenBid[baddress] = Details (_rate,_amount); //-dgfee.get_dGFee(msg.sender)
            NewGenBid (baddress, _rate, _amount);
            _producer.push(baddress);
            camount += _amount;
        }
        //Mapping Consumer's bidding
        else {
            ConsBid[baddress] = Details (_rate, _amount);
            NewConBid (baddress, _rate, _amount);
            _consumer.push(baddress);
            ramount += _amount;
        }
    }
    //Bids Scaling
    function bidsScaling() internal {
        uint cstep = camount/10;
        uint rstep = ramount/10;
        for (var k = 0; k < _producer.length; k++) {
            uint a = GenBid[_producer[k]].amount/cstep;
            for (var n=0; n<a; n++) {
                priceC.push(GenBid[_producer[k]].rate);
            }
        }
        for (var l = 0; l < _consumer.length; l++) {
            uint b = ConsBid[_consumer[l]].amount/rstep;
            for (var m=0; m<b; m++) {
                priceR.push(ConsBid[_consumer[l]].rate);
            }
        }
    }
    //source : https://ethereum.stackexchange.com/questions/1517/sorting-an-array-of-integer-with-ethereum
    function quickSort(uint8[] storage arr, uint8 left, uint8 right) internal {
        uint8 i = left;
        uint8 j = right;
        uint8 pivot = arr[left + (right - left) / 2];
        while (i <= j) {
            while (arr[i] < pivot) i++;
            while (pivot < arr[j]) j--;
            if (i <= j) {
                (arr[i], arr[j]) = (arr[j], arr[i]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }
    bool mcp = false;
    //Calculating MCP
    function breakEven() {
        //scaling bids
        bidsScaling();
        //producer price sorting
        quickSort(priceC, 0, uint8(priceC.length - 1));
        //consumer price sorting
        quickSort(priceR, 0, uint8(priceR.length - 1));
        //Break-Even Finder
        var o = (priceR.length - 1);
        for (var p = 0; p < priceC.length; p++) {
            if (priceC[p] > priceR[o]) {
                if (priceC[p-1] == priceR[o+1]) {
                    bPrice = priceC[p-1];
                    NewMcp(priceC[p-1]);
                    mcp = true;
                    break;
                }
                if (priceC[p-1] < priceR[o+1]) {
                    bPrice = ((priceC[p-1] + priceR[o+1]) / 2);
                    NewMcp(((priceC[p-1] + priceR[o+1]) / 2));
                    mcp = true;
                    break;
                }
            break;    
            }
            o -=1;
        }
        //Losers/Winners Mapping
        if (mcp == true) {
            for (var q = 0; q < _producer.length; q++){
                if(GenBid[_producer[q]].rate > bPrice){
                    NewGenLosBid (_producer[q], GenBid[_producer[q]].rate, GenBid[_producer[q]].amount);
                }
                else {
                    coin.set_OliCoinBalance(_producer[q], int((GenBid[_producer[q]].rate * GenBid[_producer[q]].amount)));
                    dgfee.set_trafocamount(_producer[q], GenBid[_producer[q]].amount);
                }
            }
            for (var r = 0; r < _consumer.length; r++){
                if(ConsBid[_consumer[r]].rate < bPrice){
                    NewConLosBid (_consumer[r], ConsBid[_consumer[r]].rate, ConsBid[_consumer[r]].amount);
                }
                else {
                    coin.set_OliCoinBalance(_consumer[r], -int((ConsBid[_consumer[r]].rate * ConsBid[_consumer[r]].amount)));
                    dgfee.set_traforamount(_producer[q], GenBid[_producer[q]].amount);
                }
            }
        }
        else {
            for (var s = 0; s < _producer.length; s++){
                NewGenLosBid (_producer[s], GenBid[_producer[s]].rate, GenBid[_producer[s]].amount);
            }
            for (var t = 0; t < _consumer.length; t++){
                NewConLosBid (_consumer[t], ConsBid[_consumer[t]].rate, ConsBid[_consumer[t]].amount);
            }
        }
        resett();
    }
    
    //reset
    function resett() {
        delete priceC;
        delete priceR;
        delete _producer;
        delete _consumer;
        delete camount;
        delete ramount;
        mcp = false;
        dgfee.set_tgridFee(origin.get_oliTrafoid(tx.origin));
    }    
    
    //consumer price array
    function getR_Array() returns(uint8[]) {
        return priceR;
    }
    //producer price array
    function getC_Array() returns(uint8[]) {
        return priceC;
    }
    //Get Break-Even Point
    function get_bValue() constant returns (uint8) {
        return bPrice;
    }
    function get_cAmount() constant returns (uint) {
        return camount;
    }
    function get_rAmount() constant returns (uint) {
        return ramount;
    }
    function get_producer() constant returns (address[]) {
        return _producer;
    }
    function get_consumer() constant returns (address[]) {
        return _consumer;
    }
}
