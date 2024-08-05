// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/*

    This contract using Merkle tree to ensure that only valid user (Whale user) can claim NFT
    Allowing distribute NFTs securely

    Minting NFTs : allows owner to mint NFTs to Whale address
    Claim functions : check if a users is eligible for claim NFT by verifying a Merkle proof

    Steps :
    Prepare the merkle tree data : collect a list of user addresses and their corresponding token IDs
    Generate the Merkle tree from this data and obtain the Merkle root

    Deploy this contract

    use updateMerkleRoot function to set the Merkle root in the contract

    Distribute the merkle root : Distribute the Merkle proof to each user so they can receive the NFTs

    User call the claim function with their respective token ID and Merkle proof to receive the NFTs


    Applying merkle tree to contract scenario
    - gather the list of valid users and their corresponding token IDs
    - Create leaf node by hashing each user's address and token ID

    - storing the merkle root : stored in the smart contract
    -  this root represents the entire set of valid users and their token IDs

    - generating merkle proof : for each user,generate a merkle proof, which is a sequance of hashes that allows the user to prove their inclusion in the tree
    - Each proof consists of the necessary sibling hashes to reconstruct the path to the Merkle root.

    - user claim NFTs:
    - The user submits their token ID and Merkle proof to the contract’s claim function.
    - The contract verifies the proof by reconstructing the path to the Merkle root.
    - If the reconstructed root matches the stored Merkle root, the user’s claim is valid, and the contract mints the NFT to the user.

    BaseTokenURI

    -  string variable in the NFT contract that hold the base URL for the metadata of the NFTs
    - purpose : help organize and locate the metadata for each NFTs
    - metadata usually include details about the NFT, such as its name, description and image
    - the tokenURI function combine the base baseTokenURI with the tokenID to generate the complete  URI for the metadata of a specific NFT
    - Simplified Code: Instead of specifying the full URI for each individual token's metadata, you set a common base URI once. This reduces redundancy and makes the code cleaner and easier to manage.
    - Batch Initialization: When minting multiple NFTs, you only need to handle the base URI once, which simplifies the initialization process.
    - Uniform Structure: All tokens in the collection share the same base URI, ensuring that their metadata can be easily found and accessed by appending the token ID.
    - Predictable URIs: The URI structure becomes predictable (baseTokenURI + token ID + .json), making it easy to programmatically generate and retrieve metadata for any token.



 */

contract ObNFT is ERC721, Ownable, Pausable, ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;

    string public baseTokenURI; // store base URL for the token metadata
    bytes32 public merkleRoot;
    EnumerableSet.AddressSet _members;

    event BaseTokenURIChanged(string indexed baseTokenURI);
    event MerkleRootUpdated(bytes32 merkleRoot);
    event Claimed(uint256 tokenId, address indexed claimer);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI
    ) ERC721(_name, _symbol) {
        
    }
}
