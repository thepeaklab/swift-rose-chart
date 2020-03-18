//
//  RoseChartBarsView.swift
//  RoseChart
//
//  Created by Christoph Pageler on 22.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


internal class RoseChartBarsView: UIView {

    internal var barItems: [BarItem] = [] {
        didSet {
            updateBarItemLayers(animated: isInAnimation)
        }
    }

    private var barItemLayers: [BarItemLayer] = []

    private var isInAnimation: Bool = false

    // MARK: - Init

    internal init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func animateBarItems(_ barItems: [BarItem]) {
        isInAnimation = true
        self.barItems = barItems
        isInAnimation = false
    }

    private func updateBarItemLayers(animated: Bool) {
        let dropLayerCount = barItemLayers.count - barItems.count
        if dropLayerCount > 0 {
            let range = barItemLayers.index(barItemLayers.endIndex,
                                            offsetBy: -(dropLayerCount)) ..< barItemLayers.endIndex
            let remove = barItemLayers[range]
            remove.forEach({ $0.layer.removeFromSuperlayer() })
            barItemLayers.removeLast(dropLayerCount)
        }

        barItemLayers = barItems.enumerated().map { enumerated in
            let (index, barItem) = enumerated
            let shapeLayer: CAShapeLayer
            let isReused: Bool
            if let reusableShapeLayer = barItemLayers[safe: index]?.layer {
                shapeLayer = reusableShapeLayer
                isReused = true
            } else {
                shapeLayer = CAShapeLayer()
                isReused = false
            }

            shapeLayer.strokeColor = barItem.color.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineCap = .round
            shapeLayer.lineWidth = barItem.width
            shapeLayer.strokeStart = CGFloat(barItem.start)
            shapeLayer.strokeEnd = CGFloat(barItem.end)
            if !isReused {
                layer.addSublayer(shapeLayer)
            }

            return BarItemLayer(barItem: barItem, layer: shapeLayer)
        }

        setNeedsLayout()
    }

    

    override func layoutSubviews() {
        super.layoutSubviews()

        let totalWidth = layer.frame.size.width
        for barItemLayer in barItemLayers {
            let shapeLayer = barItemLayer.layer
            shapeLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)

            let innerPoint = CGPoint(x: totalWidth / 2.0, y: totalWidth / 2.0)
            let outerPoint = circlePoint(deg: CGFloat((360.0 * barItemLayer.barItem.position) - 90.0))
            let path = UIBezierPath()
            path.move(to: innerPoint)
            path.addLine(to: outerPoint)

            shapeLayer.path = path.cgPath
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


internal struct BarItem {

    let position: Double
    let start: Double
    let end: Double
    let color: UIColor
    let width: CGFloat

}


internal struct BarItemLayer {

    let barItem: BarItem
    let layer: CAShapeLayer

}


internal struct LineItem {

    let position: Double
    let value: Double

}
