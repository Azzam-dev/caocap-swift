//
//  Block.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

enum BlocksType: String {
    case blank
}

struct Block {
    let type: BlocksType
    let description: String
    let styles: [String: BlockStyle]
    let icon: UIImage
}


enum BlockStyleType {
    case color
}

struct BlockStyle {
    let title: String
    let description: String
    let type: BlockStyleType
    let value: Any
}
