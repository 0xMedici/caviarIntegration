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
    factory = await Factory.attach("0x3a6b609575e438ab3C87262CBb227d6DB5F2f94b");
    console.log("Factory:", factory.address);

    CaviarNft = await ethers.getContractFactory("CaviarNft");
    caviar = await CaviarNft.attach("0x04450E9b684AE36f3fa2a72579d0498E6d447f5E");
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

    //WL Creator
    // const wlCreator = await factory.whitelistCreator(
    //     [deployer.address]
    // );
    // wlCreator.wait();

    //Create caviarNFT
    // const createNFT = await factory.createCaviarNFT(
    //     '0xC1A308D95344716054d4C078831376FC78c4fd72'
    //     , constants.AddressZero
    //     , '0x39ca12FF27A6276Bb23131803b67Ca0336843643'
    //     , 10000
    // ); 
    // createNFT.wait();
    // console.log("Caviar NFT created!");
    // console.log(
    //     "Caviar NFT:", 
    //     await factory.caviarNFTs(
    //         '0xC1A308D95344716054d4C078831376FC78c4fd72'
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
    // const redeemLP = await caviar.redeemLP(
    //     [1]
    // );
    // redeemLP.wait();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
    console.error(error);
    process.exit(1);
    });

