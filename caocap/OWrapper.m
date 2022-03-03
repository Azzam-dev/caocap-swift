//
//  OWrapper.m
//  caocap
//
//  Created by Azzam AL-Rashed on 30/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OWrapper.h"
#import "CAOCAPx-Swift.h" // << ADJUST ME

Factorial * factorial;

int factorialExternal(lua_State *luaState) {
    if (factorial == Nil) {
        factorial = [[Factorial alloc] initWithScript: @""];
    }

    NSLog(@"Hello CAOCAP from swift");
    UInt64 n = lua_tointeger(luaState, -1L);
    lua_pop(luaState, 1);

//    lua_Number res = [factorial
//                      callFactorialWithState:luaState
//                      value:n];
//    lua_pushnumber(luaState, res);

    return 1;
}
