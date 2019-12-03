//
//  RoseChartStampView.swift
//  RoseChart
//
//  Created by Christoph Pageler on 22.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


internal class RoseChartStampView: UIView {

    // MARK: - Internal Values

    internal var stampBackgroundColors: [UIColor] = [.blue, .red] {
        didSet {
            updateStampLayer()
        }
    }

    internal var stampLineIndicators: [StampLineIndicator] = [] {
        didSet {
            updateStampLineIndicatorLayers()
        }
    }

    internal var stampLineColors: [UIColor] = [.red, .blue] {
        didSet {
            updateStampLineLayer()
        }
    }

    // MARK: - Private Values

    private var stampMaskLayer = CAShapeLayer()
    private var stampShadowLayer = CAShapeLayer()
    private var stampGradientLayer = CAGradientLayer()

    private var stampLineGradientLayer = CAGradientLayer()
    private var stampLineMaskLayer = CAShapeLayer()

    private var stampLineIndicatorLayers: [StampLineIndicatorLayer] = []

    // MARK: - Init

    internal init() {
        super.init(frame: .zero)

        updateStampLayer()
        updateStampLineLayer()
        updateStampLineIndicatorLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        let fullFrame = CGRect(x: 0, y: 0, width: layer.frame.size.width, height: layer.frame.size.height)

        stampGradientLayer.frame = fullFrame

        stampMaskLayer.frame = fullFrame
        stampMaskLayer.path = UIBezierPath(ovalIn: fullFrame).cgPath

        stampShadowLayer.frame = fullFrame
        stampShadowLayer.path = UIBezierPath(ovalIn: fullFrame).cgPath

        stampLineGradientLayer.frame = fullFrame

        stampLineMaskLayer.frame = fullFrame
        let lineInset = (stampLineMaskLayer.lineWidth / 2.0) + stampLineMaskLayer.lineWidth
        let lineFrame = fullFrame.insetBy(dx: lineInset, dy: lineInset)
        let stampLinePath = UIBezierPath(ovalIn: lineFrame).cgPath
        stampLineMaskLayer.path = stampLinePath

        for stampLineIndicatorLayer in stampLineIndicatorLayers {
            let shapeLayer = stampLineIndicatorLayer.layer
            shapeLayer.frame = fullFrame
            shapeLayer.path = stampLinePath
        }
    }

    // MARK: - Updating Values

    private func updateStampLayer() {
        if stampShadowLayer.superlayer == nil {
            layer.addSublayer(stampShadowLayer)
        }
        if stampGradientLayer.superlayer == nil {
            layer.addSublayer(stampGradientLayer)
        }

        stampGradientLayer.colors = stampBackgroundColors.map { $0.cgColor }
        stampGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        stampGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        stampGradientLayer.mask = stampMaskLayer

        stampMaskLayer.fillColor = UIColor.black.cgColor

        stampShadowLayer.fillColor = UIColor.black.cgColor
        stampShadowLayer.shadowColor = UIColor.black.cgColor
        stampShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        stampShadowLayer.shadowRadius = 10
        stampShadowLayer.shadowOpacity = 1.0

        setNeedsLayout()
    }

    private func updateStampLineLayer() {
        if stampLineGradientLayer.superlayer == nil {
            layer.addSublayer(stampLineGradientLayer)
        }

        stampLineGradientLayer.colors = stampLineColors.map { $0.cgColor }
        stampLineGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        stampLineGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        stampLineGradientLayer.mask = stampLineMaskLayer

        stampLineMaskLayer.lineWidth = 5
        stampLineMaskLayer.strokeColor = UIColor.black.cgColor
        stampLineMaskLayer.fillColor = UIColor.clear.cgColor

        setNeedsLayout()
    }

    private func updateStampLineIndicatorLayers() {
        for stampLineIndicatorLayer in stampLineIndicatorLayers {
            stampLineIndicatorLayer.layer.removeFromSuperlayer()
        }

        stampLineIndicatorLayers = stampLineIndicators.map { stampLineIndicator in
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 5
            shapeLayer.strokeColor = stampLineIndicator.color.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineCap = .round
            shapeLayer.strokeStart = CGFloat(stampLineIndicator.from)
            shapeLayer.strokeEnd = CGFloat(stampLineIndicator.to)
            shapeLayer.transform = CATransform3DMakeRotation(CGFloat((-90.0).toRadians()), 0, 0, 1)
            layer.addSublayer(shapeLayer)

            return StampLineIndicatorLayer(layer: shapeLayer, stampLineIndicator: stampLineIndicator)
        }
        setNeedsLayout()
    }

}

// MARK: - StampLineIndicator

internal struct StampLineIndicator {

    let from: Double
    let to: Double
    let color: UIColor

}


private struct StampLineIndicatorLayer {

    let layer: CAShapeLayer
    let stampLineIndicator: StampLineIndicator

}
