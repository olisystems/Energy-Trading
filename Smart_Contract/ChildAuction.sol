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
    function callParentBid(address daccount, uint64 damount, uint8 drate)  {
        auction.bid(daccount,damount,drate);
    }
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    BilateralTrading btrade;
    function setBilateralTrading(address addr) { btrade = BilateralTrading(addr); }

    uint8[]  priceC;    address[] _producer;    uint64  camount;
    uint8[] priceR;    address[] _consumer;    uint64  ramount;
    uint8 bPrice;

    struct Details {
        uint8 rate; // cents/KW
        uint64 amount; // Kw
    }
    //Bidders Mapping
    mapping (address => Details) GenBid;
    mapping (address => Details) ConsBid;
    //Bidders event recording
    event NewGenBid(address gaddr, uint8 grate, uint64 gamount);
    event NewConBid(address caddr, uint8 crate, uint64 camount);
    //New mcp
    event NewMcp(uint8 cbid);
    
/*
    modifier validRequirement(uint64 oliAmount) {
        if (oliAmount > origin.get_oliPeakLoad((msg.sender),0))
            throw;
        _;
    }*/
    
    function bid(uint64 _amount, uint8 _rate) {
        //Subtracting bilateral traded amount if any
        if((btrade.get_stockAmount(msg.sender) > uint64(0))&&(_amount > btrade.get_stockAmount(msg.sender))) {_amount = _amount - btrade.get_stockAmount(msg.sender);}
        //Mapping Producer's bidding
        if ((origin.get_oliType(msg.sender) >= uint8(0))&&(origin.get_oliType(msg.sender) <= uint8(5))&&(_amount>uint64(0))) {
            GenBid[msg.sender] = Details (_rate, _amount); 
            NewGenBid (msg.sender,_rate, _amount);
            _producer.push(msg.sender);
            camount += _amount;
            if(btrade.get_stockAmount(msg.sender) > uint64(0)) {
                coin.set_OliCoinBalance(msg.sender, int((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }
        }
        //Mapping Consumer's bidding
        if ((origin.get_oliType(msg.sender) > uint8(5))&&(origin.get_oliType(msg.sender) <= uint8(7))&&(_amount>uint64(0))) {
            ConsBid[msg.sender] = Details (_rate,_amount);
            NewConBid (msg.sender, _rate, _amount);
            _consumer.push(msg.sender);
            ramount += _amount;
            if(btrade.get_stockAmount(msg.sender) > uint64(0)) {
                coin.set_OliCoinBalance(msg.sender, -int((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }
        }
    }
    //Bids Scaling
    function bidsScaling() {
        for (var k = 0; k < _producer.length; k++) {
            uint8 a = uint8(GenBid[_producer[k]].amount/uint64(camount/20));
            for (var n=0; n<a; n++) {
                priceC.push(GenBid[_producer[k]].rate);
            }
        }
        for (var l = 0; l < _consumer.length; l++) {
            uint8 b = uint8(ConsBid[_consumer[l]].amount/uint64(ramount/20));
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
        quickSort(priceC, uint8(0), uint8(priceC.length - 1));
        //consumer price sorting
        quickSort(priceR, uint8(0), uint8(priceR.length - 1));
        //Break-Even Finder
        var o = (priceR.length - 1);
        for (var p = 0; p < priceC.length; p++) {
            if (priceC[p] > priceR[o]) {
                if (priceC[p-1] == priceR[o+1]) {
                    bPrice = priceC[p-1];
                    NewMcp(bPrice);
                    mcp = true;
                    break;
                }
                if (priceC[p-1] < priceR[o+1]) {
                    bPrice = ((priceC[p-1] + priceR[o+1]) / 2);
                    NewMcp(bPrice);
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
                    //auction.bid(_producer[q], GenBid[_producer[q]].amount, GenBid[_producer[q]].rate);
                }
                else {
                    //Reward=rate-gFee
                    coin.set_OliCoinBalance(_producer[q], int(((GenBid[_producer[q]].rate-dgfee.get_dGFee(_producer[q])) * GenBid[_producer[q]].amount)));
                    //GSO reward
                    coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_producer[q])), int(dgfee.get_dGFee(_producer[q])*GenBid[_producer[q]].amount));
                    dgfee.set_cktcamount(_producer[q], GenBid[_producer[q]].amount);
                }
            }
            for (var r = 0; r < _consumer.length; r++){
                if(ConsBid[_consumer[r]].rate < bPrice){
                    //auction.bid(_consumer[r], ConsBid[_consumer[r]].amount, ConsBid[_consumer[r]].rate);
                }
                else {
                    //Payable=rate+gfee
                    coin.set_OliCoinBalance(_consumer[r], -int(((ConsBid[_consumer[r]].rate+dgfee.get_dGFee(_consumer[r])) * ConsBid[_consumer[r]].amount)));
                    //GSO Reward
                    coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_consumer[r])), int(dgfee.get_dGFee(_consumer[r])*GenBid[_consumer[r]].amount));
                    dgfee.set_cktramount(_consumer[r], GenBid[_consumer[r]].amount);
                }
            }
        }
        else {
            for (var s = 0; s < _producer.length; s++){
                    //auction.bid(_producer[s], GenBid[_producer[s]].amount, GenBid[_producer[s]].rate);
            }
            for (var t = 0; t < _consumer.length; t++){
                    //auction.bid(_consumer[t], ConsBid[_consumer[t]].amount, ConsBid[_consumer[t]].rate);
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
        dgfee.set_dgridFee(origin.get_oliTrafoid(tx.origin));
    }

    //consumer price array
    function get_RArray() returns(uint8[]) {
        return priceR;
    }
    //producer price array
    function get_CArray() returns(uint8[]) {
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
