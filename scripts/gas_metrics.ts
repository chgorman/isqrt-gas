import { task } from "hardhat/config";
import fs from 'fs';
import { parse } from 'csv-parse';

task("sqrt-gas-tests-std", "Print Sqrt Gas Tests (standard)")
  .setAction(async (taskArgs, hre) => {

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

    const sqrt_uniswap_v2 = await (await hre.ethers.getContractFactory("SqrtUniswapV2")).deploy()
    await sqrt_uniswap_v2.deployed();
    const sqrt_prb = await (await hre.ethers.getContractFactory("SqrtPRB")).deploy();
    await sqrt_prb.deployed();
    const sqrt_oz = await (await hre.ethers.getContractFactory("SqrtOpenZeppelin")).deploy();
    await sqrt_oz.deployed();
    const sqrt_abdk = await (await hre.ethers.getContractFactory("SqrtABDK")).deploy();
    await sqrt_abdk.deployed();
    const sqrt_oz_v2 = await (await hre.ethers.getContractFactory("SqrtOpenZeppelinV2")).deploy();
    await sqrt_oz_v2.deployed();
    const sqrt_unrolled1 = await (await hre.ethers.getContractFactory("SqrtUnrolled1")).deploy();
    await sqrt_unrolled1.deployed();
    const sqrt_unrolled2 = await (await hre.ethers.getContractFactory("SqrtUnrolled2")).deploy();
    await sqrt_unrolled2.deployed();
    const sqrt_unrolled3 = await (await hre.ethers.getContractFactory("SqrtUnrolled3")).deploy();
    await sqrt_unrolled3.deployed();
    const sqrt_while1 = await (await hre.ethers.getContractFactory("SqrtWhile1")).deploy();
    await sqrt_while1.deployed();
    const sqrt_while2 = await (await hre.ethers.getContractFactory("SqrtWhile2")).deploy();
    await sqrt_while2.deployed();
    const sqrt_while3 = await (await hre.ethers.getContractFactory("SqrtWhile3")).deploy();
    await sqrt_while3.deployed();
    const sqrt_linear = await (await hre.ethers.getContractFactory("SqrtLinear")).deploy();
    await sqrt_linear.deployed();
    const sqrt_bitlength = await (await hre.ethers.getContractFactory("SqrtBitLength")).deploy();
    await sqrt_bitlength.deployed();
    const sqrt_hyper4 = await (await hre.ethers.getContractFactory("SqrtHyper4")).deploy();
    await sqrt_hyper4.deployed();
    const sqrt_lookup4 = await (await hre.ethers.getContractFactory("SqrtLookup4")).deploy();
    await sqrt_lookup4.deployed();
    const sqrt_lookup8 = await (await hre.ethers.getContractFactory("SqrtLookup8")).deploy();
    await sqrt_lookup8.deployed();

    for (let index = 1; index <= 16; index++) {

      if (index == 1) {
        console.log("UniswapV2");
        await processAlgorithm(sqrt_uniswap_v2, records);
      } else if (index == 2) {
        console.log("PRB");
        await processAlgorithm(sqrt_prb, records);
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
  });

task("sqrt-gas-tests-deployment", "Print Sqrt Gas Tests related to deployment")
  .setAction(async (taskArgs, hre) => {

    const signer = (await hre.ethers.getSigners())[0];

    // Get gas cost of empty smart contract
    const balanceBefore = await hre.ethers.provider.getBalance(await signer.getAddress());
    const empty = await (await hre.ethers.getContractFactory("Empty")).deploy()
    await empty.deployed();
    const gasPrice = empty.deployTransaction.gasPrice!;
    const balanceAfter = await hre.ethers.provider.getBalance(await signer.getAddress());
    const diff = balanceBefore.sub(balanceAfter);
    console.log("Empty");
    const res_empty = diff.div(gasPrice).toNumber();
    console.log(res_empty);
    console.log("");

    // get array for smart contract names
    let sqrt_array: string[] = ["UniswapV2",
                                "PRB",
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
      const balanceBefore = await hre.ethers.provider.getBalance(await signer.getAddress());
      const sqrt_contract = await (await hre.ethers.getContractFactory("Sqrt" + c)).deploy()
      await sqrt_contract.deployed();
      const gasPrice = sqrt_contract.deployTransaction.gasPrice!;
      const balanceAfter = await hre.ethers.provider.getBalance(await signer.getAddress());
      const diff = balanceBefore.sub(balanceAfter);
      console.log(c);
      const res = diff.div(gasPrice).toNumber();
      console.log(res);
      console.log(res - res_empty);
      console.log("");
    }
  });

task("sqrt-gas-tests-other", "Print Sqrt Gas Tests (other)")
  .setAction(async (taskArgs, hre) => {
    
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

    const sqrt = await (await hre.ethers.getContractFactory("SqrtTestsOther")).deploy();
    await sqrt.deployed();

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
  });

task("init-test", "Initialization Gas Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("MiscTests")).deploy();
    await sqrt.deployed();

    let x = BigInt(2)**BigInt(255);

    for (let idx = 1; idx <= 11; idx++) {
      if (idx == 1) {
        console.log("Newton1-Init");
      } else if (idx == 2) {
        console.log("Newton2-Init");
      } else if (idx == 3) {
        console.log("Newton3-Init");
      } else if (idx == 4) {
        console.log("Newton1-Init-v2");
      } else if (idx == 5) {
        console.log("Newton2-Init-v2");
      } else if (idx == 6) {
        console.log("Newton3-Init-v2");
      } else if (idx == 7) {
        console.log("BitLength-Init");
      } else if (idx == 8) {
        console.log("Linear-Init");
      } else if (idx == 9) {
        console.log("Hyper4-Init");
      } else if (idx == 10) {
        console.log("Lookup4-Init");
      } else if (idx == 11) {
        console.log("Lookup8-Init");
      } else {
        return;
      }

      // Perform init call
      await sqrt.initcall(x, idx);

      if (idx != 11) {
        console.log("");
      }
    }
  });

task("newton-iter-test", "Cost-per-Newton Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("MiscTests")).deploy();
    await sqrt.deployed();

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
  });

