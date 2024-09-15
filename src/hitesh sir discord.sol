//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 < 0.9.0;


contract ChaiCode{

    
    //state variable
    //local variable
    //global variable
    uint256 public  age = 10;
    address vishal = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    function setter(uint256 _age) public {
        age = _age;
    }
    function getter() public view  returns(uint256)  {
        return  age;
    }
    function getter2() public view  returns(address)  {
        return  vishal;
    }
 function getter3() public pure returns(address)  {
        
    }

    string public  s1  = "vishal";
    function setter2() public  {
        s1 = "vishal2";
    }


    function setter3(string memory _ps1) public  {
        s1 = _ps1;
    }
    function setter4(string memory _ps1) public pure  returns(string memory) {
        //string memory name = "abc";
        string memory name2 = _ps1;
        return name2;
    }

    uint[5] public  arr =[1,2,3,4,5];

    function setValue(uint256 index,uint256 value)public {
        arr[index] =value;
    }
    function getLength() public  view  returns (uint256){
        return arr.length;
    }
    //dynamic array
    uint[] public Darr;
    function addElement(uint _elem)public  {
        Darr.push(_elem);
    }
    function removeElement()public  {
        Darr.pop();
    }
    //bytes array
    //  1 byte = 8 bit
    //  1 hex  = 4 bit
    //  1byte = 2hex characters
    bytes3 public Barr1;      //3bytes   --- 3byte = 6 hex character

    function setter()public  {
        Barr1 ="abc";
    }

    //dynamic bytes arr
    bytes public  Barr2 ="abc";
    function setter4() public {
        Barr2.push("a");
    }
    function getElement(uint i)public view   returns (bytes1) {
        return Barr2[i];
    }
    function loop(uint n)public  pure  returns (uint) 
    {
        uint sum = 0;
        for (uint i=1; i<=n; i++){
            sum +=1;
        }
        return sum ;
    }

    function checkage(uint age2)public  pure returns (string memory) {
        require(age2>5,"age should be greater then 5");
        if (age2>55){
            return  "senior citizen";
        }else if(age2>24 && age2<40){
            return "young men";
        }else{
            return  "Teenage";
        }

    }

}