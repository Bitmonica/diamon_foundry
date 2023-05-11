// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondIncrementalFacetTest } from "../incremental.t.sol";
import {
    DiamondIncrementalBehavior,
    DiamondIncremental_turnImmutable_AlreadyImmutable
} from "src/facets/incremental/DiamondIncrementalBehavior.sol";
import { Ownable_checkOwner_NotOwner } from "src/facets/ownable/OwnableBehavior.sol";

contract DiamondIncremental_turnImmutable is DiamondIncrementalFacetTest {
    function test_RevertsWhen_CallerIsNotOwner() public {
        bytes4 selector = mockFacet.selectors()[0];
        changePrank(users.stranger);

        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));

        diamondIncremental.turnImmutable(selector);
    }

    function test_RevertsWhen_AlreadyImmutable() public {
        bytes4 selector = mockFacet.selectors()[0];
        diamondIncremental.turnImmutable(selector);

        vm.expectRevert(abi.encodeWithSelector(DiamondIncremental_turnImmutable_AlreadyImmutable.selector, selector));
        diamondIncremental.turnImmutable(selector);
    }

    function test_TurnsImmutable() public {
        bytes4 selector = mockFacet.selectors()[0];

        vm.expectEmit(diamond);
        emit SelectorTurnedImmutable(selector);

        diamondIncremental.turnImmutable(selector);

        assertTrue(diamondIncremental.isImmutable(selector));
    }
}
