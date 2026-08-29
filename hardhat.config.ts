import { defineConfig } from "hardhat/config";
import { tmpTest, sqrtGasTestsStd, sqrtGasTestsDeployment, sqrtGasTestsOther, initTest, newtonIterTest, whileIterTest, halleyIterTest, interpSearchIterTest, binarySearchIterTest, halleyTest } from "./scripts/gas_metrics.js";
import hardhatEthers from "@nomicfoundation/hardhat-ethers";

export default defineConfig({
  plugins: [hardhatEthers],
  tasks: [tmpTest, sqrtGasTestsStd, sqrtGasTestsDeployment, sqrtGasTestsOther, initTest, newtonIterTest, whileIterTest, halleyIterTest, interpSearchIterTest, binarySearchIterTest, halleyTest],
  solidity: {
    version: "0.8.31",
    settings: {
      evmVersion: "osaka",
      optimizer: {
        enabled: true,
        runs: 1000000,
      },
    },
  },
});
