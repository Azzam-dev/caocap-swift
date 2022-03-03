//
//  O.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation


@objc(Factorial)
class Factorial : NSObject {

    var lua : Lua
    let ptrFname = strdup("factorial")

    @objc
    init(script: String) { // Objective-C: initWithScript
        lua = Lua()
        lua.setup()
        
        let funcName = strdup("sayHelloFromSwift")
        lua.register(factorialExternal, withName: funcName)
        free(funcName)

        let ptrScript = strdup(script)
        lua.script(ptrScript)
        free(ptrScript)

    }

    @objc
    func callFactorial(state: OpaquePointer? = nil,
                       value: lua_Number) -> lua_Number {
        // Objective-C: callFactorialWithState
        return lua.call(state,
                        methode: ptrFname,
                        value: value)
    }

    deinit {
        free(ptrFname)
        lua.destruct()
    }
}

