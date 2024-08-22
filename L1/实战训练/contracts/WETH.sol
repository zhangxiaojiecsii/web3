// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/*
2. WETH 合约
    WETH 是包装 ETH 主币，作为 ERC20 的合约。 标准的 ERC20 合约包括如下几个：
        3 个查询
            balanceOf: 查询指定地址的 Token 数量
            allowance: 查询指定地址对另外一个地址的剩余授权额度
            totalSupply: 查询当前合约的 Token 总量
        2 个交易
            transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
            这是一个写入方法，所以还会抛出一个 Transfer 事件。
            transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
        2 个事件
            Transfer
            Approval
        1 个授权
            approve: 授权指定地址可以操作调用者的最大 Token 数量。
*/
contract WETH {
    event Transfer(address indexed sourceAds, address indexed toAds, uint256 amount);

    event Approval(address indexed sourceAds, address indexed delegateAds, uint256 amount);


    event Deposit(address indexed toAds, uint256 amount);

    event Withdraw(address indexed sourceAds, uint256 amount);

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

  
    receive() external payable {
        deposit();
    }

    fallback() external payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
 
    

    function transfer(address toAds, uint256 amount)  public returns (bool) {
        return transferFrom(msg.sender, toAds, amount);
    }

    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[src] >= amount);
        if (src != msg.sender) {
            require(allowance[src][msg.sender] >= amount);
            allowance[src][msg.sender] -= amount;
        }
        balanceOf[src] -= amount;
        balanceOf[toAds] += amount;
        emit Transfer(src, toAds, amount);
        return true;
    }


    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }
    function approve(address delegateAds, uint256 amount) public returns (bool) {
        allowance[msg.sender][delegateAds] = amount;
        emit Approval(msg.sender, delegateAds, amount);
        return true;
    }

}