pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTRaffle {
    // Events
    event NFTLocked(address indexed _tokenId, address indexed _owner);
    event TicketBought(address indexed _buyer, uint256 _ticketId);
    event RaffleEnded(address indexed _winner, uint256 _winningTicketId);

    // State variables
    mapping(address => bool) public nftLocked;
    mapping(address => uint256) public ticketPrice;
    mapping(address => uint256) public ticketCount;
    mapping(address => uint256) public endTimestamp;
    mapping(address => mapping(address => bool)) public ticketsSold;
    mapping(address => address) public nftToRaffle;

    // ERC721
    ERC721 public nft;

    // Functions
function lockNFT(address _tokenId, uint256 _ticketPrice, uint256 _ticketCount, uint256 _endTimestamp) public {
        require(nft.ownerOf(bytes32(_tokenId)) == msg.sender);
        require(!nftLocked[_tokenId]);
        nftLocked[_tokenId] = true;
        nftToRaffle[_tokenId] = _tokenId;
        ticketPrice[_tokenId] = _ticketPrice;
        ticketCount[_tokenId] = _ticketCount;
        endTimestamp[_tokenId] = _endTimestamp;
        emit NFTLocked(_tokenId, msg.sender);
    }

    function buyTicket(address _tokenId) public payable {
        require(msg.sender != nft.ownerOf(_tokenId));
        require(nftLocked[_tokenId]);
        require(msg.value == ticketPrice[_tokenId]);
        require(!ticketsSold[_tokenId][msg.sender]);
        ticketsSold[_tokenId][msg.sender] = true;
        uint256 ticketId = ticketCount[_tokenId]++;
        emit TicketBought(msg.sender, ticketId);
    }

    function hasEnded(address _tokenId) public view returns (bool) {
        return block.timestamp >= endTimestamp[_tokenId];
    }

    function selectWinner(address _tokenId) public {
        require(msg.sender == nft.ownerOf(_tokenId));
        require(hasEnded(_tokenId));
        address[] memory ticketHolders = new address[](ticketCount[_tokenId]);
        uint256 i = 0;
        for (address holder in ticketsSold[_tokenId]) {
            ticketHolders[i++] = holder;
        }
        uint256 winningTicketId = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % ticketCount[_tokenId];
        address winner = ticketHolders[winningTicketId];
        nft.transferFrom(msg.sender, winner, _tokenId);
        emit RaffleEnded(winner, winningTicketId);
}
}


