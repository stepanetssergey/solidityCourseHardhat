// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./BEP20Token.sol";



contract USDT is BEP20Token {
    constructor() {
        _initialize("USDT TOKEN", 
                    "USDT", 18, 
                    1 * 10000 * 10**18, 
                    false);
    }

}