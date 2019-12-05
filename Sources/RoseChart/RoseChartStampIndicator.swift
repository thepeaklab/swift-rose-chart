//
//  RoseChartStampIndicator.swift
//  RoseChart
//
//  Created by Christoph Pageler on 05.12.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


public struct RoseChartStampIndicator {

    public let from: Int
    public let to: Int
    public let color: UIColor

    public init(from: Int, to: Int, color: UIColor) {
        self.from = from
        self.to = to
        self.color = color
    }

}
