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
    case title
    case image
    case video
}

struct Block {
    let type: BlocksType
    let description: String
    let styles: [BlockStyle]
    let icon: UIImage
}


enum BlockStyleType {
    case color
    case text
    case image
    case video
}

struct BlockStyle {
    let title: String
    let description: String
    let type: BlockStyleType
    let value: Any
}
