//
//  RoseChartBar.swift
//  RoseChart
//
//  Created by Christoph Pageler on 03.12.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


public struct RoseChartBar {

    public let value: Double
    public let color: UIColor

    public init(_ value: Double, color: UIColor) {
        self.value = value
        self.color = color
    }

}
