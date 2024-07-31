// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Vm} from "lib/forge-std/src/Vm.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMood} from "script/DeployMood.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMood deployer;
    address public USER = makeAddr("user");
    string public constant HAPPY_SVG_IMG_URI = 'data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==';
    string public constant SAD_SVG_IMG_URI = 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgiIGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik01MTIgNjRDMjY0LjYgNjQgNjQgMjY0LjYgNjQgNTEyczIwMC42IDQ0OCA0NDggNDQ4IDQ0OC0yMDAuNiA0NDgtNDQ4Uzc1OS40IDY0IDUxMiA2NHptMCA4MjBjLTIwNS40IDAtMzcyLTE2Ni42LTM3Mi0zNzJzMTY2LjYtMzcyIDM3Mi0zNzIgMzcyIDE2Ni42IDM3MiAzNzItMTY2LjYgMzcyLTM3MiAzNzJ6Ii8+CiAgPHBhdGggZmlsbD0iI0U2RTZFNiIgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIvPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik0yODggNDIxYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHptMjI0IDExMmMtODUuNSAwLTE1NS42IDY3LjMtMTYwIDE1MS42YTggOCAwIDAgMCA4IDguNGg0OC4xYzQuMiAwIDcuOC0zLjIgOC4xLTcuNCAzLjctNDkuNSA0NS4zLTg4LjYgOTUuOC04OC42czkyIDM5LjEgOTUuOCA4OC42Yy4zIDQuMiAzLjkgNy40IDguMSA3LjRINjY0YTggOCAwIDAgMCA4LTguNEM2NjcuNiA2MDAuMyA1OTcuNSA1MzMgNTEyIDUzM3ptMTI4LTExMmE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6Ii8+Cjwvc3ZnPg==';
    string public constant SAD_SVG_URI = "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFpHRjBZVHBwYldGblpTOXpkbWNyZUcxc08ySmhjMlUyTkN4UVNFNHlXbmxDTW1GWFZqTlJiVGswVUZOSmQwbEVRV2ROYWtGM1NVUkpkMDFEU1dka01teHJaRWRuT1VscVVYZE5RMGxuU1Vkb2JHRlhaRzlrUkRCcFRrUkJkMGxwUWpSaVYzaDFZM293YVdGSVVqQmpSRzkyVEROa00yUjVOVE5OZVRWMlkyMWpkazFxUVhkTlF6bDZaRzFqYVZCbmIyZEpSSGhxWVZoS2FtSkhWV2RaTTJjNVNXcEZkMDFEU1dkWk0yczVTV3BGZDAxRFNXZGFiV3h6WWtRd2FXVlhWbk5pUnprelNXbENlVkJUU1ROUFEwbG5Zek5TZVdJeWRHeFFVMHBwWWtkR2FtRjVTV2RqTTFKNVlqSjBiRXhZWkhCYVNGSnZVRk5KZWtscE9DdERhVUZuVUVkaloxa3llR2hqTTAwNVNXMVdOVnBZVFdsUVoyOW5TVU5CWjFCSFRuQmpiVTV6V2xOQ2FtVkVNR2xPZWtGcFNVZE9OVkJUU1RSTmFVbG5ZMm93YVUxVVNXbE1lalJMU1VOQlowbEVlR3BoV0VwcVlrZFZaMWt6WnpsSmFrVjVUbmxKWjFremF6bEphbWQ1U1dsQ2VWQlRTWGhOYVVsMlVHZHZaMGxFZDNaYWVqUkxTVU5CT0dOSFJqQmhRMEpyVUZOS2RFMVVUVEpNYW1kNFNVUkZlRTVwTkRGTk1rMTFUbXByWjAxcVdYVk5WR04wVG1wUmRVMVVSV2RPUkVsMFQwUkZkVTVVU1hSTWFtTjZTV2xDZW1SSWJITmFWREJwV20xc2MySkVjSFZpTWpWc1QzbENlbVJJU25aaE1sVTJTVWRLYzFsWFRuSlBlVUo2WkVoS2RtRXlWWFJrTW14clpFZG5Oa2xFVFRkSmFUZ3JRMnAzZG1NeldtNVFaejA5In0=";

     function setUp() public {
        deployer = new DeployMood();
        moodNft = deployer.run();
    }
    function testViewTokenUriINT() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        vm.stopPrank();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log(tokenUri);
    }

    function testMoodINT() public {
        address[] memory users = new address[](2);
        users[0] = makeAddr("user0");
        users[1] = makeAddr("user1");

        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            hoax(user);
            try moodNft.mintNft() {
                console.log("Minted NFT for user:", user);
            } catch Error(string memory reason) {
                console.log("Failed to mint NFT for user:", user, "Reason:", reason);
                return;
            } 

            if (i == 0) {
                try moodNft.setMood(0, MoodNft.Mood.Happy) {
                    console.log("Set mood to Happy for tokenId 0");
                } catch Error(string memory reason) {
                    console.log("Failed to set mood for tokenId 0. Reason:", reason);
                    return;
                } 
            } else if (i == 1) {
                try moodNft.setMood(1, MoodNft.Mood.Sad) {
                    console.log("Set mood to Sad for tokenId 1");
                } catch Error(string memory reason) {
                    console.log("Failed to set mood for tokenId 1. Reason:", reason);
                    return;
                } 
            }
        }

        string memory happyTokenUri = moodNft.tokenURI(0);
        console.log("Token URI for tokenId(0) minted by users[0]:", happyTokenUri);

        string memory sadTokenUri = moodNft.tokenURI(1);
        console.log("Token URI for tokenId(1) minted by users[1]:", sadTokenUri);

        assert(moodNft.s_tokenIdtoMood(0) == MoodNft.Mood.Happy);
        assert(moodNft.s_tokenIdtoMood(1) == MoodNft.Mood.Sad);
    }

    function testFlipMoodINT () public{
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));

        vm.prank(USER);
        moodNft.flipMood(0);

        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(0))), (keccak256(abi.encodePacked(SAD_SVG_URI))));

    }
} 
