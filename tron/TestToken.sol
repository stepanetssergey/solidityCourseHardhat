// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// account6 owner TPHqBVndynYcwFXYu7DywdhhWo7nVTQJzs

import './TRC20.sol';
contract GAMEToken is TRC20 {
   constructor() TRC20("GameToken", "GCT") {
       _mint(msg.sender, 1000000 * 10 ** 6);
   }
}