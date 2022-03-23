//
//  Template.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

enum TemplateType: String {
    case blank
}

struct Template {
    let type: TemplateType
    let description: String
    let code: String
    let icon: UIImage
}

