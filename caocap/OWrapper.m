//
//  OWrapper.m
//  caocap
//
//  Created by Azzam AL-Rashed on 30/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OWrapper.h"
#import "CAOCAPx-Swift.h"

LuaService * luaService;

int sayHelloFromSwift(lua_State *luaState) {
    if (luaService == Nil) {
        luaService = [[LuaService alloc] initWithScript: @""];
    }

    OService * obj = [[OService alloc] init];
    [obj sayHelloFromSwift];
    
    return 1;
}
