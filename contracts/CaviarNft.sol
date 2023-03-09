// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// import "hardhat/console.sol";
import { ReentrancyGuard } from "./helpers/ReentrancyGuard.sol";

import { ICaviar } from "./caviarInterfaces/ICaviar.sol";
import { IPair } from "./caviarInterfaces/IPair.sol";

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CaviarNft is ERC721, ReentrancyGuard {

    address public collection;
    ICaviar public caviar;
    IPair public pair;
    ERC20 public baseToken;
    ERC20 public lpToken;

    uint256 public maxLPSupply;

    mapping(uint256 => uint256) public tokenType;

    event BaseDeposited(address indexed user, uint256 amount, uint256[] lpTokenIds);
    event BaseRedeemed(address indexed user, uint256[] lpTokenIds);
    event LPDeposited(address indexed user, uint256 amount, uint256[] lpTokenIds);
    event LPRedeemed(address indexed user, uint256[] lpTokenIds);

    constructor(
        address _collection,
        address _caviar,
        address _pair,
        uint256 _maxLPSupply
    ) ERC721(ERC721(_collection).name(), ERC721(_collection).symbol()) {
        collection = _collection;
        caviar = ICaviar(_caviar);
        pair = IPair(_pair);
        baseToken = ERC20(_pair);
        lpToken = ERC20(pair.lpToken());
        maxLPSupply = _maxLPSupply;
    }

    function depositBasic(
        uint256[] calldata _lpTokenIds
    ) external nonReentrant {
        
        uint256 _amount = _lpTokenIds.length * 1e18;
        require(
            baseToken.transferFrom(msg.sender, address(this), _amount)
            , "Transfer failed"
        );
        for(uint256 i = 0; i < _lpTokenIds.length; i++) {
            require(
                !_exists(_lpTokenIds[i])
                , "ID already exists"
            );
            require(
                _lpTokenIds[i] < maxLPSupply
                , "ID too high"
            );
            tokenType[_lpTokenIds[i]] = 1;
            _mint(msg.sender, _lpTokenIds[i]);
        }
        emit BaseDeposited(msg.sender, _amount, _lpTokenIds);
    }

    function redeemBasic(
        uint256[] calldata _lpTokenIds
    ) external nonReentrant {
        uint256 _amount = _lpTokenIds.length * 1e18;
        for(uint256 i = 0; i < _lpTokenIds.length; i++) {
            require(
                ownerOf(_lpTokenIds[i]) == msg.sender
                , "Not your lp token"
            );
            require(
                tokenType[_lpTokenIds[i]] == 1
                , "Not an LP token"
            );
            _burn(_lpTokenIds[i]);
        }
        baseToken.transfer(msg.sender, _amount);
        emit BaseRedeemed(msg.sender, _lpTokenIds);
    }

    function depositLP(
        uint256[] calldata _lpTokenIds
    ) external nonReentrant {
        uint256 _amount = getNFTToToken(_lpTokenIds.length);
        require(
            lpToken.transferFrom(msg.sender, address(this), _amount)
            , "Transfer failed"
        );
        for(uint256 i = 0; i < _lpTokenIds.length; i++) {
            require(
                !_exists(_lpTokenIds[i])
                , "ID already exists"
            );
            require(
                _lpTokenIds[i] < maxLPSupply
                , "ID too high"
            );
            tokenType[_lpTokenIds[i]] = 2;
            _mint(msg.sender, _lpTokenIds[i]);
        }
        emit LPDeposited(msg.sender, _amount, _lpTokenIds);
    }

    function redeemLP(
        uint256[] calldata _lpTokenIds
    ) external nonReentrant {
        uint256 _amount = getNFTToToken(_lpTokenIds.length);
        for(uint256 i = 0; i < _lpTokenIds.length; i++) {
            require(
                ownerOf(_lpTokenIds[i]) == msg.sender
                , "Not your lp token"
            );
            require(
                tokenType[_lpTokenIds[i]] == 2
                , "Not an LP token"
            );
            _burn(_lpTokenIds[i]);
        }
        lpToken.transfer(msg.sender, _amount);
        emit LPRedeemed(msg.sender, _lpTokenIds);
    }

    function getNFTToToken(
        uint256 _amountNft
    ) public view returns(uint256) {
        return _amountNft * 1e18 * lpToken.totalSupply() / pair.fractionalTokenReserves();
    }
}
