//
//  RoseChartView+Preview.swift
//  SwiftRoseChartExample
//
//  Created by Christoph Pageler on 02.12.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG

import SwiftUI
import RoseChart

@available(iOS 13.0, *)
internal struct RoseChartViewPreview: PreviewProvider, UIViewPreviewProvider {

    static let uiPreviews: [Preview] = {
        let roseChartEnercon = RoseChartView()

        roseChartEnercon.backgroundColor = #colorLiteral(red: 0.04462639242, green: 0.2705356777, blue: 0.2626829743, alpha: 1)
        roseChartEnercon.scaleLineColors = [#colorLiteral(red: 0.04103877395, green: 0.2470057905, blue: 0.243075639, alpha: 1), #colorLiteral(red: 0.05565260351, green: 0.3293524086, blue: 0.3175765276, alpha: 1)]
        roseChartEnercon.scaleBackgroundColor = #colorLiteral(red: 0.03321847692, green: 0.2352537215, blue: 0.2234801054, alpha: 1)
        roseChartEnercon.stampBackgroundColors = [#colorLiteral(red: 0.05096390098, green: 0.3567913771, blue: 0.348937571, alpha: 1), #colorLiteral(red: 0.03655336052, green: 0.2666195333, blue: 0.254845351, alpha: 1)]
        roseChartEnercon.stampLineColors = [#colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1), #colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1)]

        let max = 144
        var val = 0.40
        var inc = 0.025

        roseChartEnercon.bars = (0...max).map { i in
            val += inc
            if val >= 1 || val <= 0.4 {
                inc = inc * -1
            }
            if Int.random(in: 0...7) == 7 {
                inc = inc * -1
            }
            return RoseChartBar(val, color: #colorLiteral(red: 0.269954741, green: 0.999925673, blue: 0.9018553495, alpha: 1))
        }

        roseChartEnercon.linePoints = (0...max).map { i in
            val += inc
            if val >= 1 || val <= 0.4 {
                inc = inc * -1
            }
            if Int.random(in: 0...7) == 7 {
                inc = inc * -1
            }
            return RoseChartLinePoint(val)
        }

        let roseChartEnerconPreview = Preview(roseChartEnercon,
                                              size: .fixed(CGSize(width: 300, height: 350)),
                                              displayName: "ENERCON")


        let roseChart1 = RoseChartView()
        roseChart1.backgroundColor = .red
        roseChart1.scale = .values(values: [
            5,
            30,
            50
        ])
        roseChart1.isStampVisible = false
        roseChart1.bars = [
            RoseChartBar(5, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(10, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(25, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(20, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(25, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(30, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(35, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(40, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(45, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
            RoseChartBar(50, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        ]

        roseChart1.linePoints = [
            RoseChartLinePoint(5),
            RoseChartLinePoint(10),
            RoseChartLinePoint(15),
            RoseChartLinePoint(20),
            RoseChartLinePoint(25),
            RoseChartLinePoint(30),
            RoseChartLinePoint(35),
            RoseChartLinePoint(40),
            RoseChartLinePoint(45),
            RoseChartLinePoint(50)
        ]

        let roseChart1Preview = Preview(roseChart1,
                                        size: .fixed(CGSize(width: 300, height: 350)),
                                        displayName: "Rose Chart 1")

        let roseChartWithMovedValues = RoseChartView()
        roseChartWithMovedValues.bars = [
            RoseChartBar(10, color: .red),
            RoseChartBar(20, color: .red),
            RoseChartBar(30, color: .red),
            RoseChartBar(40, color: .red),
            RoseChartBar(50, color: .red),
            RoseChartBar(60, color: .red),
            RoseChartBar(70, color: .red),
            RoseChartBar(80, color: .red),
            RoseChartBar(90, color: .red),
            RoseChartBar(100, color: .red)
        ]
        let roseChartWithMovedValuesPreview = Preview(roseChartWithMovedValues,
                                                      size: .fixed(CGSize(width: 300, height: 350)),
                                                      displayName: "Rose Chart with moved values")

        return [roseChartEnerconPreview, roseChart1Preview, roseChartWithMovedValuesPreview]
    }()

}

#endif
