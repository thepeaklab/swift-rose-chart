//
//  RoseChartBackgroundView.swift
//  RoseChart
//
//  Created by Christoph Pageler on 20.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


@available(tvOS 12.0, *)
internal class RoseChartScaleView: UIView {

    // MARK: - Internal Values

    internal var scaleLineColors: [UIColor] = [.lightGray, .black] {
        didSet {
            updateScaleGradientLayer()
        }
    }

    internal var scaleLineWidth: CGFloat = 1.0 {
        didSet {
            updateScaleLayers()
        }
    }

    internal var scaleSteps: [Double] = [] {
        didSet {
            updateScaleLayers()
        }
    }

    internal var scaleBackgroundColor: UIColor = .clear {
        didSet {
            updateScaleBackgroundLayer()
        }
    }

    // MARK: - Private Values

    private var scaleStepLayers: [ScaleStepLayer] = []
    private var scaleStepLayersParent = CALayer()
    private var backgroundLayer = CAShapeLayer()
    private var scaleGradientLayer = CAGradientLayer()

    // MARK: - Init

    internal init() {
        super.init(frame: .zero)

        updateScaleBackgroundLayer()
        updateScaleGradientLayer()
        updateScaleLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update Scale Layers

    private func updateScaleLayers() {
        if scaleStepLayersParent.superlayer == nil {
            layer.addSublayer(scaleStepLayersParent)
        }

        for scaleStepLayer in scaleStepLayers {
            scaleStepLayer.layer.removeFromSuperlayer()
        }

        scaleStepLayers = scaleSteps.map { step in
            let scaleLayer = CAShapeLayer()
            scaleLayer.strokeColor = UIColor.black.cgColor
            scaleLayer.lineDashPattern = [3, 3]
            scaleLayer.lineCap = .round
            scaleLayer.fillColor = UIColor.clear.cgColor
            scaleLayer.lineWidth = scaleLineWidth
            scaleStepLayersParent.addSublayer(scaleLayer)
            return ScaleStepLayer(step: step, layer: scaleLayer)
        }
        setNeedsLayout()
    }

    private func updateScaleGradientLayer() {
        if scaleGradientLayer.superlayer == nil {
            layer.addSublayer(scaleGradientLayer)
        }
        scaleGradientLayer.type = .conic
        scaleGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        scaleGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        scaleGradientLayer.colors = scaleLineColors.map { $0.cgColor }
        scaleGradientLayer.transform = CATransform3DMakeRotation(CGFloat(180.0.toRadians()), 0, 0, 1.0)
        scaleGradientLayer.mask = scaleStepLayersParent

        layoutIfNeeded()
    }

    // MARK: - Update Scale Background Layer

    private func updateScaleBackgroundLayer() {
        if backgroundLayer.superlayer == nil {
            layer.addSublayer(backgroundLayer)
        }
        backgroundLayer.fillColor = scaleBackgroundColor.cgColor
        setNeedsLayout()
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        let totalWidth = layer.frame.size.width
        let availableWidth: CGFloat = totalWidth - scaleLineWidth

        // Background
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)
        backgroundLayer.path = UIBezierPath(ovalIn: backgroundLayer.frame).cgPath

        // Scale Lines
        scaleStepLayersParent.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)
        scaleGradientLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalWidth)
        for scaleStepLayer in scaleStepLayers {
            let scaleLayer = scaleStepLayer.layer
            let step = scaleStepLayer.step
            let scaleStepWidth = availableWidth * CGFloat(step)

            scaleLayer.frame = CGRect(x: (availableWidth / 2) - (scaleStepWidth / 2) + (scaleLineWidth / 2),
                                      y: (availableWidth / 2) - (scaleStepWidth / 2) + (scaleLineWidth / 2),
                                      width: scaleStepWidth,
                                      height: scaleStepWidth)
            scaleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0,
                                                          y: 0,
                                                          width: scaleStepWidth,
                                                          height: scaleStepWidth)).cgPath
        }

    }

}

internal struct ScaleStepLayer {

    let step: Double
    let layer: CAShapeLayer

}
