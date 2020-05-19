//
//  RoseChartRingIndicatorView.swift
//  RoseChart
//
//  Created by Robert Feldhus on 18.05.20.
//  Copyright © 2020 the peak lab. gmbh & co. kg. All rights reserved.
//

import UIKit

internal class RoseChartRingIndicatorView: UIView {

    private var longDegreeIndicatorEntries: [CGFloat] = [0.0, 90.0, 180.0, 270.0]
    private var longLayers: [CAShapeLayer] = []

    private var shortDegreeIndicatorEntries: [CGFloat] = [30.0, 60.0, 120.0, 150.0, 210.0, 240.0, 300.0, 330.0]
    private var shortLayers: [CAShapeLayer] = []

    public var indicatorColor: UIColor = UIColor(red: 17/255, green: 97/255, blue: 98/255, alpha: 1.0)

    // MARK: - Init

    internal init() {
        super.init(frame: .zero)

        updateIndicatorLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateIndicatorLayers() {
        longLayers = longDegreeIndicatorEntries.map { _ in
            let indicatorLayer = CAShapeLayer()

            indicatorLayer.strokeColor = indicatorColor.cgColor
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.lineCap = .round
            indicatorLayer.lineWidth = 2
            indicatorLayer.strokeStart = 0.95
            indicatorLayer.strokeEnd = 1.0

            layer.addSublayer(indicatorLayer)

            return indicatorLayer
        }

        shortLayers = shortDegreeIndicatorEntries.map { _ in
            let indicatorLayer = CAShapeLayer()

            indicatorLayer.strokeColor = indicatorColor.cgColor
            indicatorLayer.fillColor = UIColor.clear.cgColor
            indicatorLayer.lineCap = .round
            indicatorLayer.lineWidth = 2
            indicatorLayer.strokeStart = 0.95
            indicatorLayer.strokeEnd = 0.975

            layer.addSublayer(indicatorLayer)

            return indicatorLayer
        }

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let totalWidth = layer.frame.size.width
        for (index, indicatorLayer) in longLayers.enumerated() {
            indicatorLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)
            let innerPoint = CGPoint(x: totalWidth / 2.0, y: totalWidth / 2.0)
            let outerPoint = circlePoint(deg: longDegreeIndicatorEntries[index] - 90.0)
            let path = UIBezierPath()

            path.move(to: innerPoint)
            path.addLine(to: outerPoint)

            indicatorLayer.path = path.cgPath
        }

        for (index, indicatorLayer) in shortLayers.enumerated() {
            indicatorLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)
            let innerPoint = CGPoint(x: totalWidth / 2.0, y: totalWidth / 2.0)
            let outerPoint = circlePoint(deg: shortDegreeIndicatorEntries[index] - 90.0)
            let path = UIBezierPath()

            path.move(to: innerPoint)
            path.addLine(to: outerPoint)

            indicatorLayer.path = path.cgPath
        }
    }

    private func circlePoint(deg: CGFloat) -> CGPoint {
        let totalWidth = layer.frame.size.width
        let radius = totalWidth / 2.0
        let angleInRadians = deg.toRadians()
        let circleCenter = CGPoint(x: layer.frame.size.width / 2.0,
                                   y: layer.frame.size.height / 2.0)

        return CGPoint(x: radius * cos(angleInRadians) + circleCenter.x,
                       y: radius * sin(angleInRadians) + circleCenter.y)
    }

}

