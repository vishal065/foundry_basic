// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint256 mynum;

    struct Person {
        uint256 favnum;
        string name;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameTOFavNumber;

    function store(uint256 _num) public {
        mynum = _num;
    }

    function retrive() public view returns (uint256) {
        return mynum;
    }

    function addPeople(string memory _name, uint256 _num) public {
        listOfPeople.push(Person(_num, _name));
        nameTOFavNumber[_name] = _num;
    }
}

contract SimpleStorage1 {}

contract SimpleStorage2 {}

contract SimpleStorage3 {}
