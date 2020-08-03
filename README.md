<h1 align=center><code>Gas Saver</code></h1>

**Gas Saver** is a collection of smart contracts to save gas on Ethereum.

## How it works

It defines a modifier that you can use to wrap the methods where you want to save gas burning gas tokens.

It uses [Chi Gas tokens](https://medium.com/@1inch.exchange/everything-you-wanted-to-know-about-chi-gastoken-a1ba0ea55bf3)

## Usage

Simply add the modifier to the methods you want, specifying the `sponsor` that will pay part of the gas using Gas tokens. 

You have to approve your contract to spend Gas tokens on sponsor behalf (i.e. call `approve`)

Below an example

```
import "@emilianobonassi/gas-saver/ChiGasSaver.sol";

contract MyContract is ChiGasSaver {

...

function myExpensiveMethod()
    external
    saveGas(msg.sender)
    returns (bool) {
        ...
    }
...

}
```
