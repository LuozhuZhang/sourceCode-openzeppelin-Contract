
   
// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */

// 返回tx sender和call data（tx data）的信息
// 只有一些中间合约可能需要这个context（intermediate, library-like contracts），因为他们的sender（发起）和实际pay sender可能不是一个人，具体用例我们未来可以研究一下
// 之前一直好奇一个「代付功能的实现」，看看有没有现成的contract或者EIP
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}