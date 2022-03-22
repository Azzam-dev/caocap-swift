//
//  OWrapper.h
//  caocap
//
//  Created by Azzam AL-Rashed on 30/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

#ifndef OWrapper_h
#define OWrapper_h

#include "lua.h"

int sayHelloFromSwift(lua_State *luaState);
int changeBackgroundColor(lua_State *luaState, NSString *hex);

#endif /* OWrapper_h */
