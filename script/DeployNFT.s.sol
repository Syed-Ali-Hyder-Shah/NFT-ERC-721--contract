// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {NFT} from "src/NFT.sol";

contract DeployNFT is Script{
    
    NFT nft;
    
    function run() external returns (NFT){
        vm.startBroadcast();
        nft = new NFT();
        vm.stopBroadcast();

        return nft;
    }
}
