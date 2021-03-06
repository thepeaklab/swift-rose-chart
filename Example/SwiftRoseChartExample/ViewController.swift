//
//  ViewController.swift
//  SwiftRoseChartExample
//
//  Created by Christoph Pageler on 20.11.19.
//  Copyright © 2019 the peak lab. gmbh & co. kg. All rights reserved.
//


import UIKit
import RoseChart


class ViewController: UIViewController {

    @IBOutlet var roseChartView: RoseChartView!

    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.04462639242, green: 0.2705356777, blue: 0.2626829743, alpha: 1)
        roseChartView.backgroundColor = .clear
        roseChartView.scaleLineColors = [#colorLiteral(red: 0.04103877395, green: 0.2470057905, blue: 0.243075639, alpha: 1), #colorLiteral(red: 0.05565260351, green: 0.3293524086, blue: 0.3175765276, alpha: 1)]
        roseChartView.scaleBackgroundColor = #colorLiteral(red: 0.03321847692, green: 0.2352537215, blue: 0.2234801054, alpha: 1)
        roseChartView.stampBackgroundColors = [#colorLiteral(red: 0.05096390098, green: 0.3567913771, blue: 0.348937571, alpha: 1), #colorLiteral(red: 0.03655336052, green: 0.2666195333, blue: 0.254845351, alpha: 1)]
        roseChartView.stampLineColors = [#colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1), #colorLiteral(red: 0.03595770895, green: 0.294064343, blue: 0.2822898328, alpha: 1)]

        generateRandomValues(animated: false)
    }

    @IBAction func actionSliderValueChanged(_ sender: UISlider) {
        sender.value = sender.value.rounded()
        roseChartView.highlightEntry(at: Int(sender.value))
    }

    @IBAction func actionButtonResetHighlightedEntryTouchUpInside(_ sender: Any) {
        roseChartView.resetHighlightedEntry()
    }

    private func generateRandomValues(animated: Bool) {
//        let max = Int.random(in: 130...144)
//        let max = 144
//        var val = 100.0
//        var inc = 10.0
//        let newBars = (0...max).map { i -> RoseChartBar in
//            val += inc
//            if val >= 1 || val <= 10 {
//                inc = inc * -1
//            }
//            if Int.random(in: 0...7) == 7 {
//                inc = inc * -1
//            }
//
//            return RoseChartBar(val, color:[#colorLiteral(red: 0.269954741, green: 0.999925673, blue: 0.9018553495, alpha: 1), #colorLiteral(red: 0.269954741, green: 0.999925673, blue: 0.9018553495, alpha: 1), #colorLiteral(red: 0.999925673, green: 0.269954741, blue: 0.269954741, alpha: 1)].randomElement()!)
//        }
//
//        if animated {
//            roseChartView.animateBars(newBars)
//        } else {
//            roseChartView.bars = newBars
//        }

        let newBars = [
            RoseChartBar(10, color: .red),
            RoseChartBar(20, color: .red),
            RoseChartBar(30, color: .red),
            RoseChartBar(40, color: .red),
            RoseChartBar(50, color: .red),
            RoseChartBar(60, color: .red),
            RoseChartBar(70, color: .red),
            RoseChartBar(80, color: .red),
            RoseChartBar(90, color: .red),
            RoseChartBar(100, color: .red)
        ]

        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = Float(newBars.count - 1)

        if animated {
            roseChartView.animateBars(newBars)
        } else {
            roseChartView.bars = newBars
        }

        let newLinePoints = [
            RoseChartLinePoint(10),
            RoseChartLinePoint(20),
            RoseChartLinePoint(30),
            RoseChartLinePoint(40),
            RoseChartLinePoint(50),
            RoseChartLinePoint(60),
            RoseChartLinePoint(70),
            RoseChartLinePoint(80),
            RoseChartLinePoint(90),
            RoseChartLinePoint(100)
        ]

        if animated {
            roseChartView.animateLines(newLinePoints)
        } else {
            roseChartView.linePoints = newLinePoints
        }

//        let stampIndicators = [
//            RoseChartStampIndicator(from: (0...10).randomElement()!, to: (20...30).randomElement()!, color: #colorLiteral(red: 0.999925673, green: 0.269954741, blue: 0.269954741, alpha: 1)),
//            RoseChartStampIndicator(from: (70...90).randomElement()!, to: (95...100).randomElement()!, color: #colorLiteral(red: 0.999925673, green: 0.269954741, blue: 0.269954741, alpha: 1)),
//        ]
//        if animated {
//            roseChartView.animateStampIndicators(stampIndicators)
//        } else {
//            roseChartView.stampIndicators = stampIndicators
//        }
    }

    @IBAction func actionAnimateRandomBars(_ sender: UIButton) {
        generateRandomValues(animated: true)
    }

}

