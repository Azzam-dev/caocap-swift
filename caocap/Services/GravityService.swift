//
//  GravityService.swift
//  caocap
//
//  Created by CAOCAP inc on 03/09/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation

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

    <title>Card</title>

    <script src="https://unpkg.com/vue@3.2.31/dist/vue.global.js"></script>

    <script type="module" src="https://cdn.jsdelivr.net/npm/@ionic/core/dist/ionic/ionic.esm.js"></script>
    <script nomodule src="https://cdn.jsdelivr.net/npm/@ionic/core/dist/ionic/ionic.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@ionic/core/css/ionic.bundle.css" />

    <style>
      :root {
        --ion-safe-area-top: 20px;
        --ion-safe-area-bottom: 22px;
      }
    </style>

  </head>
  <body>
    <div id="app">
        
    </div>

    <script>
        const app = Vue.createApp({
            data() {
             return {
               
             }
            }
        })
        app.mount("#app")
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
  </body>
</html>
"""
    
    init(atom: Atom) {
        
    }
    
    func makeblog() -> Atom? {
        return nil
    }
}
