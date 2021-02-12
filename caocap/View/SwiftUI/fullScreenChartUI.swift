//
//   LineView.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 22/04/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct FullScreenChartUI: View {
    var body: some View {
        LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen").padding()
    }
}

struct FullScreenChartUI_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenChartUI()
    }
}
