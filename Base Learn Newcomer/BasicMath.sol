// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BasicMath {
    function adder(uint _a, uint _b) public pure returns (uint, bool) {
        unchecked {
            uint sum = _a + _b;
            // Overflow check
            if (sum < _a) {
                return (0, true); // overflow
            }
            return (sum, false);
        }
    }

    function subtractor(uint _a, uint _b) public pure returns (uint, bool) {
        if (_b > _a) {
            return (0, true); // underflow
        }
        return (_a - _b, false);
    }
}
