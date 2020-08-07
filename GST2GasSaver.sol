pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IGST2.sol";


contract GST2GasSaver {

    using SafeMath for uint256;

    modifier saveGas(address payable sponsor) {
        uint256 gasStart = gasleft();
        _;

        // Refund, thanks Mounir from Paraswap
        uint256 tokens = gasStart.sub(gasleft()).add(14154).div(uint256(24000).mul(2).sub(6870));

        uint256 mintCost = (tokens.mul(36543)).add(32254);
        uint256 freeCost = (tokens.mul(6870)).add(14154);
        uint256 maxreimburse = tokens.mul(24000);

        uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
            mintCost.mul(1000000000).add(freeCost.mul(tx.gasprice))
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

            if (tokensToFree > 0 && gasToken.balanceOf(sponsor) >= tokensToFree) {
                gasToken.freeFromUpTo(sponsor, tokensToFree);
            }
        }
    }
}
