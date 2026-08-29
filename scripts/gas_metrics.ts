import { task } from "hardhat/config";
import fs from 'fs';
import { parse } from 'csv-parse';

export const sqrtGasTestsStd = task("sqrt-gas-tests-std", "Print Sqrt Gas Tests (standard)")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {

      // Open file to process arguments
      const processFile = async () => {
        const records = [];
        const parser = fs
        .createReadStream('scripts/data_points.csv') // tag:std_tests
          .pipe(parse({
          // CSV options if any
          }));
        for await (const record of parser) {
          // Work with each record
          records.push(record[0]);
        }
        return records;
      };

      // Process algorithm
      const processAlgorithm = async (sqrt: any, records: any) => {
        // Perform sqrt calls
        for await (const x of records) {
          await sqrt.sqrtcall(x);
        }
      };

      const records = await processFile();

      const { ethers } = await hre.network.create();
      const sqrt_uniswap_v2 = await (await ethers.getContractFactory("SqrtUniswapV2")).deploy()
      await sqrt_uniswap_v2.waitForDeployment();
      const sqrt_prb = await (await ethers.getContractFactory("SqrtPRB")).deploy();
      await sqrt_prb.waitForDeployment();
      const sqrt_prb_v2 = await (await ethers.getContractFactory("SqrtPRBv2")).deploy();
      await sqrt_prb_v2.waitForDeployment();
      const sqrt_oz = await (await ethers.getContractFactory("SqrtOpenZeppelin")).deploy();
      await sqrt_oz.waitForDeployment();
      const sqrt_abdk = await (await ethers.getContractFactory("SqrtABDK")).deploy();
      await sqrt_abdk.waitForDeployment();
      const sqrt_oz_v2 = await (await ethers.getContractFactory("SqrtOpenZeppelinV2")).deploy();
      await sqrt_oz_v2.waitForDeployment();
      const sqrt_unrolled1 = await (await ethers.getContractFactory("SqrtUnrolled1")).deploy();
      await sqrt_unrolled1.waitForDeployment();
      const sqrt_unrolled2 = await (await ethers.getContractFactory("SqrtUnrolled2")).deploy();
      await sqrt_unrolled2.waitForDeployment();
      const sqrt_unrolled3 = await (await ethers.getContractFactory("SqrtUnrolled3")).deploy();
      await sqrt_unrolled3.waitForDeployment();
      const sqrt_while1 = await (await ethers.getContractFactory("SqrtWhile1")).deploy();
      await sqrt_while1.waitForDeployment();
      const sqrt_while2 = await (await ethers.getContractFactory("SqrtWhile2")).deploy();
      await sqrt_while2.waitForDeployment();
      const sqrt_while3 = await (await ethers.getContractFactory("SqrtWhile3")).deploy();
      await sqrt_while3.waitForDeployment();
      const sqrt_linear = await (await ethers.getContractFactory("SqrtLinear")).deploy();
      await sqrt_linear.waitForDeployment();
      const sqrt_bitlength = await (await ethers.getContractFactory("SqrtBitLength")).deploy();
      await sqrt_bitlength.waitForDeployment();
      const sqrt_hyper4 = await (await ethers.getContractFactory("SqrtHyper4")).deploy();
      await sqrt_hyper4.waitForDeployment();
      const sqrt_lookup4 = await (await ethers.getContractFactory("SqrtLookup4")).deploy();
      await sqrt_lookup4.waitForDeployment();
      const sqrt_lookup8 = await (await ethers.getContractFactory("SqrtLookup8")).deploy();
      await sqrt_lookup8.waitForDeployment();

    for (let index = 0; index <= 16; index++) {

        if (index == 0) {
          console.log("UniswapV2");
          await processAlgorithm(sqrt_uniswap_v2, records);
        } else if (index == 1) {
          console.log("PRB");
          await processAlgorithm(sqrt_prb, records);
        } else if (index == 2) {
          console.log("PRBv2");
          await processAlgorithm(sqrt_prb_v2, records);
        } else if (index == 3) {
          console.log("OpenZeppelin");
          await processAlgorithm(sqrt_oz, records);
        } else if (index == 4) {
          console.log("ABDK");
          await processAlgorithm(sqrt_abdk, records);
        } else if (index == 5) {
          console.log("OpenZeppelinV2");
          await processAlgorithm(sqrt_oz_v2, records);
        } else if (index == 6) {
          console.log("Unrolled1");
          await processAlgorithm(sqrt_unrolled1, records);
        } else if (index == 7) {
          console.log("Unrolled2");
          await processAlgorithm(sqrt_unrolled2, records);
        } else if (index == 8) {
          console.log("Unrolled3");
          await processAlgorithm(sqrt_unrolled3, records);
        } else if (index == 9) {
          console.log("While1");
          await processAlgorithm(sqrt_while1, records);
        } else if (index == 10) {
          console.log("While2");
          await processAlgorithm(sqrt_while2, records);
        } else if (index == 11) {
          console.log("While3");
          await processAlgorithm(sqrt_while3, records);
        } else if (index == 12) {
          console.log("Linear");
          await processAlgorithm(sqrt_linear, records);
        } else if (index == 13) {
          console.log("BitLength");
          await processAlgorithm(sqrt_bitlength, records);
        } else if (index == 14) {
          console.log("Hyper4");
          await processAlgorithm(sqrt_hyper4, records);
        } else if (index == 15) {
          console.log("Lookup4");
          await processAlgorithm(sqrt_lookup4, records);
        } else if (index == 16) {
          console.log("Lookup8");
          await processAlgorithm(sqrt_lookup8, records);
        } else {
          return;
        }

        if (index != 16) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const sqrtGasTestsDeployment = task("sqrt-gas-tests-deployment", "Print Sqrt Gas Tests related to deployment")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {

      const { ethers } = await hre.network.create();
      const signer = (await ethers.getSigners())[0];

      // Get gas cost for empty contract
      const emptyFactory = await ethers.getContractFactory("Empty");
      const emptyContract = await emptyFactory.deploy();
      const emptyDeployTx = emptyContract.deploymentTransaction();
      const emptyReceipt = await emptyDeployTx.wait();
      const emptyGasUsed = emptyReceipt.gasUsed;
      console.log("Empty");
      console.log(emptyGasUsed.toString());
      console.log("");

      // get array for smart contract names
      let sqrt_array: string[] = ["UniswapV2",
                                  "PRB",
                                  "PRBv2",
                                  "OpenZeppelin",
                                  "ABDK",
                                  "OpenZeppelinV2",
                                  "Unrolled1",
                                  "Unrolled2",
                                  "Unrolled3",
                                  "While1",
                                  "While2",
                                  "While3",
                                  "BitLength",
                                  "Linear",
                                  "Hyper4",
                                  "Lookup4",
                                  "Lookup8"];

      // deploy contracts and print gas costs
      for await (const c of sqrt_array) {
        console.log(c);
        // Get gas cost for empty contract
        const sqrtFactory = await ethers.getContractFactory("Sqrt" + c);
        const sqrtContract = await sqrtFactory.deploy();
        const sqrtDeployTx = sqrtContract.deploymentTransaction();
        const sqrtReceipt = await sqrtDeployTx.wait();
        const sqrtGasUsed = sqrtReceipt.gasUsed;
        console.log(sqrtGasUsed.toString());
        const gasDiff = sqrtGasUsed - emptyGasUsed;
        console.log(gasDiff.toString());
        console.log("");
      }
    }
  }))
  .build();

