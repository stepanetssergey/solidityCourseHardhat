pragma solidity ^0.8.0;
import './NewBinanceERC20.sol';
import './libraries/SafeMath.sol';
import './libraries/Math.sol';

contract NewBinancePair is NewBinanceERC20 {

    using SafeMath for uint;
    using Math for uint;

    address public factory;
    address public token0;
    address public token1;
    uint112 private reserve0;
    uint112 private reserve1;           

    uint MINIMUM_LIQUIDITY = 1000;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    constructor() {
      factory = msg.sender;
    }

    function initialize(address _token0, address _token1) public {
        require(msg.sender == factory, "Only factory");
        token0 = _token0;
        token1 = _token1;
    }
    
    uint public unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'BinanceNew: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    // swap -> amount0Out, amount1Out 
    // 
    // mint -> provider liquidity + token0 and token1 = mint amount TL -> mint to address от провайдера ликвидности;
    // 1. 1000 LPT (wei) 10 ** 18 -> 1000 
     // burn 
    // 1. Провайдер ликвидности дает апрув на роутер (дает право роутеру перечислять токен ликвидности)
    // 2. Перечисляет токен ликвидности на сам токен ликвидности. 
    // 3. В зависимости от суми контракт пары перечисляет назад провайдеру ликвидности токен0 токен1 + fee ( % )
    // 1000 LP -> 100
    // 10% token0, 10% token1 10% fee
    //
    //
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
       // _blockTimestampLast = blockTimestampLast;
    }
     
    // token0 NewBNCCoin
    // token1 USDT
    function mint(address to) external lock returns (uint liquidity) {
        (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
        uint balance0 = NewBinanceERC20(token0).balanceOf(address(this));
        uint balance1 = NewBinanceERC20(token1).balanceOf(address(this));
        uint amount0 = balance0.sub(_reserve0);
        uint amount1 = balance1.sub(_reserve1);

        //bool feeOn = _mintFee(_reserve0, _reserve1);
        // create pair
        // 100 usdt + 100 NBC
        // -1 = 0
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            // sqrt(100 * 100) = 100
           _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
            // 50 usdt - 150 nbc
            // 100 - usdt 100 nbc
            // 10000/50 = 20, 10000/150 = 66
            // у того кто положил первым - 83.3% у второго - 16.3% - totalSupply()

        }
        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
        _mint(to, liquidity);

        _update(balance0, balance1, _reserve0, _reserve1);
        //if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
        //emit Mint(msg.sender, amount0, amount1);
    }





    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        //require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        // uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        // if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
        //     // * never overflows, and + overflow is desired
        //     price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
        //     price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        // }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        //blockTimestampLast = blockTimestamp;
        //emit Sync(reserve0, reserve1);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
        (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
        //if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
        balance0 = NewBinanceERC20(_token0).balanceOf(address(this));
        balance1 = NewBinanceERC20(_token1).balanceOf(address(this));
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
        uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
        uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
        require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
        }

        _update(balance0, balance1, _reserve0, _reserve1);
        //emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }


    // remove liquidity
    // 1. Получили или не получили токены
    // 1.1 Пользователь перечисляет токены на пару

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
    }

    function burn(address to) external lock returns (uint amount0, uint amount1) {
        (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
        address _token0 = token0;                                // gas savings
        address _token1 = token1;                                // gas savings
        uint balance0 = NewBinanceERC20(_token0).balanceOf(address(this));
        uint balance1 = NewBinanceERC20(_token1).balanceOf(address(this));
        uint liquidity = _balance[address(this)];

        //bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution

        // totalSupply = balance0
        // liquidity = x
        // liquidity*balance0/totalSupply
        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
        _burn(address(this), liquidity);
        _safeTransfer(_token0, to, amount0);
        _safeTransfer(_token1, to, amount1);
        balance0 = NewBinanceERC20(_token0).balanceOf(address(this));
        balance1 = NewBinanceERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1, _reserve0, _reserve1);
        //if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
        //emit Burn(msg.sender, amount0, amount1, to);
    }


    // 1. Создаем пару
    // Пара создается с фектори и только (соль, create2) - 
    // записываем ее адрес и токены которые входят в пару
    // 2. Пара создается только при добавлении ликвидности (токен1 и токен2)
    //    только тогда создается пара
    //    если пара уже есть то просто MINT
    //    если пары нет то create pair from factory
    //    и только потом mint
    // 3. Добавление ликвидности
    //    корень квадр с (токен1*токен2)
    //    Если ликвидность уже есть
    //     токен1* всего токенов ликвидности/резерв токена1 токен1* всего токенов ликвидности/резерв токена1
    //     вычисляем минимальную ликвидность
    //     токен1 -- резерв1
    //       x    -- всего-ликвидность
    //     x = токен1*всего-ликвидность/резерв токена 1
    //     Добавляем на адрес провайдера ликвидности amount of LP tokens (min (x1, x2)


    // Swap
    // 1. get out amount
    // токен1 - сумма
    // токен1 - 0.3% от токен1 = реально сколько мы посылаем на обмен
    // если 1000 = 997
    // резерв1 * резерв2 = k
    // (токен1 + резерв1) * (резерв2 - токен2(то что мы отдаем)) = резерв1*резерв2
    // токен2(то что мы отдаем) = резерв2*токен1/резерв1+токен1
    // (x+xd)*(y-yd) = x*y
    // x*y-x*yd+xd*y-xd*yd = x*y
    // xd*y-xd*yd = x*yd
    // xd*y = xd*yd+x*yd
    // xd*y = yd(xd+x)
    // yd=xd*y/xd+x  -- вычисляем сколько надо отдать при обмене
    // yd = amountOut
    // xd = amountIn
    // x = reserve0
    // y = reserve1

    // burn
    // 1. на пару перечисляються LP токены
    // 2. пара проверяет наличие LP токенов на балансе
    // 3. Пропорционально в зависимости сколько в процентном соотношении токенов (перечисленых ) от общего количества
    // перечисляются токены держателю LP токены
    // liquidity --- totalSupply
    // x         --- balance0
    // x = liquidity * balance0/ totalSupply
    // 4. перечисляем токены провайдеру ликвидности
    // 5. Burn tokens totalSupply -= liquidity, _balance[address(this)] -= liquidity;
    // 6. Update баланс записываем в резерв

    //при обменах ликвидности в монетах BNB, ETHER, TRX
    //1. Перечисляем ефиры на WETH токен
    // на роутер начисляется сума WETH.
    // 2. Все идет как обычно с обычными токенами НО вместо ETH -> WETH

    // Route defi
    // Route contract
    // addLiquidity
    // addLiquidityEth
    // swapTokensToExactToken
    // swapExactTokentoTokens

    // exchange 10 tokens
    // 1 - 2
    // 2 - 3
    // 3 - 7
    // 7 - 9
    // address[] memory path
    // [address2, address3, address7] = address7


}