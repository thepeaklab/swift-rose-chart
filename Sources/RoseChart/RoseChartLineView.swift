//
//  RoseChartLineView.swift
//  RoseChart
//
//  Created by Robert Feldhus on 18.03.20.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


class RoseChartLineView: UIView {

    internal var lineItems: [LineItem] = [] {
        didSet {
            updateLineItemLayers()
        }
    }

    private var lineItemLayers: [LineItemLayer] = []
    private var lineLayer: CAShapeLayer?
    private var lineLayerMask: CAShapeLayer?
    private var maskedLayer: CAGradientLayer?
    private var highlightedLayer: CAShapeLayer?

    private var isInAnimation: Bool = false

    public var animationDuration: TimeInterval = 0.6

    internal init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func animateLineItems(_ lineItems: [LineItem]) {
        isInAnimation = true
        self.lineItems = lineItems
    }

    public func highlightItem(at index: Int) {
        let itemToBeHighlighted = lineItemLayers[safe: index]

        guard let point = itemToBeHighlighted?.point else { return }
        let circlePath = UIBezierPath(arcCenter: point,
                                      radius: CGFloat(1),
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        highlightedLayer?.path = circlePath.cgPath
    }

    public func resetHighlightedLineItem() {
        highlightedLayer?.path = nil
    }

    private func updateLineItemLayers() {
        lineLayer?.removeFromSuperlayer()
        lineLayerMask?.removeFromSuperlayer()
        maskedLayer?.removeFromSuperlayer()
        highlightedLayer?.removeFromSuperlayer()

        if lineItems.count > 0 {
            let newLineLayer = CAShapeLayer()
            newLineLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2462431694).cgColor
            newLineLayer.fillColor = UIColor.clear.cgColor
            newLineLayer.lineWidth = 2
            newLineLayer.lineCap = .round
            lineLayer = newLineLayer
            layer.addSublayer(newLineLayer)

            let newLineLayerMask = CAShapeLayer()
            lineLayerMask = newLineLayerMask

            let maskedLayer = CAGradientLayer()
            maskedLayer.colors = [
                UIColor.white.withAlphaComponent(0.05).cgColor,
                UIColor.white.withAlphaComponent(0.15).cgColor,
                UIColor.white.withAlphaComponent(0.25).cgColor
            ]

            maskedLayer.type = .radial
            maskedLayer.locations = [0, 1]
            maskedLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            maskedLayer.endPoint = CGPoint(x: 1, y: 1)
            maskedLayer.mask = lineLayerMask
            layer.addSublayer(maskedLayer)

            self.maskedLayer = maskedLayer

            let highlightedLayer = CAShapeLayer()
            highlightedLayer.fillColor = UIColor.white.cgColor
            highlightedLayer.strokeColor = UIColor.white.cgColor
            highlightedLayer.lineWidth = 3.0
            layer.addSublayer(highlightedLayer)

            self.highlightedLayer = highlightedLayer
         }
        

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let lineLayer = lineLayer, lineItems.count > 0 else { return }

        lineItemLayers = lineItems.enumerated().map { lineItem in
            let totalWidth = layer.frame.size.width
            let radius = (totalWidth / 2.0) * CGFloat(lineItem.element.value)
            let angleInRadians = CGFloat((360.0 * lineItem.element.position) - 90.0).toRadians()
            let circleCenter = CGPoint(x: layer.frame.size.width / 2.0,
                                       y: layer.frame.size.height / 2.0)

            let point = CGPoint(x: radius * cos(angleInRadians) + circleCenter.x,
                                y: radius * sin(angleInRadians) + circleCenter.y)

            return LineItemLayer(lineItem: lineItem.element, point: point)
        }

        let points = lineItemLayers.compactMap({ $0.point })
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

        if isInAnimation {
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            strokeAnimation.duration = animationDuration
            strokeAnimation.fromValue = 0
            strokeAnimation.toValue = 1

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            scaleAnimation.duration = animationDuration
            scaleAnimation.fromValue = 0
            scaleAnimation.toValue = 1

            lineLayer.add(strokeAnimation, forKey: "strokeAnimation")
            lineLayer.add(scaleAnimation, forKey: "scaleAnimation")
            maskedLayer?.add(scaleAnimation, forKey: "scaleAnimation")
        } else {
            lineLayer.removeAllAnimations()
        }

        isInAnimation = false
    }

}


internal struct LineItemLayer {

    let lineItem: LineItem
    let point: CGPoint

}
