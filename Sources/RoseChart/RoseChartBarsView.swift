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

    internal var lineItems: [LineItem] = [] {
        didSet {
            updateLineItemLayers(animated: isInAnimation)
        }
    }

    private var lineLayer: CAShapeLayer?
    private var lineLayerMask: CAShapeLayer?
    private var maskedLayer: CAGradientLayer?

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

    private func updateLineItemLayers(animated: Bool) {
        lineLayer?.removeFromSuperlayer()

        if lineItems.count > 0 {
             let newLineLayer = CAShapeLayer()
             newLineLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
             newLineLayer.fillColor = UIColor.clear.cgColor
             newLineLayer.lineWidth = 2
             newLineLayer.lineCap = .round
             lineLayer = newLineLayer
             layer.addSublayer(newLineLayer)

             let newLineLayerMask = CAShapeLayer()
             lineLayerMask = newLineLayerMask

             let maskedLayer = CAGradientLayer()
             maskedLayer.colors = [
                 UIColor.white.withAlphaComponent(0.1).cgColor,
                 UIColor.white.withAlphaComponent(0.3).cgColor
             ]

            maskedLayer.type = .radial
            maskedLayer.locations = [0, 1]
            maskedLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
             maskedLayer.endPoint = CGPoint(x: 1, y: 1)
             maskedLayer.mask = lineLayerMask
             layer.addSublayer(maskedLayer)

             self.maskedLayer = maskedLayer
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

        // MARK: - LineLayers

        if let lineLayer = lineLayer, lineItems.count > 0 {
            let maxLineValue = lineItems.map { $0.value }.max() ?? 0

            let points: [CGPoint] = lineItems.enumerated().map { lineItem in
                let totalWidth = layer.frame.size.width
                let radius = (totalWidth / 2.0) * CGFloat(lineItem.element.value)
                let angleInRadians = CGFloat((360.0 * lineItem.element.position) - 90.0).toRadians()
                let circleCenter = CGPoint(x: layer.frame.size.width / 2.0,
                                           y: layer.frame.size.height / 2.0)

                return CGPoint(x: radius * cos(angleInRadians) + circleCenter.x,
                               y: radius * sin(angleInRadians) + circleCenter.y)
            }

            print(points)

            let path = UIBezierPath(quadCurve: points)
            lineLayer.path = path?.cgPath
            lineLayer.frame = layer.bounds

            if let linePath = UIBezierPath(quadCurve: points), let firstPoint = points.first {
                linePath.addLine(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
                
                lineLayerMask?.frame = layer.bounds
                lineLayerMask?.path = linePath.cgPath
                maskedLayer?.bounds = linePath.bounds
                maskedLayer?.frame = linePath.bounds
            }
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
