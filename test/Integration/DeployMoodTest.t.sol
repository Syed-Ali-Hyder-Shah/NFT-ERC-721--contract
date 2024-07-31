// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {Vm} from "lib/forge-std/src/Vm.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMood} from "script/DeployMood.s.sol";

contract DeployMoodNftTest is Test {
    DeployMood public deployer;

    function setUp() public{
        deployer = new DeployMood();
    }

    function testConvertSvgToImageUri() public view{
string memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiBmaWxsPSJ5ZWxsb3ciIHI9Ijc4IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiLz48ZyBjbGFzcz0iZXllcyI+PGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz48Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiLz48L2c+PHBhdGggZD0ibTEzNi44MSAxMTYuNTNjLjY5IDI2LjE3LTY0LjExIDQyLTgxLjUyLS43MyIgc3R5bGU9ImZpbGw6bm9uZTsgc3Ryb2tlOiBibGFjazsgc3Ryb2tlLXdpZHRoOiAzOyIvPjwvc3ZnPg==";
    string memory svg = "<svg viewBox=\"0 0 200 200\" width=\"400\" height=\"400\" xmlns=\"http://www.w3.org/2000/svg\"><circle cx=\"100\" cy=\"100\" fill=\"yellow\" r=\"78\" stroke=\"black\" stroke-width=\"3\"/><g class=\"eyes\"><circle cx=\"70\" cy=\"82\" r=\"12\"/><circle cx=\"127\" cy=\"82\" r=\"12\"/></g><path d=\"m136.81 116.53c.69 26.17-64.11 42-81.52-.73\" style=\"fill:none; stroke: black; stroke-width: 3;\"/></svg>";

    string memory givenUri = deployer.svgToImageUri(svg);

    console.log("Expected URI: ", expectedUri);
    console.log("Given URI: ", givenUri);

    assert(keccak256(abi.encodePacked(givenUri)) == keccak256(abi.encodePacked(expectedUri)));
}

}
