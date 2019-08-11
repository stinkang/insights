//
//  RevenueViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/28/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import Charts
import UIKit

// viewController for revenue page
class RevenueViewController: UIViewController, InsightsViewModelDelegate, UIScrollViewDelegate, RevenueViewControllerDelegate, ChartViewDelegate {
    
    
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        print(startDate)
        print(endDate)
    }
    
    
    // ChartViewDelegate function to see which portion of revenueByLocationGraphView is highlighted. Then toggles the corresponding value into revenueByLocationValueLabel
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        revenueByLocationValueLabel.text = "$" + String(entry.y)
    }
    
    // RevenueViewControllerDelegate function. InsightsTabViewController calls this, then this view controller sets the totalRevenueGraphView accordingly.
    func dateStateChanged(dateState: Int) {
        self.dateState = dateState
        switch self.dateState {
        case 0:
            dayViewWasSelected()
        case 1:
            weekViewWasSelected()
        case 2:
            monthViewWasSelected()
        default:
            dayViewWasSelected()
        }
    }
    
    
    @IBOutlet weak var totalRevenueGraphView: LineChartView!
    @IBOutlet weak var revenueByLocationGraphView: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Maybe saving for future implementations
    //@IBOutlet weak var projectedRevenueGraphView: LineChartView!
    
    @IBOutlet weak var individualEventComparisonsGraphView: BarChartView!
    @IBOutlet weak var individualEventComparisonGraphSwitch: UISegmentedControl!
    @IBOutlet weak var revenueByLocationValueLabel: UILabel!
    
    private var prevOffset: Float = 0
    
    private var viewModel: InsightsViewModel!
    private var util = ChartUtils()
    private let currentUser = "test"
    var visibleIndexPath: IndexPath? = nil
    var startDate: Date!
    var endDate: Date!
    var dateState: Int!
    
    func dataChanged() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.viewModel = InsightsViewModel(currentUser: self.currentUser, delegate: self)
        
        dateStateChanged(dateState: dateState)
        
        setPrivateEventsComparisonsGraph()
        setRevenueByLocationGraph()
        revenueByLocationGraphView.delegate = self
        revenueByLocationValueLabel.text = ""
    }
    
    
    
    func setLineGraph(chart: LineChartView, values: [Double]) {
        chart.rightAxis.drawLabelsEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.axisLineColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.highlightPerTapEnabled = false
        chart.highlightPerDragEnabled = false
        chart.legend.textColor = .white
        chart.chartDescription?.text = ""
        chart.borderColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        
        // Adding each element of VALUES into a ChartDataEntry array to turn into a LineChartDataSet
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Dollars")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 4
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.4058836323, green: 1, blue: 0.6449512505, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.09044898074, green: 1, blue: 0.9353333129, alpha: 1)]
        chartDataSet.valueTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        let chartData = LineChartData(dataSets: [chartDataSet])
        chart.data = chartData
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func dayViewWasSelected() {
        //Setup the labels for the x axis
        let days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        let revenue =
            viewModel.getDailyRevenue()
        
        //Find the current day of the week
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        let dayOfWeek = util.getDayOfWeek(date)
        let startingDay = util.mod((dayOfWeek! - revenue.count), 7) - 1
        
        //Calculate the rest of the days of the week to display in the x axis
        var xAxis = [String]()
        for i in 0..<revenue.count {
            xAxis.append(days[util.mod(startingDay + i, 7)])
        }
        xAxis.append("Today")
        
        // Set the x axis to days of the week
        totalRevenueGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis)
        totalRevenueGraphView.xAxis.granularity = 1
        
        //Make it so you can only view 7 days at a time; it's scrollable
        totalRevenueGraphView.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 7 days first
        let lastSevenPoints = revenue.count - 7
        totalRevenueGraphView.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: totalRevenueGraphView, values: revenue)
        
    }
    
    func weekViewWasSelected() {
        let revenue = viewModel.getWeeklyRevenue()
        var today = Date()
        var thisWeek = today.getThisWeek()
        
        // Calculate week values
        var xAxis = [String]()
        for _ in 0..<revenue.count {
            xAxis.append(thisWeek)
            today = today.sevenDaysAgo()
            thisWeek = today.getThisWeek()
        }
        
        totalRevenueGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        totalRevenueGraphView.xAxis.granularity = 1
        
        //Make it so you can only view 7 days at a time; it's scrollable
        totalRevenueGraphView.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 7 days first
        let lastSevenPoints = revenue.count - 7
        totalRevenueGraphView.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: totalRevenueGraphView, values: revenue)
    }
    
    func monthViewWasSelected() {
        let revenue = viewModel.getMonthlyRevenue()
        var xAxis = [String]()
        var thisMonth = Date().getMonthNo() - 1
        for _ in 0..<revenue.count {
            if thisMonth >= 0 {
                xAxis.append(util.months[thisMonth])
                thisMonth -= 1
            } else {
                thisMonth = 11
                xAxis.append(util.months[thisMonth])
                thisMonth -= 1
            }
        }
        totalRevenueGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        totalRevenueGraphView.xAxis.granularity = 1
        //Make it so you can only view 7 days at a time; it's scrollable
        totalRevenueGraphView.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 2 months first
        let lastSevenPoints = revenue.count
        totalRevenueGraphView.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: totalRevenueGraphView, values: revenue)
    }
    
    func setRevenueByLocationGraph() {
    revenueByLocationGraphView.translatesAutoresizingMaskIntoConstraints = false
        revenueByLocationGraphView.chartDescription?.text = ""
        revenueByLocationGraphView.drawHoleEnabled = false
        revenueByLocationGraphView.legend.enabled = true
        revenueByLocationGraphView.legend.orientation = .vertical
        revenueByLocationGraphView.legend.textColor = .white
        revenueByLocationGraphView.drawEntryLabelsEnabled = false
        var dataEntries = [PieChartDataEntry]()
        for (key, val) in viewModel.getRevenueByLocation() {
            let entry = PieChartDataEntry(value: Double(val), label: String(key))
            dataEntries.append(entry)
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.5732106885, green: 1, blue: 0.84519483, alpha: 1),#colorLiteral(red: 0.509465854, green: 0.922074988, blue: 1, alpha: 1),#colorLiteral(red: 0.3274911169, green: 0.6634615801, blue: 1, alpha: 1),#colorLiteral(red: 0.2196151837, green: 0.3735224629, blue: 1, alpha: 1),#colorLiteral(red: 0.429325448, green: 0.1026686058, blue: 1, alpha: 1)]
        chartDataSet.sliceSpace = 2
        chartDataSet.selectionShift = 7
        chartDataSet.valueFont = UIFont(name: "HelveticaNeue", size: 9.0)!

        let chartData = PieChartData(dataSet: chartDataSet)
        
        revenueByLocationGraphView.data = chartData
        revenueByLocationGraphView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    
    func setPrivateEventsComparisonsGraph() {
        let events = viewModel.getPrivateEventRevenue().keys
        let revenue = Array(viewModel.getPrivateEventRevenue().values)
        var xAxis = [String]()
        for event in events {
            xAxis.append(event)
        }
        individualEventComparisonsGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        setIndividualEventComparisonsGraph(values: revenue)
    }
    
    func setPublicEventComparisonsGraph() {
        let events = viewModel.getPublicEventRevenue().keys
        let revenue = Array(viewModel.getPublicEventRevenue().values)
        var xAxis = [String]()
        for event in events {
            xAxis.append(event)
        }
        // Set the xAxis values
        individualEventComparisonsGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        setIndividualEventComparisonsGraph(values: revenue)
    }
    
    func setIndividualEventComparisonsGraph(values: [Double]) {
        individualEventComparisonGraphSwitch.tintColor = #colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1)
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Dollars")
        chartDataSet.valueTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.4058836323, green: 1, blue: 0.6449512505, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.09044898074, green: 1, blue: 0.9353333129, alpha: 1)]
        let chartData = BarChartData(dataSets: [chartDataSet])

        individualEventComparisonsGraphView.data = chartData
        individualEventComparisonsGraphView.rightAxis.enabled = false
        individualEventComparisonsGraphView.chartDescription?.text = ""
        individualEventComparisonsGraphView.xAxis.axisLineColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.xAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.xAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.leftAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.highlightPerDragEnabled = false
        individualEventComparisonsGraphView.highlightPerTapEnabled = false
        individualEventComparisonsGraphView.doubleTapToZoomEnabled = false
        individualEventComparisonsGraphView.legend.textColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.leftAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        individualEventComparisonsGraphView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        switch individualEventComparisonGraphSwitch.selectedSegmentIndex
        {
        case 0:
            setPrivateEventsComparisonsGraph()
        case 1:
            setPublicEventComparisonsGraph()
        default:
            break
        }
    }
    
    //Handle animations upon scrolling to them
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if (prevOffset < 250 || prevOffset > 500) && offset >= 250 {
            dateStateChanged(dateState: dateState)
        }
        if (prevOffset > 800 && offset >= 400) {
            setRevenueByLocationGraph()
        }
        prevOffset = Float(offset)
    }
}
