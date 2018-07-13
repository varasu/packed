pragma solidity ^ 0.4.9;

contract Packed {
    function sellbuyAsem() public onlyBots {
        // trade function
        bytes4 fh = 0x0a19b14a;
        // testTrade function
        // change to AmountFilled
        bytes4 fh_test = 0x46be96c3;
        address adr = dca;

        // in normal use sender is contract address
        //address sender = this;

        // sell order first
        assembly {
            let x: = mload(0x40)
            let out: = mload(0x40)
            mstore(x, fh_test) // func sig
            // start 80 tokenGive, skip 32 bytes
            calldatacopy(add(x, 56), 5, 12) // amountGet
            calldatacopy(add(x, 80), 77, 20) // tokenGive
            calldatacopy(add(x, 120), 17, 12) // amountGive
            calldatacopy(add(x, 156), 41, 8) // Expires
            calldatacopy(add(x, 188), 49, 8) // Nonce
            calldatacopy(add(x, 208), 57, 20) // User
            calldatacopy(add(x, 259), 4, 1) // V
            calldatacopy(add(x, 260), 97, 32) // R
            calldatacopy(add(x, 292), 129, 32) // S
            calldatacopy(add(x, 344), 29, 12) // amount
            //mstore(add(si, 356), sender) // sender for testTrade


            // testTrade on sell order
            let retTest: = staticcall(gas, adr, x, 324 // calldatasize
                , out // out
                , 32)

            let r: = mload(out)

            let _fam: = mload(0x40)
            calldatacopy(add(_fam, 20), 5, 12)
            let fam: = mload(_fam)

            // get amount, add +1
            let _amount: = mload(0x40)
            calldatacopy(add(_amount, 20), 29, 12)
            let amount: = mload(_amount)

            // stop execution and exit if testTrade is 0 => false
            // important: load value from out(memory) before check
            //let r := mload(out)
            let rest: = add(r, amount)

            if gt(rest, fam) {
                stop()
            }

            // next, do testTrade on buy

            mstore(add(x, 376), fh_test) // func sig
            calldatacopy(add(x, add(376, 16)), 234, 20) // tokenGet
            calldatacopy(add(x, add(376, 56)), 162, 12) // amountGet
            // start 80 tokenGive, skip 32 bytes
            calldatacopy(add(x, add(376, 120)), 174, 12) // amountGive
            calldatacopy(add(x, add(376, 156)), 198, 8) // Expires
            calldatacopy(add(x, add(376, 188)), 206, 8) // Nonce
            calldatacopy(add(x, add(376, 208)), 214, 20) // User
            calldatacopy(add(x, add(376, 259)), 161, 1) // V
            calldatacopy(add(x, add(376, 260)), 254, 32) // R
            calldatacopy(add(x, add(376, 292)), 286, 32) // S
            calldatacopy(add(x, add(376, 344)), 186, 12) // amount
            //mstore(add(bi, 356), sender) // 1sender for testTrade

            retTest: = staticcall(gas, adr, add(x, 376), 324 // calldatasize
                , out // out
                , 32)

            r: = mload(out)

            _fam: = mload(0x40)
            calldatacopy(add(_fam, 20), 162, 12)
            fam: = mload(_fam)

            // get amount, add +1
            _amount: = mload(0x40)
            calldatacopy(add(_amount, 20), 186, 12)
            amount: = mload(_amount)

            // stop execution and exit if testTrade is 0 => false
            // important: load value from out(memory) before check
            //let r := mload(out)
            rest: = add(r, amount)

            if gt(rest, fam) {
                stop()
            }

            // after two testTrades execute Trade Sell
            // change to trade() func hex
            mstore(x, fh)
            // trade()
            let retval: = call(gas, adr, 0, x, 356 // calldatasize
                , out // out
                , 32)

            // execute Trade Buy
            mstore(add(x, 376), fh) // func sig
            // buy order in second place
            calldatacopy(add(x, add(376, 16)), 234, 20) // tokenGet
            // trade()
            retval: = call(gas, adr, 0, add(x, 376), 356 // calldatasize
                , out // out
                , 32)

        }

    }

}
