//
//  InternalExtensions.swift
//  RoseChart
//
//  Created by Christoph Pageler on 22.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


internal extension NSLayoutAnchor {

    @objc func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>,
                          constant: CGFloat,
                          priority: UILayoutPriority) -> NSLayoutConstraint {
        let c = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        c.priority = priority
        return c
    }

}

internal extension CGFloat {

    func toRadians() -> CGFloat {
        return self * .pi / 180
    }

}


internal extension Double {

    func toRadians() -> Double {
        return self * .pi / 180
    }

}
