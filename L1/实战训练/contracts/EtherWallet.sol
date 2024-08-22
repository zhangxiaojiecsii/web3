// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/*
5. ETH 钱包   
    这一个实战主要是加深大家对 3 个取钱方法的使用。
    任何人都可以发送金额到合约
    只有 owner 可以取款
    3 种取钱方式 transfer send call
 */

contract EtherWallet {
    address payable public immutable owner;

    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, "");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw1() external {
        require(msg.sender == owner, "Not owner");
        // owner.transfer 相比 msg.sender 更消耗Gas
        // owner.transfer(address(this).balance);
        payable(msg.sender).transfer(100);
    }
    function withdraw2() external {
        require(msg.sender == owner, "Not owner");
        bool success = payable(msg.sender).send(200);
        require(success, "Send Failed");
    }
    function withdraw3() external {
        require(msg.sender == owner, "Not owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call Failed");
    }
}