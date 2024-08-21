//SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.26;

//Version: 1.1.0
//Compatibility: EVM Version >= Cancun
contract Factory {
    address constant _owner = ;

    bytes32 constant _loader = 0x6000600060046000335afa3d600060003e3d6000f30000000000000000000000;

    bytes private _bytecode; //slot0
    bytes32 constant _bytecodeExpandSlot = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;

    uint256 private _usingTSTORE; //slot1

    function deploy() external { //Deploy from calldata
        assembly {
            if sub(caller(), _owner) {
                mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
                mstore(0x24, 0x0000000000000000000000000000000000000000000000000000000000000011)
                mstore(0x44, 0x5045524d495353494f4e5f44454e494544000000000000000000000000000000) //PERMISSION_DENIED
                revert(0x00, 0x64)
            }
        }

        assembly {
            tstore(_usingTSTORE.slot, 1)
        }

        assembly {
            let length := sub(calldatasize(), 0x24)

            switch gt(length, 0x1f)
            case 1 { //length >= 32 bytes
                tstore(_bytecode.slot, add(mul(length, 2), 1)) //write length
                let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
                for { let i } lt(i, iter) { i := add(i, 0x01) } {
                    tstore(add(_bytecodeExpandSlot, i), calldataload(add(0x24, mul(0x20, i))))
                }
            }
            default { //length <= 31 bytes
                mstore(0x00, calldataload(0x24))
                mstore8(0x1f, mul(length, 2))
                tstore(_bytecode.slot, mload(0x00))
            }
        }

        assembly {
            mstore(0x00, _loader)

            let skipPOP := create2(
                0x00,
                0x00,
                0x15, //21 bytes
                calldataload(0x04) //salt
            )
        }
    }

    function initBytecode() external {
        assembly {
            if sub(caller(), _owner) {
                mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
                mstore(0x24, 0x0000000000000000000000000000000000000000000000000000000000000011)
                mstore(0x44, 0x5045524d495353494f4e5f44454e494544000000000000000000000000000000) //PERMISSION_DENIED
                revert(0x00, 0x64)
            }
        }

        assembly {
            let length := sub(calldatasize(), 0x04)

            switch gt(length, 0x1f)
            case 1 { //length >= 32 bytes
                sstore(_bytecode.slot, add(mul(length, 2), 1)) //write length
                let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
                for { let i } lt(i, iter) { i := add(i, 0x01) } {
                    sstore(add(_bytecodeExpandSlot, i), calldataload(add(0x04, mul(0x20, i))))
                }
            }
            default { //length <= 31 bytes
                mstore(0x00, calldataload(0x04))
                mstore8(0x1f, mul(length, 2))
                sstore(_bytecode.slot, mload(0x00))
            }
        }
    }
    function deploy(bytes32 salt) external { //Deploy from storage
        assembly {
            if sub(caller(), _owner) {
                mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
                mstore(0x24, 0x000000000000000000000000000000000000000000000000000000000000000e)
                mstore(0x44, 0x454d5054595f42595445434f4445000000000000000000000000000000000000) //PERMISSION_DENIED
                revert(0x00, 0x64)
            }
        }

        assembly {
            mstore(0x00, _loader)

            let skipPOP := create2(
                0x00,
                0x00,
                0x15, //21 bytes
                salt
            )
        }
    }

    function wycpnbqcyf() external view { //0x00000000
        assembly {
            switch tload(_usingTSTORE.slot) //usingTSTORE
            case 0 {
                let slotContent := sload(_bytecode.slot)
                switch mod(slotContent, 0x02)
                case 1 { //length >= 32 bytes
                    let length := div(sub(slotContent, 1), 2)
                    let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))

                    for { let i } lt(i, iter) { i := add(i, 0x01) } {
                        mstore(add(0x00, mul(i, 0x20)), sload(add(_bytecodeExpandSlot, i)))
                    }
                    return(0x00, length)
                }
                default { //length <= 31 bytes
                    mstore(0x00, shl(8, shr(8, slotContent))) //value
                    return(0x00, div(shr(248, shl(248, slotContent)), 2)) //length = slotContentLastByte / 2
                }
            }
            default {
                let slotContent := tload(_bytecode.slot)
                switch mod(slotContent, 0x02)
                case 1 { //length >= 32 bytes
                    let length := div(sub(slotContent, 1), 2)
                    let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))

                    for { let i } lt(i, iter) { i := add(i, 0x01) } {
                        mstore(add(0x00, mul(i, 0x20)), tload(add(_bytecodeExpandSlot, i)))
                    }
                    return(0x00, length)
                }
                default { //length <= 31 bytes
                    mstore(0x00, shl(8, shr(8, slotContent))) //value
                    return(0x00, div(shr(248, shl(248, slotContent)), 2)) //length = slotContentLastByte / 2
                }
            }
        }
    }
}

/*
    Loader: 0x6000600060046000335afa3d600060003e3d6000f3
    
    How it works:
        Static call 0x00000000 method of msg.sender to get bytecode:
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            60 04 => push 0x04 to stack
            60 00 => push 0x00 to stack
            33    => push CALLER to stack
            5a    => push GAS to stack
            fa    => STATICCALL

        Copy returned bytecode to memory:
            3d    => push RETURNDATASIZE to stack
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            3e    => RETURNDATACOPY

        Return bytecode from memory:
            3d    => push RETURNDATASIZE to stack
            60 00 => push 0x00 to stack
            f3    => RETURN
*/