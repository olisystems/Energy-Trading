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
		gas: 4612388,
		from: '0x36e4182c362e1f6c0e517b3c6e77500ddcee082e'
	},
	toba: {
		host: "127.0.0.1",
		port:8545,
		network_id: "*",
		gas: 4612388
	}
  }
};
