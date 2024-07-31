// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

error MoodNft__CantFlipMoodIfNotOwner();
contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdtoUri;
    string private s_happySVGImageUri;
    string private s_sadSVGImageUri; 
    
    enum Mood {
        Happy,
        Sad
    }
    
    mapping(uint256 => Mood) public s_tokenIdtoMood;
    
    constructor(
        string memory happySVGImageUri,
        string memory sadSVGImageUri
    ) ERC721('Mood', 'MN') {
        s_tokenCounter = 0;
        s_happySVGImageUri = happySVGImageUri;
        s_sadSVGImageUri = sadSVGImageUri;
    }

    function mintNft() public {
        s_tokenIdtoMood[s_tokenCounter] = Mood.Happy;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public view  {
         if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdtoMood[tokenId] == Mood.Happy){
            s_tokenIdtoMood[tokenId] == Mood.Sad;
        } else{
            s_tokenIdtoMood[tokenId] == Mood.Happy;
        }
    }

    function _baseURI() internal pure override returns(string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory imageUri;

        if (s_tokenIdtoMood[tokenId] == Mood.Happy) {
            imageUri = s_happySVGImageUri;
        } else {
            imageUri = s_sadSVGImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Mood NFT", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function setMood(uint256 tokenId, Mood mood) public {
        require(_exists(tokenId), "ERC721: Operator query for nonexistent token");
        s_tokenIdtoMood[tokenId] = mood;
    }
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}
