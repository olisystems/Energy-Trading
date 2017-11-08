pragma solidity ^0.4.11;

import "github.com/ethereum/solidity/std/mortal.sol";

contract BilateralTrading is mortal{
    //Bids passing to parent auction
    DaughterAuction auction;
    function setDaughterAddress(address addr) { auction = DaughterAuction(addr); }
    function updateBilateralTrade(address stockOwner) {
        require(now > (availStock[stockOwner].currentTime + availStock[stockOwner].biddingTime));
        auction.biTadeMapping(stockOwner, availStock[stockOwner].amount, availStock[stockOwner].minMaxRate, availStock[stockOwner].powerType, availStock[stockOwner].contractPeriod, availStock[stockOwner].higestBidder);
    }
    //Account Details Callback function
    OliOrigin origin;
    function setOliOrigin(address addr) { origin = OliOrigin(addr); }
    // Set to true at the end, disallows any change
    struct Details {
        uint64 amount;
        uint8 minMaxRate;
        uint8 powerType; //0:PV, 1:Wind, 2:CCP, 3:CHP, 4:Coal, 5:Consumer
        uint32 contractPeriod; //in seconds
        uint32 biddingTime;
        uint32 currentTime;
        address higestBidder;
    }
    //Mapping Available Stock
    mapping (address => Details) availStock;
    //Event fired on new available Stock
    event NewStock(address saccount, uint64 samount, uint8 smrate, uint8 stype, uint32 speriod, uint32 sbiddingTime, uint32 scurrentTime, address shbidder);
    //Event fired on inceasing bid
    event NewStockBid(address baccount, uint64 bamount, uint8 bmrate, uint8 btype, uint32 bperiod, uint32 bbiddingTime, uint32 bcurrentTime, address bhbidder);
    modifier validRequirement(uint64 oliAmount, uint8 _type) {
        if (oliAmount > origin.get_oliPeakLoad(msg.sender,_type))
            throw;
        _;
    }
    //Registeration of Bilateral Stock
    function regStock (uint64 _amount, uint8 _rate, uint8 _type, uint32 _period, uint32 _btime) validRequirement(_amount,_type) {
        availStock[msg.sender] = Details(_amount, _rate, _type, _period, _btime, uint32(now), msg.sender);
        NewStock(msg.sender, _amount, _rate, _type, _period, _btime, uint32(now), msg.sender);
    }
    function stockBidding(address _stock, uint8 _rate) {
        require(now <= (availStock[_stock].currentTime + availStock[_stock].biddingTime));
        if (((availStock[_stock].powerType>=0)&&(availStock[_stock].powerType<5))) {
            require(_rate > availStock[_stock].minMaxRate);
            availStock[_stock].minMaxRate = _rate;
            availStock[_stock].higestBidder = msg.sender;
            NewStockBid(_stock, availStock[_stock].amount, _rate, availStock[_stock].powerType, availStock[_stock].contractPeriod, availStock[_stock].biddingTime, uint32(now), availStock[_stock].higestBidder);
        }
        else {
            require(_rate < availStock[_stock].minMaxRate);
            availStock[_stock].minMaxRate = _rate;
            availStock[_stock].higestBidder = msg.sender;
            NewStockBid(_stock, availStock[_stock].amount, _rate, availStock[_stock].powerType, availStock[_stock].contractPeriod, availStock[_stock].biddingTime, uint32(now), availStock[_stock].higestBidder);
        }
    }
}
