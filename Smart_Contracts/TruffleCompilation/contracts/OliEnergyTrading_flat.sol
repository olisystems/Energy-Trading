pragma solidity ^0.4.11;

// File: contracts/owned.sol

contract owned {
    address owner;

    modifier onlyowner() {
        if (msg.sender == owner) {
            _;
        }
    }

    function owned() public {
        owner = msg.sender;
    }
}

// File: contracts/mortal.sol

contract mortal is owned {
  function kill() {
    if (msg.sender == owner) suicide(owner); 
  }
}

// File: contracts/OliEnergyTrading.sol

//Agents, DNO,TNOs mapping
contract OliDetail is mortal{
  
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
    //Delete CoinBalance
    function del_Coinbalance() {
        OliCoinBalance[msg.sender] = 0;
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

contract ParentAuction is mortal{
    //Account Details Callback function
    OliDetail origin;
    function setOliOrigin(address addr) { origin = OliDetail(addr); }
    //Earn OliCoins
    OliCoin coin;
    function setOliCoin(address addr) { coin = OliCoin(addr); }
    //Bids passing to parent auction
    //ParentAuction auction;
    //function setParentAddress(address addr) { auction = ParentAuction(addr); }
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    //uint32 tid;
    mapping (uint32 => bool) tid;
    
    //set conntected transformer
    function set_ContractAddress(uint32 _tid, bool _tf) onlyowner{
        tid[_tid] = _tf;
    }

    address[] _producer;    address[] _consumer;
    
    struct Details {
        uint8 rate; // cents/KW
        uint16 amount; // Kw
    }
    //Bidders Mapping
    mapping (address => Details) GenBid;
    mapping (address => Details) ConsBid;
    mapping (uint8 => uint16) SRate;
    mapping (uint8 => uint16) DRate;
    uint8 public maxRate;  uint8 minRate=10;
    //Bidders event recording
    event NewGenBid(address indexed gaddr, uint8 grate, uint16 gamount);
    event NewConBid(address indexed caddr, uint8 crate, uint16 camount);
    //New mcp
    event NewMcp(uint8 cbid);

    function bid(uint16 _amount, uint8 _rate) {
        //Mapping Producer's bidding
        if ((origin.get_oliType(msg.sender)>=uint8(0))&&(origin.get_oliType(msg.sender)<=uint8(5))&&(_amount>uint16(0))&&(tid[origin.get_oliTrafoid(tx.origin)])) {
            GenBid[msg.sender] = Details (_rate, _amount); 
            if (_rate > maxRate) {
                maxRate = _rate;
            }
            if (_rate < minRate) {
                minRate = _rate;
            }
            SRate[_rate] += _amount;
            NewGenBid (msg.sender,_rate, _amount);
            _producer.push(msg.sender);
        }
        //Mapping Consumer's bidding
        if ((origin.get_oliType(msg.sender) > uint8(5))&&(origin.get_oliType(msg.sender) <= uint8(7))&&(_amount>uint16(0))&&(tid[origin.get_oliTrafoid(tx.origin)])) {
            ConsBid[msg.sender] = Details (_rate,_amount);
            if (_rate > maxRate) {
                maxRate = _rate;
            }
            if (_rate < minRate) {
                minRate = _rate;
            }
            DRate[_rate] += _amount;
            NewConBid (msg.sender, _rate, _amount);
            _consumer.push(msg.sender);
        }
    }

    //Calculating MCP
    function breakEven() {
        //Supply/Demand Curve Plotting
        uint8 _max = maxRate;
        for (var y=1;y<=maxRate;y++) {
            SRate[y] += SRate[y-1];
            DRate[_max-1] += DRate[_max];
            _max--;
        }

        //Break-Even Finder
        for (var v = 0; v <= maxRate; v++) {
            if (SRate[v] >= DRate[v]) {
                if (DRate[v] > SRate[v-1]) {
                    NewMcp(v);
                }
                else {
                    NewMcp(v-1);
                    v--;
                }
                //Losers/Winners Mapping also add bool T/F, about winner/loser
                for (var q = 0; q < _producer.length; q++){
                    if(GenBid[_producer[q]].rate <= v) {
                        //Reward=rate-gFee
                        coin.set_OliCoinBalance(_producer[q], int32(((GenBid[_producer[q]].rate-dgfee.get_dGFee(_producer[q])) * GenBid[_producer[q]].amount)));
                        //GSO reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_producer[q])), int32(dgfee.get_dGFee(_producer[q])*GenBid[_producer[q]].amount));
                        dgfee.set_trafocamount(_producer[q], GenBid[_producer[q]].amount);
                    }
                }
                for (var r = 0; r < _consumer.length; r++){
                    if(ConsBid[_consumer[r]].rate >= v) {
                        //Payable=rate+gfee
                        coin.set_OliCoinBalance(_consumer[r], -int32(((ConsBid[_consumer[r]].rate+dgfee.get_dGFee(_consumer[r])) * ConsBid[_consumer[r]].amount)));
                        //GSO Reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_consumer[r])), int32(dgfee.get_dGFee(_consumer[r])*GenBid[_consumer[r]].amount));
                        dgfee.set_traforamount(_consumer[r], GenBid[_consumer[r]].amount);
                    }
                }
            break;
            }
        }
    }

    //reset
    function resett() {
        delete _producer;
        delete _consumer;
        for (var w=0;w<maxRate;w++) {
            SRate[w]=0;
            DRate[w]=0;
        }
        maxRate=10;
        minRate=10;
        dgfee.set_tgridFee(67376);
        dgfee.set_tgridFee(67377);
    }

    function get_producer() constant returns (address[]) {
        return _producer;
    }
    function get_consumer() constant returns (address[]) {
        return _consumer;
    }

    function get_sRate(uint8 _rate) constant returns (uint16) {
        return SRate[_rate];
    }

    function get_dRate(uint8 _rate) constant returns (uint16) {
        return DRate[_rate];
    }


}

contract DaughterAuction is mortal{
    //Account Details Callback function
    OliDetail origin;
    function setOliOrigin(address addr) { origin = OliDetail(addr); }
    //Earn OliCoins
    OliCoin coin;
    function setOliCoin(address addr) { coin = OliCoin(addr); }
    //Bids passing to parent auction
    //ParentAuction auction;
    //function setParentAddress(address addr) { auction = ParentAuction(addr); }
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    uint32 tid;
    
    function DaughterAuction() {
        tid=67376;
    }

    address[] _producer;    address[] _consumer;
    
    struct Details {
        uint8 rate; // cents/KW
        uint16 amount; // Kw
    }
    //Bidders Mapping
    mapping (address => Details) GenBid;
    mapping (address => Details) ConsBid;
    uint16 diff;
    mapping (uint8 => uint16) SRate;
    mapping (uint8 => uint16) DRate;
    uint8 public maxRate;  uint8 minRate=10;
    //Bidders event recording
    event NewGenBid(address indexed gaddr, uint8 grate, uint16 gamount);
    event NewConBid(address indexed caddr, uint8 crate, uint16 camount);
    //New mcp
    event NewMcp(uint8 cbid);

    function bid(uint16 _amount, uint8 _rate) {
        //Subtracting bilateral traded amount if any
        //if((btrade.get_stockAmount(msg.sender) > uint16(0))&&(_amount > btrade.get_stockAmount(msg.sender))) {_amount = _amount - btrade.get_stockAmount(msg.sender);}
        //Mapping Producer's bidding
        //
        if ((origin.get_oliType(msg.sender)>=uint8(0))&&(origin.get_oliType(msg.sender)<=uint8(5))&&(_amount>uint16(0))&&(tid==(origin.get_oliTrafoid(tx.origin)))) {
            GenBid[msg.sender] = Details (_rate, _amount); 
            if (_rate > maxRate) {
                maxRate = _rate;
            }
            if (_rate < minRate) {
                minRate = _rate;
            }
            SRate[_rate] += _amount;
            NewGenBid (msg.sender,_rate, _amount);
            _producer.push(msg.sender);
            /*if(btrade.get_stockAmount(msg.sender) > uint16(0)) {
                coin.set_OliCoinBalance(msg.sender, int32((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }*/
        }
        //Mapping Consumer's bidding
        if ((origin.get_oliType(msg.sender) > uint8(5))&&(origin.get_oliType(msg.sender) <= uint8(7))&&(_amount>uint16(0))&&(tid==(origin.get_oliTrafoid(tx.origin)))) {
            ConsBid[msg.sender] = Details (_rate,_amount);
            if (_rate > maxRate) {
                maxRate = _rate;
            }
            if (_rate < minRate) {
                minRate = _rate;
            }
            DRate[_rate] += _amount;
            NewConBid (msg.sender, _rate, _amount);
            _consumer.push(msg.sender);
            /*
            if(btrade.get_stockAmount(msg.sender) > uint16(0)) {
                coin.set_OliCoinBalance(msg.sender, -int32((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }*/
        }
    }

    //Calculating MCP
    function breakEven() {
        //Supply/Demand Curve Plotting
        uint8 _max = maxRate;
        for (var y=1;y<=maxRate;y++) {
            SRate[y] += SRate[y-1];
            DRate[_max-1] += DRate[_max];
            _max--;
        }

        //Break-Even Finder
        for (var v = 0; v <= maxRate; v++) {
            if (SRate[v] >= DRate[v]) {
                if (DRate[v] > SRate[v-1]) {
                    NewMcp(v);
                    diff = uint16(DRate[v] - SRate[v]);
                }
                else {
                    NewMcp(v-1);
                    diff = uint16(DRate[v-1] - SRate[v-1]);
                    v--;
                }
                //Losers/Winners Mapping also add bool T/F, about winner/loser
                for (var q = 0; q < _producer.length; q++){
                    if(GenBid[_producer[q]].rate < v) {
                        //Reward=rate-gFee
                        coin.set_OliCoinBalance(_producer[q], int32(((GenBid[_producer[q]].rate-dgfee.get_dGFee(_producer[q])) * GenBid[_producer[q]].amount)));
                        //GSO reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_producer[q])), int32(dgfee.get_dGFee(_producer[q])*GenBid[_producer[q]].amount));
                        dgfee.set_cktcamount(_producer[q], GenBid[_producer[q]].amount);
                    }
                    if(GenBid[_producer[q]].rate == v) {
                        //Reward=rate-gFee
                        coin.set_OliCoinBalance(_producer[q], int32(((GenBid[_producer[q]].rate-dgfee.get_dGFee(_producer[q])) * diff)));
                        //GSO reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_producer[q])), int32(dgfee.get_dGFee(_producer[q])*diff));
                        dgfee.set_cktcamount(_producer[q], diff);
                    }
                }
                for (var r = 0; r < _consumer.length; r++){
                    if(ConsBid[_consumer[r]].rate > v) {
                        //Payable=rate+gfee
                        coin.set_OliCoinBalance(_consumer[r], -int32(((ConsBid[_consumer[r]].rate+dgfee.get_dGFee(_consumer[r])) * ConsBid[_consumer[r]].amount)));
                        //GSO Reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_consumer[r])), int32(dgfee.get_dGFee(_consumer[r])*GenBid[_consumer[r]].amount));
                        dgfee.set_cktramount(_consumer[r], GenBid[_consumer[r]].amount);
                    }
                    if(ConsBid[_consumer[r]].rate == v) {
                        //Payable=rate+gfee
                        coin.set_OliCoinBalance(_consumer[r], -int32(((ConsBid[_consumer[r]].rate+dgfee.get_dGFee(_consumer[r])) * diff)));
                        //GSO Reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_consumer[r])), int32(dgfee.get_dGFee(_consumer[r])*diff));
                        dgfee.set_cktramount(_consumer[r], diff);
                    }
                }
            break;
            }
        }
    }

    //reset
    function resett() {
        delete _producer;
        delete _consumer;
        for (var w=0;w<maxRate;w++) {
            SRate[w]=0;
            DRate[w]=0;
        }
        maxRate=10;
        minRate=10;
        dgfee.set_dgridFee(origin.get_oliTrafoid(tx.origin));
    }

    function get_producer() constant returns (address[]) {
        return _producer;
    }
    function get_consumer() constant returns (address[]) {
        return _consumer;
    }

    function get_sRate(uint8 _rate) constant returns (uint16) {
        return SRate[_rate];
    }

    function get_dRate(uint8 _rate) constant returns (uint16) {
        return DRate[_rate];
    }


}

contract BilateralTrading is mortal{
    //Account Details Callback function
    OliDetail origin;
    function setOliOrigin(address addr) { origin = OliDetail(addr); }
    //Earn OliCoins
    OliCoin coin;
    function setOliCoin(address addr) { coin = OliCoin(addr); }
    // Set to true at the end, disallows any change
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    struct Details {
        uint16 amount;
        uint8 minMaxRate;
        uint32 contractPeriod; //in seconds
        uint32 biddingTime;
        uint32 currentTime;
        address higestBidder;
    }
    //Mapping Available Stock
    mapping (address => Details) availStock;
    //Event fired on new available Stock
    event NewStock(address saccount, uint16 samount, uint8 smrate, uint32 speriod, uint32 sbiddingTime);
    //Event fired on inceasing bid
    event NewStockBid(address baccount, uint8 bmrate);
    //Event fired on Bilateral Trade
    event BiTrade(address bprod, address bcons, uint16 bamount, uint8 brate);
    
    modifier validRequirement(uint16 oliAmount) {
        if (oliAmount > origin.get_oliPeakLoad(msg.sender,0))
            throw;
        _;
    }
    //Registeration of Bilateral Stock
    function regStock (uint16 _amount, uint8 _rate, uint32 _period, uint32 _btime) validRequirement(_amount) {
        availStock[msg.sender] = Details(_amount, _rate, (uint32(now)+_period), _btime, uint32(now), msg.sender);
        NewStock(msg.sender, _amount, _rate, (uint32(now)+_period), _btime);
    }
    function stockBidding(address _stock, uint8 _rate) {
        require(origin.get_oliTrafoid(_stock) == (origin.get_oliTrafoid(msg.sender)));
        require(now <= (availStock[_stock].currentTime + availStock[_stock].biddingTime));
        if (((origin.get_oliType(_stock)>=0)&&(origin.get_oliType(_stock)<=5))) {
            require(_rate > availStock[_stock].minMaxRate);
            availStock[_stock].minMaxRate = _rate;
            availStock[_stock].higestBidder = msg.sender;
            NewStockBid(_stock, _rate);
        }
        if (((origin.get_oliType(_stock)>=6)&&(origin.get_oliType(_stock)<=7))) {
            require(_rate < availStock[_stock].minMaxRate);
            availStock[_stock].minMaxRate = _rate;
            availStock[_stock].higestBidder = msg.sender;
            NewStockBid(_stock, _rate);
        }
    }
    
    function biTrade() {
        require(availStock[msg.sender].amount > 0);
        require(uint32(now) <= (availStock[msg.sender].contractPeriod));
        BiTrade(msg.sender,availStock[msg.sender].higestBidder,availStock[msg.sender].amount,availStock[msg.sender].minMaxRate);
        //producer coins
        coin.set_OliCoinBalance(msg.sender, int32(availStock[msg.sender].amount*(availStock[msg.sender].minMaxRate-dgfee.get_dGFee(msg.sender))));
        //consumer coins
        coin.set_OliCoinBalance(availStock[msg.sender].higestBidder, -int32(availStock[msg.sender].amount*(availStock[msg.sender].minMaxRate+dgfee.get_dGFee(msg.sender))));
        //GSO reward
        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(msg.sender)), int32(2*dgfee.get_dGFee(msg.sender)*availStock[msg.sender].amount));

    }
    function get_stockBidder(address _stock) constant returns (address) {
        return availStock[_stock].higestBidder;
    }
    function get_stockAmount(address _stock) constant returns (uint16) {
        return availStock[_stock].amount;
    }
    function get_stockRate(address _stock) constant returns (uint8) {
        return availStock[_stock].minMaxRate;
    }
}

