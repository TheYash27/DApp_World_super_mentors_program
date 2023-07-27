//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721 {
    uint256 private _tokenIds;

    constructor() ERC721("Harry Potter NFTs", "HPNFT") {

    }

    function mint() public returns (uint256) {
        _tokenIds += 1;
        _mint(msg.sender, _tokenIds);
        return _tokenIds;
    }

    function tokenURI (uint256 _tokenId) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/QmSawKifvBiZSFjGVEEbZGPPwfEmyZVgveu4uvZE1q2krh/",
                Strings.toString(_tokenId),
                ".json"
            )
        );
    }
}