pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract DaughterAuction is mortal{
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    //Earn OliCoins
    OliCoin coin;
    function setOliCoin(address addr) { coin = OliCoin(addr); }
    //Bids passing to parent auction
    ParentAuction auction;
    function setParentAddress(address addr) { auction = ParentAuction(addr); }
    function callParentBid(address daccount, uint64 damount, uint8 drate, uint8 _type)  {
        auction.bid(daccount,damount,drate,_type);
    }
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    uint auctionStart;    uint biddingTime;
    uint8[]  priceC;    address[] _producer;    uint64  camount;
    uint8[] priceR;    address[] _consumer;    uint64  ramount;
    uint8 bPrice;    address[] beneficiary;
    //Local Grid Fee
    //uint128 gridFee;
    //Transmission Grid Fee
    //uint128 tGridFee;
    struct Details {
        uint8 rate; // cents/KWh
        uint64 amount; // Kwh
        uint8 ptype;
    }
    function() payable {
    }
    //Bidders Mapping
    mapping (address => Details) GenBid;
    mapping (address => Details) ConsBid;
    //Bidders event recording
    event NewGenBid(address gbidder, uint8 grate, uint64 gamount, uint8 _type);
    event NewConBid(address cbidder, uint8 crate, uint64 camount, uint8 _type);
    //Losers event recording
    event NewGenLosBid(address glbidder, uint8 glrate, uint64 glamount, uint8 _type);
    event NewConLosBid(address clbidder, uint8 clrate, uint64 clamount, uint8 _type);
    //New mcp
    event NewMcp(uint8 cbid, uint32 cbtime);
    
    struct BiDetails {
        uint64 amount;
        uint8 Rate;
        uint8 powerType; //0:PV, 1:Wind, 2:CCP, 3:CHP, 4:Coal, 5:Consumer
        uint32 contractPeriod; //in seconds
        address consumer;
    }
    modifier validRequirement(uint64 oliAmount, uint8 _type) {
        if (oliAmount > origin.get_oliPeakLoad(msg.sender,_type))
            throw;
        _;
    }
    //Map Bilateral Trade
    mapping (address => BiDetails) BiTrade;
    //Event Recording on Bilateral Trade
    event NewBiTrade(address bproducer, uint64 bamount, uint8 brate, uint8 btype, uint32 bperiod, address bconsumer);
    function biTadeMapping (address _producer, uint64 _amount, uint8 _rate, uint8 _type, uint32 _period, address _consumer) {
        BiTrade[_producer] = BiDetails(_amount, _rate, _type, _period, _consumer);
        NewBiTrade(_producer, _amount, _rate, _type, _period, _consumer);
    }
    function bid(uint64 _amount, uint8 _rate, uint8 _type) validRequirement(_amount,_type) {
        //Subtracting bilateral traded amount if any
        if((BiTrade[msg.sender].amount > 0)&&(_amount > BiTrade[msg.sender].amount)) {_amount = _amount - BiTrade[msg.sender].amount;}
        //Mapping Producer's bidding
        if ((_type >= 0)&&(_type <= 5)&&(_amount>0)) {
            GenBid[msg.sender] = Details ((_rate-dgfee.get_dGFee(origin.get_oliCkt(tx.origin))), _amount, _type);
            NewGenBid (msg.sender, (_rate-dgfee.get_dGFee(origin.get_oliCkt(tx.origin))), _amount, _type);
            _producer.push(msg.sender);
            camount += _amount;
            if(BiTrade[msg.sender].amount > 0) {
                coin.set_OliCoinBalance(msg.sender, int((BiTrade[msg.sender].Rate * BiTrade[msg.sender].amount)));
            }
        }
        //Mapping Consumer's bidding
        if ((_type > 5)&&(_type <= 7)&&(_amount<0)) {
            ConsBid[msg.sender] = Details ((_rate-dgfee.get_dGFee(origin.get_oliCkt(tx.origin))), _amount, _type);
            NewConBid (msg.sender, (_rate-dgfee.get_dGFee(origin.get_oliCkt(tx.origin))), _amount, _type);
            _consumer.push(msg.sender);
            ramount += _amount;
            if(BiTrade[msg.sender].amount > 0) {
                coin.set_OliCoinBalance(msg.sender, -int((BiTrade[msg.sender].Rate * BiTrade[msg.sender].amount)));
            }
        }
    }
    //Bids Scaling
    function bidsScaling() {
        uint cstep = camount/20;
        uint rstep = ramount/20;
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
    //source: https://ethereum.stackexchange.com/questions/1517/sorting-an-array-of-integer-with-ethereum
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
                    NewMcp(bPrice, uint32(now));
                    mcp = true;
                    break;
                }
                if (priceC[p-1] < priceR[o+1]) {
                    bPrice = ((priceC[p-1] + priceR[o+1]) / 2);
                    NewMcp(bPrice, uint32(now));
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
                    NewGenLosBid (_producer[q], GenBid[_producer[q]].rate, GenBid[_producer[q]].amount, GenBid[_producer[q]].ptype);
                    callParentBid(_producer[q], GenBid[_producer[q]].amount, GenBid[_producer[q]].rate, GenBid[_producer[q]].ptype);
                }
                else {
                    coin.set_OliCoinBalance(_producer[q], int((GenBid[_producer[q]].rate * GenBid[_producer[q]].amount)));
                    dgfee.set_cktcamount(_producer[q], GenBid[_producer[q]].amount);
                }
            }
            for (var r = 0; r < _consumer.length; r++){
                if(ConsBid[_consumer[r]].rate < bPrice){
                    NewConLosBid (_consumer[r], ConsBid[_consumer[r]].rate, ConsBid[_consumer[r]].amount,GenBid[_producer[q]].ptype);
                    callParentBid(_consumer[r], ConsBid[_consumer[r]].amount, ConsBid[_consumer[r]].rate,GenBid[_producer[q]].ptype);
                }
                else {
                    coin.set_OliCoinBalance(_consumer[r], -int((ConsBid[_consumer[r]].rate * ConsBid[_consumer[r]].amount)));
                    dgfee.set_cktramount(_consumer[r], GenBid[_consumer[r]].amount);
                }
            }
        }
        else {
            for (var s = 0; s < _producer.length; s++){
                    NewGenLosBid (_producer[q], GenBid[_producer[q]].rate, GenBid[_producer[q]].amount,GenBid[_producer[q]].ptype);
                    callParentBid(_producer[q], GenBid[_producer[q]].amount, GenBid[_producer[q]].rate,GenBid[_producer[q]].ptype);
            }
            for (var t = 0; t < _consumer.length; t++){
                    NewConLosBid (_consumer[r], ConsBid[_consumer[r]].rate, ConsBid[_consumer[r]].amount,GenBid[_producer[q]].ptype);
                    callParentBid(_consumer[r], ConsBid[_consumer[r]].amount, ConsBid[_consumer[r]].rate,GenBid[_producer[q]].ptype);
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
    function get_bValue() constant returns (uint) {
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
