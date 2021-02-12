//
//  CircleImage.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        ZStack {
          Image("moon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100 , height: 100, alignment: .center)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(width: 100 , height: 100, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), lineWidth: 5))
        .shadow(radius: 3)
        .padding(10)
        .clipped()
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                CircleImage()
                Spacer()
            }
            Spacer()
        }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).edgesIgnoringSafeArea(.all)
    }
}