contract DynamicGridFee is mortal{
    //Account Details Callback function
    OliDetail origin;
    function setOliOrigin(address addr) { origin = OliDetail(addr); }
    
    //should have floor and ceiling grid fee and also basd on percentage loading.
    //local grid fee based on ckt its loading.
    //transmission grid fee based on trafo loading.
    
    //cktload
    uint8 cktLoad;
    
    //trafoload
    mapping (uint32 => uint8) trafoLoad;
    
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
            //cktLoad = uint8(((uint16(cktamount[_tid][b]))*100)/origin.get_oliPeakLoad(origin.get_gsoAddr(_tid), (b+1)));
            if (cktamount[_tid][b]<=3500){
                gridFee[origin.get_gsoAddr(_tid)][b+5] = 1;
            }
            if ((cktamount[_tid][b]>3500) && (cktamount[_tid][b]<9000) ) {
                gridFee[origin.get_gsoAddr(_tid)][b+5] = 2;
            }
            if (cktamount[_tid][b]>=9000) {
                gridFee[origin.get_gsoAddr(_tid)][b+5] = 3;
            }
            cktamount[_tid][b] = 0;
        }
    }
    function set_trafocamount(address _addr, uint16 _amount){
        trafoamount[origin.get_oliTrafoid(_addr)] += int16(_amount);
    }
    function set_traforamount(address _addr, uint16 _amount){
        trafoamount[origin.get_oliTrafoid(_addr)] -= int16(_amount);
    }
    function set_tgridFee(uint32 _tid) {
        trafoLoad[_tid] = uint8(( uint16(trafoamount[_tid]) * uint16(100) ) / get_trafoPeakLoad(_tid) );
        if(trafoamount[_tid] <=1750){
            gridFee[origin.get_gsoAddr(_tid)][4] = 4;
        }
        if( (trafoamount[_tid] > 1750) && (trafoamount[_tid] < 4500) ){
            gridFee[origin.get_gsoAddr(_tid)][4] = 5;
        }
        if(trafoamount[_tid] >= 4500){
            gridFee[origin.get_gsoAddr(_tid)][4] = 6;
        }
        trafoamount[_tid] = 0;

/*
        if(trafoLoad[_tid] <=35){
            gridFee[origin.get_gsoAddr(_tid)][4] = 4;
        }
        if( (trafoLoad[_tid] > 35) && (trafoLoad[_tid] < 90) ){
            gridFee[origin.get_gsoAddr(_tid)][4] = 5;
        }
        if(trafoLoad[_tid] >= 90){
            gridFee[origin.get_gsoAddr(_tid)][4] = 6;
        }
        trafoamount[_tid] = 0;
*/
    }
    function get_trafoPeakLoad(uint32 _tid) constant returns(uint16) {
        return origin.get_oliPeakLoad(origin.get_gsoAddr(_tid),0);
    }
    function get_trafoAmount(address _addr) constant returns(int16) {
        return trafoamount[origin.get_oliTrafoid(_addr)];
    }
    function get_trafoLoad(uint32 _tid) constant returns(uint8) {
        return trafoLoad[_tid];
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
