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
    
    func runLuaCode() {
        let filename = Bundle.main.path(forResource: "script",
                                        ofType: "lua")!
        do {
            let lua = Lua()
            lua.setup()

            let luaScript = try String(contentsOfFile: filename)
            let ptrScript = strdup(luaScript)
            lua.script(ptrScript)
            free(ptrScript)

            lua.destruct()
        } catch let error {
            print("can not read file", filename, error)
        }
    }
}
