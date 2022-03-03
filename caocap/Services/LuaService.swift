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

class LuaService {
    static let instance = LuaService()
    
    func runLua(code: String) {
            let lua = Lua()
            lua.setup()
            
            let ptrScript = strdup(code)
            lua.script(ptrScript)
            free(ptrScript)

            lua.destruct()
    }
    
    
    func runFactorial(code: String) {
        let fac = Factorial(script: code)
        
    }
    
}
