// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Library {

    event AddBook (address user, uint256 id);
    event SetFinished(uint256 id, bool finished);
    event Result(uint id, string name);

    struct Book{
        uint256 id;
        string name;
        uint256 price;
        uint256 year;
        string author;
        bool finished;
    }

    Book[] private booklist;

    mapping(uint256 => address) bookToOwner;

    function addBook( uint256 price, string memory name, uint256 year, string memory author, bool finished) external{
        uint256 id = booklist.length + 1;

        booklist.push(Book(id, name, price, year, author, finished));
        bookToOwner[id] = msg.sender;
        emit AddBook (msg.sender, id);
    }

    function _getBookList(bool finished) public view returns (Book[] memory allbook){
        Book[] memory temporary = new Book[](booklist.length);

        uint counter = 0;
        for(uint256 i = 0; i < booklist.length; i++){
            if(bookToOwner[i] == msg.sender && booklist[i].finished == finished){
                temporary[counter] = booklist[i];
                counter++;
            }
        }

        Book[] memory result = new Book[](counter);
        for(uint256 i = 0; i < counter; i++){
             result[i]  = temporary[i];
        }

        return result;
    }

    function getFinishedBook() external view returns(Book[] memory finishedbooks){
        return _getBookList(true);
    }

    function getUnfinishedBook() external view returns(Book[] memory unfinishedbooks){
        return _getBookList(false);
    }

    function setFinished(uint256 id, bool finished) external{
        if(bookToOwner[id] == msg.sender){
            booklist[id].finished =  finished;
            emit SetFinished(id, finished);
        }
    }

    function getAllBookList() external view returns(Book[] memory fullbooklist){
        return booklist;
    }

    function changeName(string memory name, uint id) external returns(Book[] memory newbooks){
        
        if(bookToOwner[id] == msg.sender){
            booklist[id].name = name;
            emit Result(id, name);
            return booklist;
        }
    
    }
}