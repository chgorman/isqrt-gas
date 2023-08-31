import { task } from "hardhat/config";
import fs from 'fs';
import { parse } from 'csv-parse';
import { kMaxLength } from "buffer";

task("sqrt-gas-tests", "Print Sqrt Gas Tests")
  .setAction(async (taskArgs, hre) => {
    
    // Open file to process arguments
    const processFile = async () => {
      const records = [];
      const parser = fs
        .createReadStream('scripts/data_points.csv')
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

    const sqrt = await (await hre.ethers.getContractFactory("SqrtTests")).deploy();
    await sqrt.deployed();

    for (let index = 1; index <= 16; index++) {

      if (index == 1) {
        console.log("UniswapV2");
      } else if (index == 2) {
        console.log("PRB");
      } else if (index == 3) {
        console.log("OpenZeppelin");
      } else if (index == 4) {
        console.log("ABDK");
      } else if (index == 5) {
        console.log("Python");
      } else if (index == 6) {
        console.log("Unrolled1");
      } else if (index == 7) {
        console.log("Unrolled2");
      } else if (index == 8) {
        console.log("Unrolled3");
      } else if (index == 9) {
        console.log("While1");
      } else if (index == 10) {
        console.log("While2");
      } else if (index == 11) {
        console.log("While3");
      } else if (index == 12) {
        console.log("Linear");
      } else if (index == 13) {
        console.log("BitLength");
      } else if (index == 14) {
        console.log("Hyper4");
      } else if (index == 15) {
        console.log("Lookup4");
      } else if (index == 16) {
        console.log("Lookup8");
      } else if (index == 17) {
        console.log("Unrolled3v2");
      } else {
        return;
      }

      // Perform sqrt calls
      for await (const x of records) {
        await sqrt.sqrtcall(x, index);
      }

      if (index != 17) {
        console.log("");
      }
    }
  });

task("init-test", "Initialization Gas Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("SqrtTests")).deploy();
    await sqrt.deployed();

    let x = BigInt(2)**BigInt(255);

    for (let idx = 1; idx <= 4; idx++) {

      if (idx == 1) {
        console.log("Init1");
      } else if (idx == 2) {
        console.log("Init2");
      } else if (idx == 3) {
        console.log("Init3");
      } else if (idx == 4) {
        console.log("Init4");
      } else {
        return;
      }

      // Perform init call
      await sqrt.initcall(x, idx);

      if (idx != 4) {
        console.log("");
      }
    }
  });

task("newton-test", "Cost-per-Newton Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("SqrtTests")).deploy();
    await sqrt.deployed();

    let x = BigInt(2)**BigInt(255);

    for (let idx = 1; idx <= 7; idx++) {

      if (idx == 1) {
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
      } else if (idx == 7) {
        console.log("Newton7");
      } else {
        return;
      }

      // Perform newton call
      await sqrt.newtoncall(x, idx);

      if (idx != 7) {
        console.log("");
      }
    }
  });

task("return-test", "Return Logic Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("SqrtTests")).deploy();
    await sqrt.deployed();

    let x = BigInt(2)**BigInt(255);

    for (let idx = 1; idx <= 2; idx++) {

      if (idx == 1) {
        console.log("Return1");
      } else if (idx == 2) {
        console.log("Return2");
      } else {
        return;
      }

      // Perform newton call
      await sqrt.returncall(x, idx);

      if (idx != 2) {
        console.log("");
      }
    }
  });

