//
//  BuilderUI.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 18/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI

struct BuilderUI: View {
    
    @State var show = false
    
    @State public var selectedView = 0
    
    @State public var topTitle = "Text..."
    
    @State public var colorRed = 1.0
    @State public var colorGreen = 1.0
    @State public var colorBlue = 1.0
    
    @State public var showShadow = false
    @State public var heightCounter: CGFloat = 200
    @State public var widthCounter: CGFloat = 200
    
    var body: some View {
        ZStack {
            if selectedView == 0 {
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    ZStack {
                        Button(action: {
                            self.show.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color(red: self.colorRed , green: self.colorGreen , blue: self.colorBlue ))
                                .frame(width: self.widthCounter , height: self.heightCounter)
                                .shadow(radius: showShadow ? 5 : 0)
                        }
                        
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                
            } else if selectedView == 1 {
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    ZStack {
                        Button(action: {
                            self.show.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color(red: self.colorRed , green: self.colorGreen , blue: self.colorBlue ))
                                .frame(width: self.widthCounter , height: self.heightCounter)
                                .shadow(radius: showShadow ? 5 : 0)
                        }
                        
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).background(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                
            } else if selectedView == 2 {
                ChartUI()
            } else {
                ChartUI()
            }
            
            
            VStack {
                Spacer()
                CustomActionSheet(selectedView: $selectedView, topTitle: $topTitle, colorRed: $colorRed, colorGreen: $colorGreen, colorBlue: $colorBlue, showShadow: $showShadow, heightCounter: $heightCounter, widthCounter: $widthCounter).offset(y: self.show ? 0 : UIScreen.main.bounds.height)
            }
            .animation(.default)
        }.edgesIgnoringSafeArea(.all)
        
    }
    
}

struct BuilderUI_Previews: PreviewProvider {
    static var previews: some View {
        BuilderUI()
    }
}

struct CustomActionSheet: View {
    var mindMapButtonWidth = UIScreen.main.bounds.width / 2 - 40
    
    @State var show2 = false
    @State var show3 = false
    
    @Binding var selectedView: Int
    
    @Binding var topTitle: String
    
    @Binding var colorRed: Double
    @Binding var colorGreen: Double
    @Binding var colorBlue: Double
    
    @Binding var showShadow: Bool
    
    @Binding var heightCounter: CGFloat
    @Binding var widthCounter: CGFloat
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 30) {
                Button(action: {
                    print("undo was clicked")
                }) {
                    Image("undo").resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                Spacer()
                
                Button(action: {
                    self.selectedView = 0
                    print("UIBuilder button was clicked")
                }) {
                    Image("W-uncheck_all_filled").resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(self.selectedView == 0 ? #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                Button(action: {
                    self.selectedView = 1
                    print("mindMap button was clicked")
                }) {
                    Image("w-up-and-down" ).resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(self.selectedView == 1 ? #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                
                Button(action: {
                    self.selectedView = 2
                    print("analytics was clicked")
                }) {
                    Image("W-sorting_options").resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(self.selectedView == 2 ? #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                Button(action: {
                    self.selectedView = 3
                    print("undo was clicked")
                }) {
                    Image("w-launched_rocket").resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(self.selectedView == 3 ? #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                Spacer()
                
                Button(action: {
                    print("redo was clicked")
                }) {
                    Image("redo").resizable().frame(width: 25 , height: 25).scaledToFit()
                }.foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
                
                
                
                
            }
            
            if self.selectedView == 0 {
                TextField("Text...", text: $topTitle)
                
                Slider(value: self.$colorRed, in: 0...1 , step: 0.0001){
                    Text("Red")
                }
                
                Slider(value: self.$colorGreen, in: 0...1, step: 0.0001) {
                    Text("Green")
                }
                
                Slider(value: self.$colorBlue, in: 0...1, step: 0.0001) {
                    Text("Blue")
                }
                
                Toggle(isOn: self.$show2) {
                    Text("Spacer")
                        .foregroundColor(.white)
                }
                Toggle(isOn: self.$show3) {
                    Text("Padding")
                        .foregroundColor(.white)
                }
                Toggle(isOn: self.$showShadow) {
                    Text("Shadow")
                        .foregroundColor(.white)
                }
                
                Stepper(onIncrement: {
                    self.heightCounter += 1
                }, onDecrement: {
                    self.heightCounter -= 1
                }) {
                    HStack {
                        Text("Height").foregroundColor(.white)
                        Text("\(self.heightCounter)").foregroundColor(.white)
                    }
                }.foregroundColor(.white)
                
                Stepper(onIncrement: {
                    self.widthCounter += 1
                }, onDecrement: {
                    self.widthCounter -= 1
                }) {
                    HStack {
                        Text("Width").foregroundColor(.white)
                        Text("\(self.widthCounter)").foregroundColor(.white)
                    }
                }.foregroundColor(.white)
            } else {
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        Button(action: {
                            print("Functions was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Functions")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                        
                        Button(action: {
                            print("Conditions was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Conditions")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                        
                        Button(action: {
                            print("Loops was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Loops")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                    }
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            print("Variables was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Variables")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                        
                        Button(action: {
                            print("Operators was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Operators")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                        
                        Button(action: {
                            print("func was clicked")
                        }) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                                .frame(width: mindMapButtonWidth , height: mindMapButtonWidth / 2.5)
                                .overlay(
                                    Text("Identifiers")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            )
                        }
                    }
                }
            }
            
            
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 30)
            .padding(.horizontal)
            .padding(.top, 20)
            .background(Color(#colorLiteral(red: 0.1734654307, green: 0.2213912606, blue: 0.2679012716, alpha: 0.8)))
            .cornerRadius(25)
            .shadow(radius: 10)
        
    }
}
