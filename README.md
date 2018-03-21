# A few words about blockchain based P2P Energy Trading

There are basically two different approaches to "P2P" Energy Trading that are currently being explored. Both show big differences in their technical implementations and their influence on the actual backend of the energy-sector.

The term "P2P" can be very confusing in this context, as it directly implies the direct energy trading from household to household. In a broader sense though, its meaning is closer to the fact, that blockchain can enable "peers" to make autonomous decisions on their energy consumption and production. As a result, a peer is what energy suppliers and grid operators have called "Letztverbraucher" in Germany: end-consumer.

##So what are the thought-processes behind P2P Energy Trading? 

###Direct Energy Trading between peers:
	- Contract Based (IF/THEN): If Peer_A (a Prosumer) has a surplus of energy because he is producing energy during timeframe i, Peer_B will not consume energy from its usual energy supplier but from Peer_A. The price per kWh can be preset or both peers can set a price mechanism for the calculation.
	- Value-Based Trading (Energy-Signature based): Peer_A (or better: his autonomous agent) can make decisions on his own where to buy energy from in timeframe a. For that, every kWh that he produces (or will produce) needs to have its own signature with attributes like time, location and quality (green/fossil). Signatures can then be tokenized and traded on different markets and sold in conventional OTC-trades to other market participants.

###Local Markets for Peers:
	
	- Distributed, local Aggregation Market (Market-Clearing-Price based): A local aggregation market sums up all bids for timeframe i from peers in a fixed area (Street, Village, Town, City, State). Supply and Demand bids are being aggregated and formed into two functions that intersect at price p and at volume v. This price mechanism is well known from the traditional Day-Ahead Market, but is in this case calculated way closer to the actual delivery of energy and also with a higher resolution of about 5 minutes.
	- Distributed, local Aggregation Market (Other Price Mechanisms): There is a variety of other price mechanisms that are currently being explored and tested.

#OLI Aggregation Market

This market has been programmed and developed by Muhammad Faizan during his Master Thesis at OLI Systems in late 2017 with input from Thomas Brenner, Ole Langniß and Felix Förster. It follows the idea of the MCP-based local Aggregation Market with its very own local Merit-Order. Basically everything in this market is decentralized. Everything is being done by Smart Contracts. From registration, bidding to the actual calculation: all these steps are included in the structure of Smart Contracts.

More Documentation to follow.

15/03/2018