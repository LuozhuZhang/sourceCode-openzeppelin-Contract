// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */

// ownable一直是contract manage的核心模块（而且也是容易被攻击的模块）
// 模块情况下部署contract的地址就是owner，也可以通过transferOwnership转移所有权
abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
    * @dev Initializes the contract setting the deployer as the initial owner.
    */
  // 初始化合约，部署者即owner
  constructor() {
    _transferOwnership(_msgSender());
  }

  /**
    * @dev Returns the address of the current owner.
    */
  // 返回当前的owner
  function owner() public view virtual returns (address) {
    return _owner;
  }

  /**
    * @dev Throws if called by any account other than the owner.
    */
  // 封装了一层owner检查，解答了我们在zksync源码中看到的疑惑：
  // 1. onlyOwner并不是native solidity的，而是openzepplien中declare并被其他合约所继承的
  // 2. zksync自己封装了onlyOwner模块，并没有使用openzepplien的basic contract
  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
    * @dev Leaves the contract without owner. It will not be possible to call
    * `onlyOwner` functions anymore. Can only be called by the current owner.
    *
    * NOTE: Renouncing ownership will leave the contract without an owner,
    * thereby removing any functionality that is only available to the owner.
    */
  // 将owner转移到0，则放弃contract的所有权（contract不会被删除，但是没有所有者）
  function renounceOwnership() public virtual onlyOwner {
    _transferOwnership(address(0));
  }

  /**
    * @dev Transfers ownership of the contract to a new account (`newOwner`).
    * Can only be called by the current owner.
    */
  function transferOwnership(address newOwner) public virtual onlyOwner {
    // 防止致命error
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    // 转移合约所有权
    _transferOwnership(newOwner);
  }

  /**
    * @dev Transfers ownership of the contract to a new account (`newOwner`).
    * Internal function without access restriction.
    */
  function _transferOwnership(address newOwner) internal virtual {
    address oldOwner = _owner;
    _owner = newOwner;
    // 调用这个event，转让合约所有权。zksync中通过直接调用EVM来实现这个功能，目测gas会便宜一些（assembly）
    emit OwnershipTransferred(oldOwner, newOwner);
  }
}
