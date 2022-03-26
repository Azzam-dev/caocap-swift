//
//  LogicNodeService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation

class LogicNodeService {
    static let instance = LogicNodeService()
    
    let logicNodes = [
        LogicNode(type: .event, description: "some value did change", code: "", color: .systemGreen),
        LogicNode(type: .condition, description: "condition a value", code: "", color: .systemYellow),
        LogicNode(type: .action, description: "change a value", code: "", color: .systemBlue),
        LogicNode(type: .value, description: "a container for some value", code: "", color: .systemRed),
    ]
}
