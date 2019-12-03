//
//  RoseChartScale.swift
//  RoseChart
//
//  Created by Christoph Pageler on 03.12.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import Foundation


public enum RoseChartScale {

    case automatic(count: Int)
    case percentage(steps: [Double])
    case values(values: [Double])

}
