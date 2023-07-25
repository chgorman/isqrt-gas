import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "./scripts/gas_metrics";

const config: HardhatUserConfig = {
  solidity: {
      compilers: [
        {
          version: "0.8.16",
          settings: {
            optimizer: {
              enabled: true,
              runs: 1000000,
            },
          },
        },
      ],
    },
};

export default config;
