//
//  ChartUI.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 22/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ChartUI: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 25) {
                        MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "views")
                        
                        BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary")
                    }
                    
                    Spacer()
                    VStack(spacing: 25) {
                        LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "orbiting", legend: "Legendary")
                        BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
                        
                    }
                    
                    Spacer()

                }
                
                Spacer(minLength: 150)
                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen").padding()
                Spacer(minLength: 200)
                HStack {
                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly", form: ChartForm.small)
                    
                    PieChartView(data: [8,23,54,32], title: "Title", legend: "Legendary")
                }
            }.edgesIgnoringSafeArea([.bottom, .horizontal])
        }
    }
}

struct ChartUI_Previews: PreviewProvider {
    static var previews: some View {
        ChartUI()
    }
}
