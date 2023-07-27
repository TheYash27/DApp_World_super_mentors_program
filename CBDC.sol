//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CBDC is ERC20 {
    address public controllingParty;
    uint public interestRateBasisPoints = 500;
    mapping(address => bool) public blacklist;
    mapping(address => uint) private stakedTreasuryBond;
    mapping(address => uint) private stakedFromTimeStamp;
    event UpdateControllingParty(address oldControllingParty, address newControllingParty);
    event UpdateInterestRate(uint oldInterestRate, uint newInterestRate);
    event IncreaseMoneySupply(uint oldMoneySupply, uint inflationAmount);
    event UpdateBlacklist(address criminal, bool blocked);
    event StakeTreasuryBonds(address user, uint amount);
    event UnstakeTreasuryBonds(address user, uint amount);
    event ClaimTreasuryBonds(address user, uint amount);

    constructor(address _controllingParty, uint initialSupply)
    ERC20("Central Bank Digital Currency", "CDBC") {
        controllingParty = _controllingParty;
        _mint(controllingParty, initialSupply);
    }

    function updateControllingParty(address newControllingParty) external {
        require(msg.sender == controllingParty, "U R NOT authorized to call this func.!");
        controllingParty = newControllingParty;
        _transfer(controllingParty, newControllingParty, balanceOf(controllingParty));
        emit UpdateControllingParty(msg.sender, newControllingParty);
    }

    function updateInterestRate(uint newInterestRateBasisPoints) external {
        require(msg.sender == controllingParty, "U R NOT authorized to call this func.!");
        uint oldInterestRateBasisPoints = interestRateBasisPoints;
        interestRateBasisPoints = newInterestRateBasisPoints;
        emit UpdateInterestRate(oldInterestRateBasisPoints, newInterestRateBasisPoints);
    }

    function increaseMoneySupply(uint inflationAmount) external {
        require(msg.sender == controllingParty, "U R NOT authorized to call this func.!");
        uint oldMoneySupply = totalSupply();
        _mint(msg.sender, inflationAmount);
        emit IncreaseMoneySupply(oldMoneySupply, inflationAmount);
    }

    function updateBlacklist(address criminal, bool blacklisted) external {
        require(msg.sender == controllingParty, "U R NOT authorized to call this func.!");
        blacklist[criminal] = !blacklisted;
        emit UpdateBlacklist(criminal, blacklisted);
    }

    function stakeTreasuryBonds(uint amount) external {
        require(amount > 0, "U can NOT stake <= 0!");
        require(balanceOf(msg.sender) >= amount, "U do NOT hv. enuf balance to stake the desired amt. of treasury bonds!");
        _transfer(msg.sender, address(this), amount);
        if(stakedTreasuryBond[msg.sender] > 0) claimTreasuryBonds();
        stakedFromTimeStamp[msg.sender] = block.timestamp;
        stakedTreasuryBond[msg.sender] += amount;
        emit StakeTreasuryBonds(msg.sender, amount);
    }

    function unstakeTreasuryBonds(uint amount) external {
        require(amount > 0, "U can NOT unstake <= 0!");
        require(stakedTreasuryBond[msg.sender] >= amount, "U do NOT hv. enuf staked treasury bonds to unstake the desired amt. of treasury bonds!");
        claimTreasuryBonds();
        stakedTreasuryBond[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
        emit UnstakeTreasuryBonds(msg.sender, amount);
    }

    function claimTreasuryBonds() public {
        require(stakedTreasuryBond[msg.sender] > 0, "U do NOT hv. enuf any staked treasury bonds to claim!");
        uint secondsStakedFor = block.timestamp - stakedFromTimeStamp[msg.sender];
        uint reward = stakedTreasuryBond[msg.sender] * secondsStakedFor * (interestRateBasisPoints / 3.154e11);
        stakedFromTimeStamp[msg.sender] = block.timestamp;
        _mint(msg.sender, reward);
        emit ClaimTreasuryBonds(msg.sender, reward);
        emit IncreaseMoneySupply(totalSupply(), reward);
    }

    function _transfer(address from, address to, uint amount) internal virtual override {
        require(blacklist[from] == false, "This addr. is NOT permitted to send tokens!");
        require(blacklist[to] == false, "This addr. is NOT permitted to receive tokens!");
        super._transfer(from, to, amount);
    }
}