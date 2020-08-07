pragma solidity ^0.5.0;


interface IGST2 {
    function balanceOf(address who) external view returns (uint256);

    function free(uint256 value) external returns (bool success);

    function freeUpTo(uint256 value) external returns (uint256 freed);

    function freeFrom(address from, uint256 value) external returns (bool success);

    function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
}
