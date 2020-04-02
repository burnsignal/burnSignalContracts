const config = require('./networkConfig.js')
const HDWalletProvider = require("@truffle/hdwallet-provider")

module.exports = {
  networks: {
    development: {
     host: "127.0.0.1",
     port: 8545,
     network_id: "*",
    },
    ropsten: {
      provider: function() {
	return new HDWalletProvider(config.mnemonic, `https://ropsten.infura.io/v3/${config.infuraAPIKey}`)
        },
      network_id: '3'
    },
    rinkeby: {
      provider: function() {
	return new HDWalletProvider(config.mnemonic, `https://rinkeby.infura.io/v3/${config.infuraAPIKey}`)
        },
      network_id: '4'
    },
    mainnet: {
      provider: function() {
	return new HDWalletProvider(config.mnemonic, `https://mainnet.infura.io/v3/${config.infuraAPIKey}`)
        },
      network_id: '1'
    },
  },

  compilers: {
    solc: {
      version: "0.5.16",
      docker: false,
      settings: {
       optimizer: {
         enabled: true,
         runs: 200
       },
       evmVersion: "petersburg"
      }
    }
  }
}
