//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract CRUD {
    struct User {
        uint id;
        string name;
    }

    User[] public users;
    uint public nextId;

    function create(string memory name) public {
        users.push(User(nextId, name));
        nextId++;
    }

    function read(uint id) view public returns(uint, string memory) {
        uint i = findUser(id);
        return(users[i].id, users[i].name);
    }

    function update(uint id, string memory name) public {
        uint i = findUser(id);
        users[i].name = name;
    }

    function destroy(uint id) public {
        uint i = findUser(id);
        delete users[i];
    }

    function findUser(uint id) view internal returns(uint) {
        for (uint i = 0 ; i < users.length ; i++) {
            if (users[i].id == id) {
                return i;
            }
        }
        revert("A user with the given ID does NOT exist!");
    }
}