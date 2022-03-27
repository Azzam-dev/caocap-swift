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
    
    let logicNodes = [
        LogicNode(type: .event, description: "some value did change", content: [LogicNode](), icon: UIImage(systemName: "scribble")!),
        LogicNode(type: .condition, description: "condition a value", content: [LogicNode](), icon: UIImage(systemName: "scribble")!),
        LogicNode(type: .action, description: "change a value", content: [LogicNode](), icon: UIImage(systemName: "scribble")!),
        LogicNode(type: .value, description: "a container for some value", content: [LogicNode](), icon: UIImage(systemName: "scribble")!),
    ]
}
