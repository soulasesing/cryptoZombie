module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    dashboard: {},
    loc_developer_developer: {
      network_id: "*",
      port: 3002,
      host: "127.0.0.1"
    },
    loc_development_development: {
      network_id: "*",
      port: 3001,
      host: "127.0.0.1"
    }
  },
  compilers: {
    solc: {
      version: "0.8.13"
    }
  },
  db: {
    enabled: false,
    host: "127.0.0.1"
  }
};
