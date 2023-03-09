// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IPair {

    function nft() external view returns(address);

    function merkleRoot() external view returns(bytes32);

    function lpToken() external view returns(address);

    function fractionalTokenReserves() external view returns(uint256);
}
