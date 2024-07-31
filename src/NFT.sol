// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721{

uint256 private s_tokenCounter;
mapping(uint256 => string) private s_tokenIdtoUri;

constructor() ERC721('Earl', 'EARL') {
    s_tokenCounter = 0;
}

function mintNft (string memory tokenUri) public {
s_tokenIdtoUri[s_tokenCounter] = tokenUri;
_safeMint(msg.sender, s_tokenCounter);
s_tokenCounter++;
}

function tokenURI (uint256 tokenId) public view override returns 
(string memory){
    return s_tokenIdtoUri[tokenId] ;
}

}