//
//  LogicNode.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

enum LogicNodeType: String {
    case event
    case condition
    case flow
    case action
    case value
}

struct LogicNode {
    let type: LogicNodeType
    let title: String
    let description: String
    var content: [LogicNode]
}

