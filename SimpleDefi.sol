//SPDX-License-Identifier:MIT

pragma solidity  ^0.8.18;

contract SimpleDefi{
    struct Transaction{
        uint amount;
        uint timestamp;
    }

    struct Balance{
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    function getDeposits(address _from, uint _numDeposits) public view returns(Transaction memory){
        return balances[_from].deposits[_numDeposits];
    }

    function getWithdrawals(address _from, uint _numWithdrawals) public view returns(Transaction memory){
        return balances[_from].withdrawals[_numWithdrawals];
    }

    mapping(address => Balance) public balances;

    function deposit() public payable{
        balances[msg.sender].totalBalance += msg.value;
        
        Transaction memory deposits = Transaction(msg.value, block.timestamp);

        balances[msg.sender].deposits[balances[msg.sender].numDeposits] = deposits;
        balances[msg.sender].numDeposits++;
    }

    function withdrawMoney(uint _amount) public {
        if(_amount <= balances[msg.sender].totalBalance){
            balances[msg.sender].totalBalance -= _amount;
            Transaction memory withdrawals = Transaction(_amount, block.timestamp);
            balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawals;
            balances[msg.sender].numWithdrawals++;
            address payable to = payable(msg.sender);
            to.transfer(_amount);
        }   
    }

    function withdrawAll() public {
        uint balanceToSendOut = balances[msg.sender].totalBalance;
        balances[msg.sender].totalBalance = 0;
        Transaction memory withdrawals = Transaction(balanceToSendOut, block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawals;
        balances[msg.sender].numWithdrawals++;
        address payable to = payable(msg.sender);
        to.transfer(balanceToSendOut);
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender].totalBalance;
    }

    function transferToAddress(address payable _to, uint _amount) public {
        if(_amount <= balances[msg.sender].totalBalance){
            balances[msg.sender].totalBalance -= _amount;
            Transaction memory withdrawals = Transaction(_amount, block.timestamp);
            balances[msg.sender].withdrawals[balances[msg.sender].numWithdrawals] = withdrawals;
            balances[msg.sender].numWithdrawals++;
            _to.transfer(_amount);
        } 
    }
}