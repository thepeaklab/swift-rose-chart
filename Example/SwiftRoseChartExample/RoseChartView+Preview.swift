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
        roseChartEnercon.barLineColor = #colorLiteral(red: 0.269954741, green: 0.999925673, blue: 0.9018553495, alpha: 1)
        roseChartEnercon.stampBackgroundColors = [#colorLiteral(red: 0.05096390098, green: 0.3567913771, blue: 0.348937571, alpha: 1), #colorLiteral(red: 0.03655336052, green: 0.2666195333, blue: 0.254845351, alpha: 1)]
        roseChartEnercon.stampLineColors = [#colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1), #colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1)]

        let roseChartEnerconPreview = Preview(roseChartEnercon,
                                              size: .fixed(CGSize(width: 300, height: 350)),
                                              displayName: "ENERCON")

        let roseChart1 = RoseChartView()
        let roseChart1Preview = Preview(roseChart1,
                                        size: .fixed(CGSize(width: 300, height: 350)),
                                        displayName: "Rose Chart 1")

        return [roseChartEnerconPreview, roseChart1Preview]
    }()

}

#endif
