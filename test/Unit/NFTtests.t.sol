// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {NFT} from "src/NFT.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {DeployNFT} from "script/DeployNFT.s.sol";
import {IERC721Receiver} from "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTtest is Test, IERC721Receiver {
    
    DeployNFT public deployer;
    NFT public nft;

    function setUp() public {
        deployer = new DeployNFT();
        nft = deployer.run();
    }

    function testDeployment() public view {
        assertEq(nft.name(), "Earl");
        assertEq(nft.symbol(), "EARL");
        assertEq(nft.balanceOf(address(this)), 0);
    }

    function testMintNFT() public {
        string memory tokenURI = "https://example.com/token/1";
        nft.mintNft(tokenURI);

        assertEq(nft.balanceOf(address(this)), 1);
        assertEq(nft.tokenURI(0), tokenURI);
        assertEq(nft.ownerOf(0), address(this));
    }

    function testMintMultipleNFTs() public {
        string memory tokenURI1 = "https://example.com/token/1";
        string memory tokenURI2 = "https://example.com/token/2";
        nft.mintNft(tokenURI1);
        nft.mintNft(tokenURI2);

        assertEq(nft.balanceOf(address(this)), 2);
        assertEq(nft.tokenURI(0), tokenURI1);
        assertEq(nft.tokenURI(1), tokenURI2);
        assertEq(nft.ownerOf(0), address(this));
        assertEq(nft.ownerOf(1), address(this));
    }

    function testTokenURI() public {
        string memory tokenURI = "https://example.com/token/1";
        nft.mintNft(tokenURI);

        string memory returnedTokenURI = nft.tokenURI(0);
        assertEq(returnedTokenURI, tokenURI);
    }

    function testTokenOwner() public {
        string memory tokenURI = "https://example.com/token/1";
        nft.mintNft(tokenURI);

        address owner = nft.ownerOf(0);
        assertEq(owner, address(this));
    }

    function testTransferNFT() public {
        string memory tokenURI = "https://example.com/token/1";
        nft.mintNft(tokenURI);

        address recipient = address(0x123);
        nft.safeTransferFrom(address(this), recipient, 0);

        assertEq(nft.balanceOf(address(this)), 0);
        assertEq(nft.balanceOf(recipient), 1);
        assertEq(nft.ownerOf(0), recipient);
    }

    // Correctly implemented onERC721Received function
    function onERC721Received(
        address ,
        address ,
        uint256 ,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
