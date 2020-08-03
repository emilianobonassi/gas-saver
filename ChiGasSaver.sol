pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IUniswapV2Exchange.sol";
import "./interfaces/IWETH.sol";


contract IFreeFromUpTo is IERC20 {
    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);
}


contract ChiGasSaver {

    using SafeMath for uint256;

    modifier saveGas(address payable sponsor) {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        _chiBurnOrSell(sponsor, (gasSpent + 14154) / 41947);
    }

    // Thanks to 1inch
    function _chiBurnOrSell(address payable sponsor, uint256 amount) internal {
        IWETH weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        IFreeFromUpTo chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);

        IUniswapV2Exchange exchange = IUniswapV2Exchange(0xa6f3ef841d371a82ca757FaD08efc0DeE2F1f5e2);
        uint256 sellRefund = UniswapV2ExchangeLib.getReturn(exchange, chi, weth, amount);
        uint256 burnRefund = amount.mul(18_000).mul(tx.gasprice);

        if (sellRefund < burnRefund.add(tx.gasprice.mul(36_000))) {
            chi.freeFromUpTo(sponsor, amount);
        }
        else {
            chi.transferFrom(sponsor, address(exchange), amount);
            exchange.swap(0, sellRefund, address(this), "");
            weth.withdraw(weth.balanceOf(address(this)));
            sponsor.transfer(address(this).balance);
        }
    }
}