export const sqrtGasTestsOther = task("sqrt-gas-tests-other", "Print Sqrt Gas Tests (other)")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      
      // Open file to process arguments
      const processFile = async () => {
        const records = [];
        const parser = fs
          .createReadStream('scripts/data_points.csv') // tag:other_tests
          .pipe(parse({
          // CSV options if any
          }));
        for await (const record of parser) {
          // Work with each record
          records.push(record[0]);
        }
        return records;
      };

      const records = await processFile();

      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("SqrtTestsOther")).deploy();
      await sqrt.waitForDeployment();

      for (let idx = 1; idx <= 4; idx++) {
        if (idx == 1) {
          console.log("BinarySearch");
        } else if (idx == 2) {
          console.log("InterpSearch");
        } else if (idx == 3) {
          console.log("Hardware");
        } else if (idx == 4) {
          console.log("Python");
        } else {
          return;
        }

        // Perform sqrt calls
        for await (const x of records) {
          await sqrt.sqrtcall(x, idx);
        }

        if (idx != 4) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const initTest = task("init-test", "Initialization Gas Test")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("MiscTests")).deploy();
      await sqrt.waitForDeployment();

      let x = BigInt(2)**BigInt(255);

      for (let idx = 1; idx <= 8; idx++) {
        if (idx == 1) {
          console.log("Newton1-asm");
        } else if (idx == 2) {
          console.log("Newton2-asm");
        } else if (idx == 3) {
          console.log("Newton3-asm");
        } else if (idx == 4) {
          console.log("BitLength-asm");
        } else if (idx == 5) {
          console.log("Linear-asm");
        } else if (idx == 6) {
          console.log("Hyper4-asm");
        } else if (idx == 7) {
          console.log("Lookup4-asm");
        } else if (idx == 8) {
          console.log("Lookup8-asm");
        } else {
          return;
        }

        // Perform init call
        await sqrt.initcall(x, idx);

        if (idx != 8) {
          console.log("");
        }
      }
  }
}))
.build();

