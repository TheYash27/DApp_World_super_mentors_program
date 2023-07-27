//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ArrayStorage {
    uint[] public ids;

    function add(uint id) public {
        ids.push(id);
    }

    function get1Ele(uint position) view public returns(uint) {
        return ids[position];
    } 

    function getAllEle() view public returns(uint[] memory) {
        return ids;
    }

    function getLen() view public returns(uint) {
        return ids.length;
    }
}