//
//  InternalExtensions.swift
//  RoseChart
//
//  Created by Christoph Pageler on 22.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


// MARK: - NSLayoutAnchor

internal extension NSLayoutAnchor {

    @objc func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>,
                          constant: CGFloat,
                          priority: UILayoutPriority) -> NSLayoutConstraint {
        let c = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        c.priority = priority
        return c
    }

}

// MARK: - CGFloat

internal extension CGFloat {

    func toRadians() -> CGFloat {
        return self * .pi / 180
    }

}

// MARK: - Double

internal extension Double {

    func toRadians() -> Double {
        return self * .pi / 180
    }

}
