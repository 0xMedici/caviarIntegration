// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface ICaviar {
    function pairs(
        address _nft,
        address _baseToken,
        bytes32 _merkleRoot
    ) external view returns (address);
}
