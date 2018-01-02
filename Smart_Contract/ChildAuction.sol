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
    //gridFee
    DynamicGridFee dgfee;
    function setDynamicGridFee(address addr) { dgfee = DynamicGridFee(addr); }

    BilateralTrading btrade;
    function setBilateralTrading(address addr) { btrade = BilateralTrading(addr); }

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
        //Subtracting bilateral traded amount if any
        if((btrade.get_stockAmount(msg.sender) > uint16(0))&&(_amount > btrade.get_stockAmount(msg.sender))) {_amount = _amount - btrade.get_stockAmount(msg.sender);}
        //Mapping Producer's bidding
        if ((origin.get_oliType(msg.sender) >= uint8(0))&&(origin.get_oliType(msg.sender) <= uint8(5))&&(_amount>uint16(0))) {
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
            if(btrade.get_stockAmount(msg.sender) > uint16(0)) {
                coin.set_OliCoinBalance(msg.sender, int32((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }
        }
        //Mapping Consumer's bidding
        if ((origin.get_oliType(msg.sender) > uint8(5))&&(origin.get_oliType(msg.sender) <= uint8(7))&&(_amount>uint16(0))) {
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
            if(btrade.get_stockAmount(msg.sender) > uint16(0)) {
                coin.set_OliCoinBalance(msg.sender, -int32((btrade.get_stockRate(msg.sender) * btrade.get_stockAmount(msg.sender))));
            }
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
                }
                //Losers/Winners Mapping also add bool T/F, about winner/loser
                /*for (var q = 0; q < _producer.length; q++){
                    if(GenBid[_producer[q]].rate <= v) {
                        //Reward=rate-gFee
                        coin.set_OliCoinBalance(_producer[q], int32(((GenBid[_producer[q]].rate-dgfee.get_dGFee(_producer[q])) * GenBid[_producer[q]].amount)));
                        //GSO reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_producer[q])), int32(dgfee.get_dGFee(_producer[q])*GenBid[_producer[q]].amount));
                        dgfee.set_cktcamount(_producer[q], GenBid[_producer[q]].amount);
                    }
                }
                for (var r = 0; r < _consumer.length; r++){
                    if(ConsBid[_consumer[r]].rate >= v) {
                        //Payable=rate+gfee
                        coin.set_OliCoinBalance(_consumer[r], -int32(((ConsBid[_consumer[r]].rate+dgfee.get_dGFee(_consumer[r])) * ConsBid[_consumer[r]].amount)));
                        //GSO Reward
                        coin.set_OliCoinBalance(origin.get_gsoAddr(origin.get_oliTrafoid(_consumer[r])), int32(dgfee.get_dGFee(_consumer[r])*GenBid[_consumer[r]].amount));
                        dgfee.set_cktramount(_consumer[r], GenBid[_consumer[r]].amount);
                    }
                }*/
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
