//
//  UIBezierPath+QuadCurve.swift
//  RoseChart
//
//  Created by Robert Feldhus on 18.03.20.
//  Copyright © 2020 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit.UIBezierPath


public extension UIBezierPath {

    convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else { return nil }

        self.init()

        var p1 = points[0]
        move(to: p1)

        if points.count == 2 {
            addLine(to: points[1])
        }

        for i in 0..<points.count {
            let mid = midPoint(p1: p1, p2: points[i])

            addQuadCurve(to: mid, controlPoint: controlPoint(p1: mid, p2: p1))
            addQuadCurve(to: points[i], controlPoint: controlPoint(p1: mid, p2: points[i]))

            p1 = points[i]
        }
    }

    private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)

        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }

}

