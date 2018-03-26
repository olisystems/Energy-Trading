module.exports = {
networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
	  gas: 4612388
    },
    youki: {
	  host: "127.0.0.1",
	  port: 8545,
	  network_id: "*",
	  gas: 4612388
    },
	olichain: {
		host: "127.0.0.1",
		port:8545,
		network_id: "*",
		gas: 4612388
	}
  }
};
