//
//  RoseChartView.swift
//  RoseChart
//
//  Created by Christoph Pageler on 20.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


public class RoseChartView: UIView {

    internal var squareView = UIView()
    internal var scaleView = RoseChartScaleView()
    internal var barsView = RoseChartBarsView()
    internal var stampView = RoseChartStampView()
    internal var stampViewSizeConstraint = NSLayoutConstraint()

    public var scaleLineColors: [UIColor] = [.lightGray, .black] {
        didSet {
            updateScaleColors()
        }
    }

    public var scaleBackgroundColor: UIColor = .clear {
        didSet {
            updateScaleColors()
        }
    }

    public var barLineColor: UIColor = .blue {
        didSet {
            updateBarLineColors()
        }
    }

    public var stampSize: CGFloat = 0.5 {
        didSet {
            updateStampSizeConstraint()
        }
    }

    public var stampBackgroundColors: [UIColor] = [.blue, .red] {
        didSet {
            updateStampColors()
        }
    }

    public var stampLineColors: [UIColor] = [.red, .blue] {
        didSet {
            updateStampColors()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        // Square View
        squareView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(squareView)
        NSLayoutConstraint.activate([
            squareView.heightAnchor.constraint(equalTo: squareView.widthAnchor, multiplier: 1, constant: 0),
            squareView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 0, priority: .defaultLow),
            squareView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0, priority: .defaultLow),
            squareView.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: 0, priority: .defaultLow),
            squareView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0, priority: .defaultLow),

            squareView.centerXAnchor.constraint(equalTo: centerXAnchor),
            squareView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Scale View
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        squareView.addSubview(scaleView)
        NSLayoutConstraint.activate([
            scaleView.leftAnchor.constraint(equalTo: squareView.leftAnchor),
            scaleView.topAnchor.constraint(equalTo: squareView.topAnchor),
            scaleView.rightAnchor.constraint(equalTo: squareView.rightAnchor),
            scaleView.bottomAnchor.constraint(equalTo: squareView.bottomAnchor)
        ])
        updateScaleColors()
        scaleView.scaleSteps = [
            1.00,
            0.75,
            0.50,
            0.25
        ]

        // Bars View
        barsView.translatesAutoresizingMaskIntoConstraints = false
        squareView.addSubview(barsView)
        NSLayoutConstraint.activate([
            barsView.leftAnchor.constraint(equalTo: squareView.leftAnchor),
            barsView.topAnchor.constraint(equalTo: squareView.topAnchor),
            barsView.rightAnchor.constraint(equalTo: squareView.rightAnchor),
            barsView.bottomAnchor.constraint(equalTo: squareView.bottomAnchor)
        ])
        updateBarLineColors()

        // Stamp View
        stampView.translatesAutoresizingMaskIntoConstraints = false
        squareView.addSubview(stampView)

        NSLayoutConstraint.activate([
            stampView.centerXAnchor.constraint(equalTo: squareView.centerXAnchor),
            stampView.centerYAnchor.constraint(equalTo: squareView.centerYAnchor),
            stampView.heightAnchor.constraint(equalTo: stampView.widthAnchor)
        ])
        updateStampSizeConstraint()
        updateStampColors()
        stampView.stampLineIndicators = [
            StampLineIndicator(from: 0, to: 0.25, color: .red)
        ]
    }

    private func updateScaleColors() {
        scaleView.scaleLineColors = scaleLineColors
        scaleView.scaleBackgroundColor = scaleBackgroundColor
    }

    private func updateBarLineColors() {
        let max = 144
        var val = 0.40
        var inc = 0.025

        barsView.barItems = (0...max).map { i in
            val += inc
            if val >= 1 || val <= 0.4 {
                inc = inc * -1
            }
            if Int.random(in: 0...7) == 7 {
                inc = inc * -1
            }

            let p = Double(i) / Double(max)
            return BarItem(position: p, start: 0.25, end: val, color: barLineColor, width: 2.0)
        }
    }

    private func updateStampSizeConstraint() {
        stampViewSizeConstraint.isActive = false
        stampViewSizeConstraint = stampView.heightAnchor.constraint(equalTo: squareView.heightAnchor,
                                                                    multiplier: stampSize)
        stampViewSizeConstraint.isActive = true
    }

    private func updateStampColors() {
        stampView.stampBackgroundColors = stampBackgroundColors
        stampView.stampLineColors = stampLineColors
    }

}
