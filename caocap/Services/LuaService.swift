//
//  LuaService.swift
//  caocap
//
//  Created by CAOCAP inc on 16/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation

class LuaService {
    static let instance = LuaService()
    
    func runLua(code: String) {
            let lua = Lua()
            lua.setup()

            let luaScript = code
            
            let ptrScript = strdup(luaScript)
            lua.script(ptrScript)
            free(ptrScript)

            lua.destruct()
    }
}
