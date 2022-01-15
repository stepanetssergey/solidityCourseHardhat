// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./BEP20Token.sol";



contract CourseToken is BEP20Token {
    constructor() {
        _initialize("Course TOKEN", 
                    "CTOKEN", 18, 
                    1 * 10000 * 10**18, 
                    false);
    }

}