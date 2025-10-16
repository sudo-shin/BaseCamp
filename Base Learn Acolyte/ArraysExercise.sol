// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract Submission {
    uint[] private numbers;
    uint[] private timestamps;
    address[] private senders;

    constructor() {
        resetNumbers();
    }

    function resetNumbers() public {
        delete numbers;
        for (uint i = 1; i <= 10; i++) {
            numbers.push(i);
        }
    }

    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    function saveTimestamp(uint _unixTimestamp) external {
        timestamps.push(_unixTimestamp);
        senders.push(msg.sender);
    }

    function resetTimestamps() external {
        delete timestamps;
    }

    function resetSenders() external {
        delete senders;
    }

    function afterY2K() external view returns (uint[] memory, address[] memory) {
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] >= 946702900) {
                count++;
            }
        }

        uint[] memory filteredTimestamps = new uint[](count);
        address[] memory filteredAddresses = new address[](count);
        uint counter = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] >= 946702900) {
                filteredTimestamps[counter] = timestamps[i];
                filteredAddresses[counter] = senders[i];
                counter++;
            }
        }

        return (filteredTimestamps, filteredAddresses);
    }
}
