pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IGST2.sol";


contract GST2GasSaver {

    using SafeMath for uint256;

    modifier saveGas(address payable sponsor) {
        uint256 gasStart = gasleft();
        _;

        // Refund, thanks Mounir from Paraswap
        uint256 MINT_BASE = 32254;
        uint256 MINT_TOKEN = 36543;
        uint256 FREE_BASE = 14154;
        uint256 FREE_TOKEN = 6870;
        uint256 REIMBURSE = 24000;

        uint256 mintPrice = 1000000000;

        uint256 tokens = gasStart.sub(gasleft()).add(FREE_BASE).div(REIMBURSE.mul(2).sub(FREE_TOKEN));

        uint256 mintCost = MINT_BASE.add(tokens.mul(MINT_TOKEN));
        uint256 freeCost = FREE_BASE.add(tokens.mul(FREE_TOKEN));
        uint256 maxreimburse = tokens.mul(REIMBURSE);

        uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
            mintCost.mul(mintPrice).add(freeCost.mul(tx.gasprice))
        );

        if (efficiency > 100) {
            uint256 tokensToFree = tokens;
            uint256 safeNumTokens = 0;
            uint256 gas = gasleft();

            if (gas >= 27710) {
                safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
            }

            if (tokensToFree > safeNumTokens) {
                tokensToFree = safeNumTokens;
            }

            IGST2 gasToken = IGST2(0x0000000000b3F879cb30FE243b4Dfee438691c04);

            uint256 gasTokenBal = gasToken.balanceOf(sponsor);

            if (tokensToFree > 0 && gasTokenBal >= tokensToFree) {
                gasToken.freeFromUpTo(sponsor, tokensToFree);
            }
        }
    }
}
