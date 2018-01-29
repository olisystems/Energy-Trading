pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract BilateralTrading is mortal{
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    // Set to true at the end, disallows any change
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
    modifier validRequirement(uint16 oliAmount) {
        if (oliAmount > origin.get_oliPeakLoad(msg.sender,0))
            throw;
        _;
    }
    //Registeration of Bilateral Stock
    function regStock (uint16 _amount, uint8 _rate, uint32 _period, uint32 _btime) validRequirement(_amount) {
        availStock[msg.sender] = Details(_amount, _rate, _period, _btime, uint32(now), msg.sender);
        NewStock(msg.sender, _amount, _rate, _period, _btime);
    }
    function stockBidding(address _stock, uint8 _rate) {
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
