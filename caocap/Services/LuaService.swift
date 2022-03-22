//
//  LuaService.swift
//  caocap
//
//  Created by CAOCAP inc on 16/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//
//  Lua and Swift in iOS
//  1: https://www.larsgregori.de/2019/12/27/lua-and-swift-in-ios/
//  2: https://www.larsgregori.de/2019/12/29/factorial-calculation-with-lua-and-swift/
//  3: https://www.larsgregori.de/2019/12/30/recursive-calls-between-lua-and-swift/

import Foundation


@objc class LuaService: NSObject {
    static let instance = LuaService(script: "")
    
    var lua : Lua

    @objc
    init(script: String) { // Objective-C: initWithScript
        lua = Lua()
        lua.setup()
        
        let sayHelloFromSwiftFuncName = strdup("sayHelloFromSwift")
        lua.register(sayHelloFromSwift, withName: sayHelloFromSwiftFuncName)
        free(sayHelloFromSwiftFuncName)
        
        let changeBackgroundColorFuncName = strdup("changeBackgroundColor")
        lua.register(changeBackgroundColor, withName: changeBackgroundColorFuncName)
        free(changeBackgroundColorFuncName)
        

        let ptrScript = strdup(script)
        lua.script(ptrScript)
        free(ptrScript)

    }

    deinit {
        lua.destruct()
    }
    
    
}
