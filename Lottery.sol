// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    //entities are: manager, players and winner
    
    address public manager;
    address payable[] public players;
    address payable public winner;
    //this initializes the variables or entities that we are going to make use of.

    constructor(){
        manager=msg.sender;
    } 
    //this means that as you run and deploy the contract, 
    //the address deploying the smart contract would get store inside the manager address.

    function participate() public payable{ //payable because the players would have to pay 1 ether.
        require(msg.value==1 ether, "Please pay up 1 ether only"); //requirement stated
        players.push(payable (msg.sender)); //if requirement is true then push the players to the players array.
        // note the msg.sender was made payable.
    }

    function getBalance() public view returns(uint){ //to check the amount of ether that has been deposited and return a random number
        require(manager==msg.sender, "You are not the manager"); //condition that states only manager can request for balance.
        return address(this).balance; //return the balance is condition is true.
    }

    function random() internal view returns(uint){ //this fuction is used to select a random winner.
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    } //the syntax above would generate a random player
      //use should possible use oracle instead

    function pickWinner() public { //this function is use to pick winner random
        require(manager==msg.sender, "You're not the manager");
        require(players.length>=3, "Players are less than 3");

        uint r=random();
        uint index = r%players.length;
        winner=players[index];
        winner.transfer(getBalance());
        players= new address payable [](0);
        
    }
}