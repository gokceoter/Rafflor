pragma solidity ^0.8.0;

contract Raffle {
    // Define struct to store raffle information
    struct RaffleStruct {
        address owner;
        uint256 endTime;
        mapping(address => bool) participants;
        uint256[] tokens;
    }
    // Create mapping to store raffles
    mapping(bytes32 => RaffleStruct) public raffles;
    // Event for when a raffle is created
    event RaffleCreated(bytes32 indexed raffleId, address owner, uint256 endTime);
    // Event for when a participant joins a raffle
    event RaffleJoined(bytes32 indexed raffleId, address participant);
    // Event for when a raffle ends
    event RaffleEnded(bytes32 indexed raffleId, address winner);

    // Function to create a raffle
    function createRaffle(bytes32 raffleId, uint256 endTime, address[] memory tokens) public {
        // Require that the caller is the owner of all the tokens in the array
        for (uint256 i = 0; i < tokens.length; i++) {
            require(msg.sender == tokens[i], "Token not owned by caller");
        }
        // Require that the raffleId is not already in use
        require(raffles[raffleId].owner == address(0), "Raffle ID already in use");
        // Require that endTime is in the future
        require(endTime > now, "End time must be in the future");
        // Create the raffle and store it in the mapping
        raffles[raffleId] = RaffleStruct(msg.sender, endTime, mapping(address => bool)(), tokens);
        // Emit the RaffleCreated event
        emit RaffleCreated(raffleId, msg.sender, endTime);
    }

    // Function to join a raffle
    function joinRaffle(bytes32 raffleId) public {
        // Require that the raffle exists
        require(raffles[raffleId].owner != address(0), "Raffle does not exist");
        // Require that the caller is not already a participant
        require(!raffles[raffleId].participants[msg.sender], "Already a participant");
        // Add the caller as a participant
        raffles[raffleId].participants[msg.sender] = true;
        // Emit the RaffleJoined event
        emit RaffleJoined(raffleId, msg.sender);
    }

    // Function to end a raffle and pick a winner
    function endRaffle(bytes32 raffleId) public {
        // Require that the caller is the owner of the raffle
        require(msg.sender == raffles[raffleId].owner, "Not the owner of the raffle");
        // Require that the raffle has ended
        require(now >= raffles[raffleId].endTime, "Raffle has not ended yet");
        // Get the number of participants
        uint256
