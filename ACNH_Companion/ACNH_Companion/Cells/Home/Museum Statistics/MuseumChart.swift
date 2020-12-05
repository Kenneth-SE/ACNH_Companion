//
//  MuseumChart.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation
import Macaw

/// Bar graph summary of the collected critters
class MuseumChart: MacawView {
    
    static let donationStats = createStats()
    static let maxValue = 80
    
    static let maxValueLineHeight = 180
    static let lineWidth: Double = 275
    
    static var dataDivisor: [Double] = donationStats.map({ $0.maxDonations / Double(maxValueLineHeight) })
    static var adjustedData: [Double] = calculateAdjustedData(data: donationStats.map({ $0.donated }), maxData: dataDivisor)
    static var animations: [Animation] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(node: MuseumChart.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }

    static func createChart() -> Group {
        dataDivisor = donationStats.map({ $0.maxDonations / Double(maxValueLineHeight) })
        adjustedData = calculateAdjustedData(data: donationStats.map({ $0.donated }), maxData: dataDivisor)
        
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }

    private static func addYAxisItems() -> [Node] {
        let maxLines = 8
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = yAxisHeight/Double(maxLines)
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 1))
            let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: yAxisHeight, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 1))
        newNodes.append(yAxis)
        
        return newNodes
    }

    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = (Double(i) * 52)
            let valueText = Text(text: donationStats[i - 1].category, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 1))
        newNodes.append(xAxis)
        
        return newNodes
    }

    private static func createBars() -> Group {
        let fill = Color.lime
        let items = adjustedData.map { _ in Group() }
        
        animations = items.enumerated().map {(i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    private static func createStats() -> [DonationStatistic] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let databaseController = appDelegate.databaseController
        
        let bugsDonated = (databaseController?.fetchDonatedBugs().count)!
        let fishDonated = (databaseController?.fetchDonatedFish().count)!
        
        let maxBugs = (databaseController?.fetchAllBugs().count)!
        let maxFish = (databaseController?.fetchAllFish().count)!
        
        let bugStats = DonationStatistic(category: "Bugs", donated: Double(bugsDonated), maxDonations: Double(maxBugs))
        let fishStats = DonationStatistic(category: "Fish", donated: Double(fishDonated), maxDonations: Double(maxFish))
        
        print("Bugs donated: \(bugsDonated)")
        print("Fish donated: \(fishDonated)")
        print("Bug: \(maxBugs)")
        print("Fish: \(maxFish)")
        
        return [bugStats, fishStats]
    }
    
    private static func calculateAdjustedData(data: [Double], maxData: [Double]) -> [Double] {
        var adjustedData: [Double] = []
        var i = 0
        while i < maxData.count {
            adjustedData.append(data[i] / maxData[i])
            i += 1
        }
        return adjustedData
    }
        
}
