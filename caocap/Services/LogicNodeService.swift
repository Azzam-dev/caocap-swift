//
//  LogicNodeService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class LogicNodeService {
    static let instance = LogicNodeService()
    
    
    
    struct logicNodes {
        static let events = [
            LogicNode(type: .event, title: "Blank", description: "some value did change", content: [LogicNode]()),
        ]
        
        static let conditions = [
            LogicNode(type: .condition, title: "Blank", description: "condition a value", content: [LogicNode]()),
        ]
        
        static let flows = [
            LogicNode(type: .flow, title: "Blank", description: "Control the flow of the program", content: [LogicNode]()),
        ]
        
        static let actions = [
            LogicNode(type: .action, title: "Blank", description: "change a value", content: [LogicNode]()),
        ]
        
        static let values = [
            LogicNode(type: .value, title: "Blank", description: "a container for some value", content: [LogicNode]()),
        ]
    }
}
