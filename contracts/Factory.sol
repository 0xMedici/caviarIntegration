// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import { ReentrancyGuard } from "./helpers/ReentrancyGuard.sol";

import { ICaviar } from "./caviarInterfaces/ICaviar.sol";
import { IPair } from "./caviarInterfaces/IPair.sol";
import { CaviarNft } from "./CaviarNft.sol";

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Factory {

    address public admin;
    address public caviar;

    mapping(address => bool) public whitelistedCreators;
    mapping(address => mapping(address => address)) public caviarNFTs;

    event CaviarNFTCreated(address caviarNFT, address currencyPair);

    constructor(
        address _admin,
        address _caviar
    ) {
        admin = _admin;
        caviar = _caviar;
    }

    function whitelistCreator(address[] calldata _user) external {
        require(msg.sender == admin, "Not admin");
        for(uint256 i = 0; i < _user.length; i++) {
            whitelistedCreators[_user[i]] = true;
        }
    }

    function createCaviarNFT(
        address _collection,
        address _currencyPair,
        address _pair,
        uint256 _maxLPTokens
    ) external {
        require(
            caviarNFTs[_collection][_currencyPair] == address(0)
            , "Wrapper already created for pair"
        );
        require(
            whitelistedCreators[msg.sender]
            , "Not whitelisted"
        );
        require(
            ICaviar(caviar).pairs(
                _collection,
                _currencyPair,
                IPair(_pair).merkleRoot()
            ) == _pair
            , "Pair not found"
        );
        require(
            IPair(_pair).nft() == _collection
            , "Incorrect auction input"
        );
        CaviarNft caviarNft = new CaviarNft(
            _collection,
            caviar,
            _pair,
            _maxLPTokens
        );
        caviarNFTs[_collection][_currencyPair] = address(caviarNft);

        emit CaviarNFTCreated(
            address(caviarNft),
            _currencyPair
        );
    }
}