export const newtonIterTest = task("newton-iter-test", "Cost-per-Newton Test")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("MiscTests")).deploy();
      await sqrt.waitForDeployment();

      let x = BigInt(3)*BigInt(2)**BigInt(160);

      for (let idx = 0; idx <= 6; idx++) {
        if (idx == 0) {
          console.log("Newton0");
        } else if (idx == 1) {
          console.log("Newton1");
        } else if (idx == 2) {
          console.log("Newton2");
        } else if (idx == 3) {
          console.log("Newton3");
        } else if (idx == 4) {
          console.log("Newton4");
        } else if (idx == 5) {
          console.log("Newton5");
        } else if (idx == 6) {
          console.log("Newton6");
        } else {
          return;
        }

        // Perform newton call
        await sqrt.newtoncall(x, idx);

        if (idx != 6) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const whileIterTest = task("while-iter-test", "Cost-per-While Test")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("MiscTests")).deploy();
      await sqrt.waitForDeployment();

      let x_array = [
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(128),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(224),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(240),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(248),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(252),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(254)
      ];

      for (let idx = 0; idx < 6; idx++) {
        let x = x_array[idx]

        // Perform newton call
        await sqrt.whilecall(x);

        if (idx != 6) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const halleyIterTest = task("halley-iter-test", "Cost-per-Halley Test")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("MiscTests")).deploy();
      await sqrt.waitForDeployment();

      let x = BigInt(3)*BigInt(2)**BigInt(160);

      for (let idx = 0; idx <= 4; idx++) {
        if (idx == 0) {
          console.log("Halley0");
        } else if (idx == 1) {
          console.log("Halley1");
        } else if (idx == 2) {
          console.log("Halley2");
        } else if (idx == 3) {
          console.log("Halley3");
        } else if (idx == 4) {
          console.log("Halley4");
        } else {
          return;
        }

        // Perform Halley call
        await sqrt.halleycall(x, idx);

        if (idx != 4) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const interpSearchIterTest = task("interp-search-iter-test", "Cost-per-Loop Interpolation Search")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("SqrtTestsOther")).deploy();
      await sqrt.waitForDeployment();

      let x_array = [
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(128),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(180),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(196),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(224),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(230),
        BigInt(2)**BigInt(256) - BigInt(2)**BigInt(236)
      ];

      for (let idx = 0; idx < 6; idx++) {
        let x = x_array[idx]

        // Perform newton call
        await sqrt.sqrt_interp_search_call(x);

        if (idx != 6) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const binarySearchIterTest = task("binary-search-iter-test", "Cost-per-Loop Binary Search")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrtOther = await (await ethers.getContractFactory("SqrtTestsOther")).deploy();
      await sqrtOther.waitForDeployment();
      const sqrtMisc = await (await ethers.getContractFactory("MiscTests")).deploy();
      await sqrtMisc.waitForDeployment();

      let x_array = [
        BigInt(2)**BigInt(3),
        BigInt(2)**BigInt(5),
        BigInt(2)**BigInt(7),
        BigInt(2)**BigInt(9),
        BigInt(2)**BigInt(13),
        BigInt(2)**BigInt(15),
      ];

      for (let idx = 0; idx < x_array.length; idx++) {
        let x = x_array[idx]

        // Perform sqrt call
        console.log("Total Gas");
        await sqrtOther.sqrt_binary_search_call(x);
        console.log("Init Gas");
        await sqrtMisc.initcall(x, 1);

        if (idx != x_array.length-1) {
          console.log("");
        }
      }
    }
  }))
  .build();

export const halleyTest = task("halley-test", "Halley's Method Gas Test")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt1 = await (await ethers.getContractFactory("SqrtTestsOther")).deploy();
      const sqrt2 = await (await ethers.getContractFactory("SqrtUnrolled3")).deploy();
      await sqrt1.waitForDeployment();
      await sqrt2.waitForDeployment();

      let x = BigInt(3)*BigInt(2)**BigInt(160);

      console.log("Halley's Method");
      await sqrt1.halleycall(x);
      console.log("");
      console.log("Unrolled3");
      await sqrt2.sqrtcall(x);
    }
  }))
  .build();

export const tmpTest = task("tmp-test", "Test for Testing")
  .setAction(async () => ({
    default: async (taskArgs: any, hre: any) => {
      const { ethers } = await hre.network.create();
      const sqrt = await (await ethers.getContractFactory("SqrtTestsOther")).deploy();
      await sqrt.waitForDeployment();

      let x = BigInt(2)**BigInt(254);

      console.log("Test for Testing");
      await sqrt.sqrt_test(x);
      console.log("");
    }
  }))
  .build();
