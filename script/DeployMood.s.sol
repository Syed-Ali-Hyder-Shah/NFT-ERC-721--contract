// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Script, console} from "lib/forge-std/src/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";


contract DeployMood is Script {
    
    MoodNft moodNft;

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/Sad.svg");
        string memory HappySvg = vm.readFile("./img/Happy.svg");
        string memory sadSvgUri = svgToImageUri(sadSvg);
        string memory happySvgUri = svgToImageUri(HappySvg);
        console.log("Sad SVG URI:", sadSvgUri);
        console.log("Happy SVG URI:", happySvgUri);
        
        vm.startBroadcast();
        moodNft = new MoodNft(svgToImageUri(happySvgUri), 
        svgToImageUri(sadSvgUri));
        vm.stopBroadcast();
        
        return moodNft;
    }

    function svgToImageUri(string memory svg) public pure returns(string memory){
        string memory baseUrl = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string.concat(baseUrl, svgBase64Encoded);
    }

}
