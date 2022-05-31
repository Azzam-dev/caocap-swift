//
//  GravityService.swift
//  caocap
//
//  Created by CAOCAP inc on 03/09/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import SwiftSoup

class UICaocap: UIView {
    
}

enum AtomType {
    case view
}

enum AtomAttributes {
    case color
}

struct Atom {
    let type: AtomType
    let attributes: [(key: AtomAttributes, value: Any)]?
    let children: [Atom]?
}


enum LogicType {
    case event
}

enum LogicAttributes {
    case script
}

struct Logic {
    let type: LogicType
    let attributes: [(key: LogicAttributes, value: Any)]?
    let children: [Logic]?
}

class GravityService {
    
    let caocapView: UICaocap
    
    init(atom: Atom?, logic: Logic?) {
        // build the caocap
        caocapView = UICaocap()
    }
    
    
}
