# Rafflor
Rafflor.sol
/*
This smart contract allows users to lock their ERC721 tokens as a prize for a raffle. The user who locks the token sets the number of tickets available for purchase, the price of the tickets, and a timestamp for when the raffle will end. Other users can participate in the raffle by buying tickets. When the timestamp expires, the smart contract selects a winner randomly and automatically transfers the locked NFT to the winner. The smart contract has a function called hasEnded that can be used to check if the raffle has ended.
Please note that this code is provided as an example only and has not been tested or audited. It is important to thoroughly test and audit any smart contract before deployment.
*/
