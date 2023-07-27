// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;

    constructor() ERC20('My Token', 'YNS') {
        owner = msg.sender;
        _mint(msg.sender, 1 * (10 ** 18));
    }

    function mint(address to, uint amount) external {
        require(msg.sender == owner, "ONLY the deplr. of the YNS token's smart contract can call this func.!");
        _mint(to, amount);
    }

    function burn(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "U do NOT hv. enuf tokens to burn!");
        _burn(msg.sender, amount);
    }
}