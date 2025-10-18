// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract Submission {
    mapping(address => uint256) public balances;
    mapping(address => bool) private hasClaimed;
    uint256 public totalClaimed;

    error TokensClaimed();
    error UnsafeTransfer(address to);
    error InsufficientBalance(uint256 available, uint256 required);

    function claim() external {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint256 _amount) external {
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        if (_to.code.length > 0) {
            if (_to.balance == 0) {
                revert UnsafeTransfer(_to);
            }
        }

        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance(balances[msg.sender], _amount);
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function totalSupply() external view returns (uint256) {
        return totalClaimed;
    }
}
