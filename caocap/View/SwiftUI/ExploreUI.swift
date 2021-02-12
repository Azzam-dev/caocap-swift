//
//  ExploreUI.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 21/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI

struct ExploreUI: View {
    var body: some View {
        VStack {
            
            VStack {
                Text("CAOCAP")
                    .font(.title)
                    .foregroundColor(Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
                HStack {
                    Text("new social network for")
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0.1120058671, green: 0.2183442116, blue: 0.3097343743, alpha: 0.9)))
                    Text("interactive content")
                        .font(.callout)
                        .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
                }
            }

            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                            CircleImage()
                        }
                    }
                }
                
            }
            .shadow(radius: 10)
            
            Circle()
                .fill(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
                .frame(width: 65, height: 65)
                .overlay(
                    Circle()
                        .fill(Color(#colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)))
                        .frame(width:60, height: 60)
                        .overlay(
                            Circle()
                                .fill(Color(#colorLiteral(red: 0, green: 0.7525183558, blue: 0.999248445, alpha: 1)))
                                .frame(width:50, height: 50)
                    )
            )
                
                .padding()
            
        }
        .background(Color(#colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)))
        .edgesIgnoringSafeArea([.bottom , .horizontal])
    }
}

struct ExploreUI_Previews: PreviewProvider {
    static var previews: some View {
        ExploreUI()
    }
}
