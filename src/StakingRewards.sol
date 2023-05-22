// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;
    address public owner;

    uint256 public startAt;
    uint256 public endAt;
    uint256 public rewardsPerToken;
    uint256 public lastUpdateTime;
    uint256 public rewardRate;
    mapping (address => uint256) public userRewardsPerToken;
    mapping (address => uint256) public rewards;

    uint256 public totalSupply;
    mapping (address => uint256) public totalStakedByUser;

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "sender is not the owner"
        );
        _;
    }
    constructor(address _stakingToken, address _rewardToken)  {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function setTotalSupply(
        uint256 _totalSupply
        ) external onlyOwner() {
            totalSupply = _totalSupply;
    }

    function setRewardRate(
        uint256 _rewardRate
        ) external onlyOwner() {
            rewardRate = _rewardRate;
    }

    function stake(uint256 _amount) public {
        rewardsPerToken += (rewardRate/totalSupply) * (block.timestamp - lastUpdateTime);
        rewards[msg.sender] += totalStakedByUser[msg.sender] * (rewardsPerToken - userRewardsPerToken[msg.sender]);
        userRewardsPerToken[msg.sender] = rewardsPerToken;
        lastUpdateTime = block.timestamp;
        totalSupply += _amount;
    }

    function withdraw(uint256 _amount) public {
        rewardsPerToken += (rewardRate/totalSupply) * (block.timestamp - lastUpdateTime);
        rewards[msg.sender] += totalStakedByUser[msg.sender] * (rewardsPerToken - userRewardsPerToken[msg.sender]);
        userRewardsPerToken[msg.sender] = rewardsPerToken;
        lastUpdateTime = block.timestamp;
        totalSupply -= _amount;
    }

}
