// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Submission is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    uint public counter;
    mapping(uint256 => Haiku) private haikus;
    mapping(bytes32 => bool) private line1Hashes;
    mapping(address => uint256[]) private sharedHaikus;

    error HaikuNotUnique();
    error NotYourHaiku(uint256 tokenId);
    error NoHaikusShared();

    constructor() ERC721("HaikuNFT", "HNK") {}

    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        bytes32 line1Hash = keccak256(abi.encodePacked(_line1));
        if (line1Hashes[line1Hash]) {
            revert HaikuNotUnique();
        }
        line1Hashes[line1Hash] = true;

        uint256 id = counter;
        haikus[id] = Haiku(msg.sender, _line1, _line2, _line3);
        _mint(msg.sender, id);
        counter++;
    }

    function shareHaiku(uint256 _id, address _to) external {
        if (ownerOf(_id) != msg.sender) {
            revert NotYourHaiku(_id);
        }
        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() external view returns (Haiku[] memory) {
        uint256[] memory ids = sharedHaikus[msg.sender];
        if (ids.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            result[i] = haikus[ids[i]];
        }
        return result;
    }
}
