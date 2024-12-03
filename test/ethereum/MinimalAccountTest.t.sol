// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {DeployMinimal} from "script/DeployMinimal.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract MinimalAccountTest is Test{
    MinimalAccount minimalAccount;
    HelperConfig helperConfig;
    ERC20Mock usdc;

    uint256 constant AMOUNT = 1e18;
    address randomUser = makeAddr("user");

    function setUp() public {
        DeployMinimal deployMinimal = new DeployMinimal();
        (minimalAccount,helperConfig) = deployMinimal.deployMinimalAccount();
        usdc = new ERC20Mock();
    }

    //USDC mint

    //msg.sender will be MinimalAccount
    //approve some amount
    //usdc contract from the entrypoint

     //Arrange
        //Act
        //Assert

    function testOwnerCanExecuteCommands() public {
        //Arrange
        assertEq(usdc.balanceOf(address(minimalAccount)),0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(minimalAccount),AMOUNT);
        //Act
        vm.prank(minimalAccount.owner());
        minimalAccount.execute(dest,value,functionData);
        //Assert
        assertEq(usdc.balanceOf(address(minimalAccount)),AMOUNT);
    }

    function testNonOwnerCannotExecuteCommands() public {
        //Arrange
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(minimalAccount),AMOUNT);
        //Act
        vm.startPrank(randomUser);
        vm.expectRevert(MinimalAccount.MinimalAccount__NotFromEntryPointOrOwner.selector);
        minimalAccount.execute(dest,value,functionData);
        vm.stopPrank();
    }
}