//
//  RoseChartView.swift
//  RoseChart
//
//  Created by Christoph Pageler on 20.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit


@available(tvOS 12.0, *)
public class RoseChartView: UIView {

    // MARK: - Internal Values

    internal var squareView = UIView()
    internal var scaleView = RoseChartScaleView()
    internal var barsView = RoseChartBarsView()
    internal var linesView = RoseChartLineView()
    internal var stampView = RoseChartStampView()
    internal var stampViewSizeConstraint = NSLayoutConstraint()
    internal var ringIndicatorView = RoseChartRingIndicatorView()

    // MARK: - Scale Values

    public var scale: RoseChartScale = .automatic(count: 4) {
        didSet {
            updateScaleSteps()
        }
    }

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

    public var linePoints: [RoseChartLinePoint] = [] {
        didSet {
            updateLineItems(animated: isInAnimation)
        }
    }

    // MARK: - Bar Values

    public var bars: [RoseChartBar] = [] {
        didSet {
            updateBarItems(animated: isInAnimation)
        }
    }

    public var drawBarsOnStamp: Bool = true {
        didSet {
            updateBarItems(animated: isInAnimation)
        }
    }

    // TODO: Cache
    private var maxBarValue: Double { bars.map({ $0.value }).max() ?? 0 }

    // MARK: - Stamp Values

    public var isStampVisible: Bool = true {
        didSet {
            updateStampColors()
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

    public var stampIndicators: [RoseChartStampIndicator] = [] {
        didSet {
            updateStampIndicators(animated: isInAnimation)
        }
    }

    private var isInAnimation: Bool = false

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        // Ring Indicator View
        ringIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringIndicatorView)
        NSLayoutConstraint.activate([
            ringIndicatorView.heightAnchor.constraint(equalTo: ringIndicatorView.widthAnchor, multiplier: 1, constant: 0),
            ringIndicatorView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 0, priority: .defaultLow),
            ringIndicatorView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0, priority: .defaultLow),
            ringIndicatorView.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: 0, priority: .defaultLow),
            ringIndicatorView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0, priority: .defaultLow),
            ringIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ringIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Square View
        squareView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(squareView)
        NSLayoutConstraint.activate([
            squareView.heightAnchor.constraint(equalTo: squareView.widthAnchor, multiplier: 1, constant: 0),
            squareView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 10, priority: .defaultLow),
            squareView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10, priority: .defaultLow),
            squareView.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: -10, priority: .defaultLow),
            squareView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -10, priority: .defaultLow),

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
        updateScaleSteps()

        // Line View
        linesView.translatesAutoresizingMaskIntoConstraints = false
        squareView.addSubview(linesView)
        NSLayoutConstraint.activate([
            linesView.leftAnchor.constraint(equalTo: squareView.leftAnchor),
            linesView.topAnchor.constraint(equalTo: squareView.topAnchor),
            linesView.rightAnchor.constraint(equalTo: squareView.rightAnchor),
            linesView.bottomAnchor.constraint(equalTo: squareView.bottomAnchor)
        ])
        bringSubviewToFront(linesView)

        // Bars View
        barsView.translatesAutoresizingMaskIntoConstraints = false
        squareView.addSubview(barsView)
        NSLayoutConstraint.activate([
            barsView.leftAnchor.constraint(equalTo: squareView.leftAnchor),
            barsView.topAnchor.constraint(equalTo: squareView.topAnchor),
            barsView.rightAnchor.constraint(equalTo: squareView.rightAnchor),
            barsView.bottomAnchor.constraint(equalTo: squareView.bottomAnchor)
        ])

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
    }

    // MARK: - Updating Values

    private func updateScaleSteps() {
        switch scale {
        case .automatic(let count):
            scaleView.scaleSteps = (0...count).map { Double($0) / Double(count) }
        case .percentage(let steps):
            scaleView.scaleSteps = steps.map { max(min($0, 1), 0) }
            break
        case .values(let values):
            let max = maxBarValue
            guard max != 0 else {
                scaleView.scaleSteps = []
                return
            }
            scaleView.scaleSteps = values.map { $0 / max }
            break
        }
    }

    private func updateScaleColors() {
        scaleView.scaleLineColors = scaleLineColors
        scaleView.scaleBackgroundColor = scaleBackgroundColor
    }

    public func animateBars(_ bars: [RoseChartBar]) {
        isInAnimation = true
        self.bars = bars
        isInAnimation = false
    }

    private func updateBarItems(animated: Bool) {
        let barsCount = bars.count
        // skip update when there are no bars
        if barsCount == 0 && barsView.barItems.count == 0 { return }

        let min = drawBarsOnStamp && isStampVisible ? 0.5 : 0.0
        let max = 1.0

        let maxBarValue = self.maxBarValue
        let newBarItems = bars.enumerated().map { enumerated -> BarItem in
            let (index, bar) = enumerated

            let position = Double(index) / Double(barsCount)
            let calculatedValue = bar.value / maxBarValue
            let movedValueForStamp = calculatedValue * (max - min) + min

            return BarItem(position: position, start: min, end: movedValueForStamp, color: bar.color, width: 2.0)
        }

        if animated {
            barsView.animateBarItems(newBarItems)
        } else {
            barsView.barItems = newBarItems
        }

        // update scale if needed
        switch scale {
        case .values:
            updateScaleSteps()
        default:
            break
        }
    }

    public func animateLines(_ lines: [RoseChartLinePoint]) {
        isInAnimation = true
        self.linePoints = lines
        isInAnimation = false
    }

    private func updateLineItems(animated: Bool) {
        let min = drawBarsOnStamp && isStampVisible ? 0.5 : 0.0
        let max = 1.0

        let items = linePoints.enumerated().map { enumerated -> LineItem in
            let (index, line) = enumerated
            let position = Double(index) / Double(linePoints.count)
            let value = line.value / (linePoints.map({ $0.value }).max() ?? 0)
            let movedValueForStamp = value * (max - min) + min

            return LineItem(position: position, value: movedValueForStamp)
        }

        if animated {
            linesView.animateLineItems(items)
        } else {
            linesView.lineItems = items
        }
    }

    public func animateStampIndicators(_ stampIndicators: [RoseChartStampIndicator]) {
        isInAnimation = true
        self.stampIndicators = stampIndicators
        isInAnimation = false
    }

    private func updateStampIndicators(animated: Bool) {
        let barsCount = bars.count
        // skip update when there are no bars
        if barsCount == 0 && barsView.barItems.count == 0 { return }

        let stampLineIndicators = stampIndicators.map { indicator in
            return StampLineIndicator(from: Double(indicator.from) / Double(barsCount),
                                      to: Double(indicator.to) / Double(barsCount),
                                      color: indicator.color)
        }

        if animated {
            stampView.animateStampLineIndicators(stampLineIndicators)
        } else {
            stampView.stampLineIndicators = stampLineIndicators
        }
    }

    private func updateStampSizeConstraint() {
        stampViewSizeConstraint.isActive = false
        stampViewSizeConstraint = stampView.heightAnchor.constraint(equalTo: squareView.heightAnchor,
                                                                    multiplier: stampSize)
        stampViewSizeConstraint.isActive = true
    }

    private func updateStampColors() {
        stampView.isHidden = !isStampVisible
        if !isStampVisible { return } // skip updating other values when stamp is invisible
        stampView.stampBackgroundColors = stampBackgroundColors
        stampView.stampLineColors = stampLineColors
    }

    public func highlightEntry(atIndex index: Int) {
        barsView.highlightBarItem(atIndex: index)
        linesView.highlightItem(atIndex: index)
    }

}
