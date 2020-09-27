//
//  Shapes.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 21/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI

struct Shapes: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 200, height: 200)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.red)
                .frame(width: 200, height: 200)
            
            Capsule()
                .fill(Color.green)
                .frame(width: 100, height: 50)
            
            Ellipse()
                .fill(Color.blue)
                .frame(width: 100, height: 50)
            
            Circle()
                .fill(Color.yellow)
                .frame(width: 100, height: 50)
        }
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        Shapes()
    }
}
