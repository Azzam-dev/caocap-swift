//
//  GravityService.swift
//  caocap
//
//  Created by CAOCAP inc on 03/09/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation
import SwiftSoup

enum AtomType {
    case h1
    case h2
    case h3
    case h4
    case div
}

struct Atom {
    let type: AtomType
    let attributes: [String:String]?
    let children: [Atom]?
}

class GravityService {
    
    var htmlCode = """
<!DOCTYPE html>
<html lang="en">
  <head>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>caocap</title>

    <style>

    </style>

  </head>
  <body>
    <div>
        hello caocap
    </div>

    <script>
    </script>

  </body>
</html>
"""
    
    init(atom: Atom) {
        
    }
    
    
}
