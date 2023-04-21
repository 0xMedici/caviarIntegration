const { constants } = require("ethers");
const { ethers } = require("hardhat");
// const { expect } = require("chai");
// const {MerkleTree} = require("merkletreejs");
// const keccak256 = require("keccak256");
// const { concat } = require("ethers/lib/utils");
// const { constants } = require("ethers");

async function main() {

    const [deployer] = await ethers.getSigners();
    provider = ethers.getDefaultProvider(5);

    Factory = await ethers.getContractFactory("Factory");
    // factory = await Factory.deploy(
    //     deployer.address,
    //     "0x15B9D8ba57E67D6683f3E7Bec24A32b98a7cdb6b"
    // );
    factory = await Factory.attach("0x9B682CBC9FD6E9053197b9aA53c0B36E18A4ad1E");
    console.log("Factory:", factory.address);

    CaviarNft = await ethers.getContractFactory("CaviarNft");
    caviar = await CaviarNft.attach("0x44E40251092f248d067990699Da4099c92d06eF1");
    console.log("Caviar NFT:", caviar.address);

    //Get user balance
    ERC20 = await ethers.getContractFactory("ERC20");
    basic = await ERC20.attach(await caviar.baseToken());
    lp = await ERC20.attach(await caviar.lpToken());
    console.log("Base:", basic.address);
    console.log("LP:", lp.address);
    console.log("USER LP BAL:", await lp.balanceOf(deployer.address));
    console.log("USER BASIC BAL:", await basic.balanceOf(deployer.address));
    console.log("CAVIAR NFT BAL:", await basic.balanceOf(caviar.address));

    // await basic.transfer("0xE6dC2c1a17b093F4f236Fe8545aCb9D5Ad94334a", "1000000000000000000");
    // await lp.transfer("0xE6dC2c1a17b093F4f236Fe8545aCb9D5Ad94334a", (49395533091656085 * 5).toString());

    //WL Creator
    // const wlCreator = await factory.whitelistCreator(
    //     [
    //         deployer.address
    //         , "0xE6dC2c1a17b093F4f236Fe8545aCb9D5Ad94334a"
    //     ]
    // );
    // wlCreator.wait();
    // console.log("Whitelist complete");

    //Create caviarNFT
    // const createNFT = await factory.createCaviarNFT(
    //     '0x8971718bca2b7fc86649b84601b17b634ecbdf19'
    //     , constants.AddressZero
    //     , '0x6a265bFBCf45A5885f48b644B3Ab4E6c3260fFC3'
    //     , 10000
    // ); 
    // createNFT.wait();
    // console.log("Caviar NFT created!");
    // console.log(
    //     "Caviar NFT:", 
    //     await factory.caviarNFTs(
    //         '0x8971718bca2b7fc86649b84601b17b634ecbdf19'
    //         , constants.AddressZero
    //     )
    // );

    //Deposit basic
    // const approveBasic = await basic.approve(caviar.address, (2e18).toString());
    // approveBasic.wait();
    // const depositBasic = await caviar.depositBasic(
    //     [1]
    // );
    // depositBasic.wait();

    //Redeeem basic
    // const redeemBasic = await caviar.redeemBasic(
    //     [1]
    // );
    // redeemBasic.wait();

    //Deposit LP
    // const approveCaviar = await lp.approve(caviar.address, (2e18).toString());
    // approveCaviar.wait();
    // const depositLP = await caviar.depositLP(
    //     [1]
    // );
    // depositLP.wait();

    //Redeem LP 
    // const redeemLP = await caviar.connect(impersonatedSigner).redeemLP(
    //     [18]
    // );
    // redeemLP.wait();

    //Get NFT to Token
    // console.log((await caviar.getNFTToToken(1)).toString());
    // console.log((await lp.balanceOf(caviar.address)).toString());
    // console.log((await lp.balanceOf(deployer.address) / (await caviar.getNFTToToken(1)).toString()));

    //Get Token to NFT
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exit(1);
    });

