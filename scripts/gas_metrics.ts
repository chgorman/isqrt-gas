import { task } from "hardhat/config";
import fs from 'fs';
import { parse } from 'csv-parse';

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

    for (let index = 1; index <= 11; index++) {

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
      } else {
        return;
      }

      // Perform sqrt calls
      for await (const x of records) {
        await sqrt.sqrtcall(x, index);
      }

      if (index != 11) {
        console.log("");
      }
    }
  });