task("while-iter-test", "Cost-per-While Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("MiscTests")).deploy();
    await sqrt.deployed();

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
  });

task("halley-iter-test", "Cost-per-Halley Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("MiscTests")).deploy();
    await sqrt.deployed();

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
  });

task("interp-search-iter-test", "Cost-per-Loop Interpolation Search")
  .setAction(async (taskArgs, hre) => {
    const sqrt = await (await hre.ethers.getContractFactory("SqrtTestsOther")).deploy();
    await sqrt.deployed();

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
  });

task("binary-search-iter-test", "Cost-per-Loop Binary Search")
  .setAction(async (taskArgs, hre) => {
    const sqrtOther = await (await hre.ethers.getContractFactory("SqrtTestsOther")).deploy();
    await sqrtOther.deployed();
    const sqrtMisc = await (await hre.ethers.getContractFactory("MiscTests")).deploy();
    await sqrtMisc.deployed();

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
  });

task("halley-test", "Halley's Method Gas Test")
  .setAction(async (taskArgs, hre) => {
    const sqrt1 = await (await hre.ethers.getContractFactory("SqrtTestsOther")).deploy();
    const sqrt2 = await (await hre.ethers.getContractFactory("SqrtUnrolled3")).deploy();
    await sqrt1.deployed();
    await sqrt2.deployed();

    let x = BigInt(3)*BigInt(2)**BigInt(160);

    console.log("Halley's Method");
    await sqrt1.halleycall(x);
    console.log("");
    console.log("Unrolled3");
    await sqrt2.sqrtcall(x);
  });