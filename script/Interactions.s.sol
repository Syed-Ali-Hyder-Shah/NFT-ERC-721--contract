// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {NFT} from "src/NFT.sol";
import {DeployNFT} from "script/DeployNFT.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract Interactions is Script {
    NFT private nft;
    string public constant tokenUri_PUG = 
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("NFT", block.chainid);
        
        mintNftOnContract(mostRecentDeployed);
        string memory tokenUri = checkTokenUri(mostRecentDeployed, 0); // Checking the URI for tokenId 0

        if (keccak256(abi.encodePacked(tokenUri)) != keccak256(abi.encodePacked(tokenUri_PUG))) {
            revert("Token URI does not match expected value");
        }
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        NFT(contractAddress).mintNft(tokenUri_PUG);
        vm.stopBroadcast();
    }

    function checkTokenUri(address contractAddress, uint256 tokenId) public view returns (string memory) {
        return NFT(contractAddress).tokenURI(tokenId);
    }
}
