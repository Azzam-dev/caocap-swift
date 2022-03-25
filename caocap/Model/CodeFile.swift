//
//  CodeFile.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 22/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation

enum fileType: String {
    case load
    case update
    case draw
}

struct CodeFile {
    let type: fileType
    let code: String
}
