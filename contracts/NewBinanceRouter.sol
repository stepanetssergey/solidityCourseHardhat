pragma solidity ^0.8.0;

import './interfaces/IFactory.sol';
import './interfaces/IBEP.sol';
import './interfaces/INewBinancePair.sol';

contract NewBinanceRouter {
     
     // 1. Aдрес пары
     // 1.1 token0 address
     // 1.2 token1 address
     // 1.3 token0 amount
     //     token0 min
     // 1.4 token1 amount
     //     token1 min
     // deadline
     //
     // 100 usdt - 100 courseCoins 12.28 15.01
     // step1 - 10 usdt -> 9.98 
     //   - 90 usdt - 89 curseCoins
     // 190 - 10 
     // 10 - 0.5 < > 9.98
     // step2 - call swap ()
     // amounIn - minamountOut    amountIn ----- ( amountOut - (amountOut * 0.1)) = amountOutMin

     address public factory;

     constructor(address _factory) {
        factory = _factory;
     }


     function addLiquidity(address _token0, address _token1, uint _amount0, uint _amount1) public 
       returns(uint)
     {  
        // 0. Проверить есть ли пара с такими токенами и если не то создать новую пару
        // 1. get pair address
        IFactory _factoryInstance = IFactory(factory);
        address pair = _factoryInstance.Pairs(_token0, _token1);
        IBEP20(_token0).transferFrom(msg.sender, pair, _amount0);
        IBEP20(_token1).transferFrom(msg.sender, pair, _amount1);
        uint liquidity = INewBinancePair(pair).mint(msg.sender);
        return liquidity;
     }


}