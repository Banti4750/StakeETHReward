// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

Interface ITronCoin{
    function mint(address to , uint256 amount)external;
}

contract StackContarct {
    uint256 public TotalSupply;
    uint256 public constant REWARD_PER_SEC_PER_ETH = 1;

    ITronCoin public TronCoin;

    struct UserInfo {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }

    mapping(address => UserInfo) public userInfo;

    constructor(ITronCoin _token) {
        TronCoin =_token;
    }

    function _upadateRewards(address _user) internal {
        if (userInfo[_user].lastUpdate == 0) {
            userInfo[_user].lastUpdate = block.timestamp;
            return;
        }

        uint256 timeDiff = block.timestamp - userInfo[_user].lastUpdate;
        if (timeDiff == 0) {
            return;
        }

        uint256 additionalReward = timeDiff *
            REWARD_PER_SEC_PER_ETH *
            userInfo[_user].stakedAmount;

        userInfo[_user].rewardDebt += additionalReward;
        userInfo[_user].lastUpdate = block.timestamp;
    }

    function stack(uint256 _amount) public payable {
        require(_amount > 0, "Cannot stake 0");
        require(msg.value == _amount, "ETH amount mismatch");

        _upadateRewards(msg.sender);

        TotalSupply += _amount;
        userInfo[msg.sender].stakedAmount += _amount;
    }

    function unstack(uint256 _amount) public payable {
        require(_amount > 0, "Cannot unstake 0");
        require(_amount <= userInfo[msg.sender].stakedAmount);

        _upadateRewards(msg.sender);

        TotalSupply -= _amount;
        userInfo[msg.sender].stakedAmount -= _amount;
        payable(msg.sender).transfer(_amount);
    }
    function claimRewards() public {
        _upadateRewards(msg.sender);
        TronCoin.mint(msg.sender , userInfo[msg.sender].rewardDebt);
        userInfo[msg.sender].rewardDebt =0;
    }

    function getRewards() public view returns (uint256) {
        uint256 timeDiff = block.timestamp - userInfo[msg.sender].lastUpdate;
        if (timeDiff == 0) {
            return userInfo[msg.sender].rewardDebt;
        }

        return
            (userInfo[msg.sender].stakedAmount *
                timeDiff *
                REWARD_PER_SEC_PER_ETH) + userInfo[msg.sender].rewardDebt;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return userInfo[_address].stakedAmount;
    }
}
