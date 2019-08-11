//
//  LeadsViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/28/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit
import Charts

class LeadsViewController: UIViewController, UIScrollViewDelegate, InsightsViewModelDelegate, LeadsViewControllerDelegate {
    
    // LeadsViewController delegate funciton called by InsightsTabViewController
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    func dateStateChanged(dateState: Int) {
        // LeadsViewController delegate function called by InsightsTabViewController
        switch dateState {
        case 0:
            dayViewWasSelected(chart: storefrontVisitorsLineChartView, values: viewModel.getDailyStorefrontVisitors(), label: "Visitors")
            dayViewWasSelected(chart: numberOfUsersWhoSharedYourStorefrontLineChartView, values: viewModel.getDailyStorefrontSharers(), label: "Users")
            dayViewWasSelected(chart: numberOfUsersWhoBookmarkedYourStorefrontLineChartView, values: viewModel.getDailyStorefrontBookmarkers(), label: "Bookmarks")
            dayViewWasSelected(chart: appearedInSearchLineChartView, values: viewModel.getDailySearchHits(), label: "Search Hits")
            dayViewWasSelected(chart: numberOfUsersWhoBookmarkedYourEventLineChartView, values: viewModel.getDailyEventBookmarkers(), label: "Bookmarks")
            dayViewWasSelected(chart: numberOfStorefrontVisitorsConvertedToPayingCustomersLineChartView, values: viewModel.getDailyConverted(), label: "Converted Users")
        case 1:
            weekViewWasSelected(chart: storefrontVisitorsLineChartView, values: viewModel.getWeeklyStorefrontVisitors(), label: "Visitors")
            weekViewWasSelected(chart: numberOfUsersWhoSharedYourStorefrontLineChartView, values: viewModel.getWeeklyStorefrontSharers(), label: "Users")
            weekViewWasSelected(chart: numberOfUsersWhoBookmarkedYourStorefrontLineChartView, values: viewModel.getWeeklyStorefrontBookmarkers(), label: "Bookmarks")
            weekViewWasSelected(chart: appearedInSearchLineChartView, values: viewModel.getWeeklySearchHits(), label: "Search Hits")
            weekViewWasSelected(chart: numberOfUsersWhoBookmarkedYourEventLineChartView, values: viewModel.getWeeklyEventBookmarkers(), label: "Bookmarks")
            weekViewWasSelected(chart: numberOfStorefrontVisitorsConvertedToPayingCustomersLineChartView, values: viewModel.getWeeklyConverted(), label: "Converted Users")
        case 2:
            monthViewWasSelected(chart: storefrontVisitorsLineChartView, values: viewModel.getMonthlyStorefrontVisitors(), label: "Visitors")
            monthViewWasSelected(chart: numberOfUsersWhoSharedYourStorefrontLineChartView, values: viewModel.getMonthlyStoreFrontSharers(), label: "Users")
            monthViewWasSelected(chart: numberOfUsersWhoBookmarkedYourStorefrontLineChartView, values: viewModel.getMonthlyStoreFrontBookmarkers(), label: "Bookmarks")
            monthViewWasSelected(chart: appearedInSearchLineChartView, values: viewModel.getMonthlySearchHits(), label: "Search Hits")
            monthViewWasSelected(chart: numberOfUsersWhoBookmarkedYourEventLineChartView, values: viewModel.getMonthlyEventBookmarkers(), label: "Bookmarks")
            monthViewWasSelected(chart: numberOfStorefrontVisitorsConvertedToPayingCustomersLineChartView, values: viewModel.getMonthlyConverted(), label: "Converted Users")
        default:
            weekViewWasSelected(chart: storefrontVisitorsLineChartView, values: viewModel.getWeeklyStorefrontVisitors(), label: "Visitors")
            weekViewWasSelected(chart: numberOfUsersWhoSharedYourStorefrontLineChartView, values: viewModel.getWeeklyStorefrontSharers(), label: "Users")
            weekViewWasSelected(chart: numberOfUsersWhoBookmarkedYourStorefrontLineChartView, values: viewModel.getWeeklyStorefrontBookmarkers(), label: "Bookmarks")
            weekViewWasSelected(chart: appearedInSearchLineChartView, values: viewModel.getWeeklySearchHits(), label: "Search Hits")
            weekViewWasSelected(chart: numberOfUsersWhoBookmarkedYourEventLineChartView, values: viewModel.getWeeklyEventBookmarkers(), label: "Bookmarks")
            weekViewWasSelected(chart: numberOfStorefrontVisitorsConvertedToPayingCustomersLineChartView, values: viewModel.getWeeklyConverted(), label: "Converted Users")
        }
    }
    
    var dateState: Int!
    
    @IBOutlet weak var storefrontVisitorsLineChartView: LineChartView!
    @IBOutlet weak var agePieChartView: PieChartView!
    @IBOutlet weak var genderPieChartView: PieChartView!
    @IBOutlet weak var locationPieChartView: PieChartView!
    @IBOutlet weak var ethnicityPieChartView: PieChartView!
    @IBOutlet weak var appearedInSearchLineChartView: LineChartView!
    @IBOutlet weak var numberOfUsersWhoBookmarkedYourStorefrontLineChartView: LineChartView!
    @IBOutlet weak var numberOfUsersWhoBookmarkedYourEventLineChartView: LineChartView!
    @IBOutlet weak var numberOfUsersWhoSharedYourStorefrontLineChartView: LineChartView!
    @IBOutlet weak var numberOfStorefrontVisitorsConvertedToPayingCustomersLineChartView: LineChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var prevOffset: Float = 0
    
    private var viewModel: InsightsViewModel!
    private var util = ChartUtils()
    private let currentUser = "test"
    var visibleIndexPath: IndexPath? = nil
    
    var startDate: Date!
    var endDate: Date!
    
    func dataChanged() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.viewModel = InsightsViewModel(currentUser: self.currentUser, delegate: self)
        dateStateChanged(dateState: dateState)
        setPieChart(chart: agePieChartView, values: viewModel.getVisitorAges())
        setPieChart(chart: genderPieChartView, values: viewModel.getVisitorGenders())
        setPieChart(chart: locationPieChartView, values: viewModel.getVisitorLocations())
        setPieChart(chart: ethnicityPieChartView, values: viewModel.getVisitorEthnicities())
    }
    
    
    func setLineGraph(chart: LineChartView, values: [Double], label: String) {
        chart.rightAxis.drawLabelsEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.axisLineColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.chartDescription?.text = ""
        chart.legend.textColor = .white
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: label)
        chartDataSet.valueTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.4058836323, green: 1, blue: 0.6449512505, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.09044898074, green: 1, blue: 0.9353333129, alpha: 1)]
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 4
        let chartData = LineChartData(dataSets: [chartDataSet])
        chart.data = chartData
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setPieChart(chart: PieChartView, values: [String: Double]) {
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.chartDescription?.text = ""
        chart.drawHoleEnabled = false
        chart.legend.enabled = true
        chart.legend.textColor = .white
        chart.legend.orientation = .vertical
        chart.drawEntryLabelsEnabled = false
        var dataEntries = [PieChartDataEntry]()
        for (key, val) in values {
            let entry = PieChartDataEntry(value: val, label: key)
            dataEntries.append(entry)
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.5732106885, green: 1, blue: 0.84519483, alpha: 1),#colorLiteral(red: 0.509465854, green: 0.922074988, blue: 1, alpha: 1),#colorLiteral(red: 0.3274911169, green: 0.6634615801, blue: 1, alpha: 1),#colorLiteral(red: 0.2196151837, green: 0.3735224629, blue: 1, alpha: 1),#colorLiteral(red: 0.429325448, green: 0.1026686058, blue: 1, alpha: 1)]
        chartDataSet.sliceSpace = 2
        chartDataSet.selectionShift = 7
        chartDataSet.valueColors = [#colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 1)]
        chartDataSet.valueFont = UIFont(name: "HelveticaNeue", size: 9.0)!

        let chartData = PieChartData(dataSet: chartDataSet)
        
        // Changing the values to toggle the percent sign
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chart.data = chartData
        chart.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    
    func dayViewWasSelected(chart: LineChartView, values: [Double], label: String) {
        //Setup the labels for the x axis
        let days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        
        //Find the current day of the week
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        let dayOfWeek = util.getDayOfWeek(date)
        let startingDay = util.mod((dayOfWeek! - values.count), 7) - 1
        
        //Calculate the rest of the days of the week to display in the x axis
        var xAxis = [String]()
        for i in 0..<values.count {
            xAxis.append(days[util.mod(startingDay + i, 7)])
        }
        xAxis.append("Today")
        
        // Set the x axis to days of the week
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis)
        chart.xAxis.granularity = 1
        
        //Make it so you can only view 7 days at a time; it's scrollable
        chart.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 7 days first
        let lastSevenPoints = values.count - 7
        chart.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: chart, values: values, label: label)
        
    }
    
    func weekViewWasSelected(chart: LineChartView, values: [Double], label: String) {
        var today = Date()
        var thisWeek = today.getThisWeek()
        
        // Calculate week values
        var xAxis = [String]()
        for _ in 0..<values.count {
            xAxis.append(thisWeek)
            today = today.sevenDaysAgo()
            thisWeek = today.getThisWeek()
        }
        
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        chart.xAxis.granularity = 1
        
        //Make it so you can only view 7 days at a time; it's scrollable
        chart.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 7 days first
        let lastSevenPoints = values.count - 7
        chart.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: chart, values: values, label: label)
    }
    
    func monthViewWasSelected(chart: LineChartView, values: [Double], label: String) {
        var xAxis = [String]()
        var thisMonth = Date().getMonthNo() - 1
        for _ in 0..<values.count {
            if thisMonth >= 0 {
                xAxis.append(util.months[thisMonth])
                thisMonth -= 1
            } else {
                thisMonth = 11
                xAxis.append(util.months[thisMonth])
                thisMonth -= 1
            }
        }
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis.reversed())
        chart.xAxis.granularity = 1
        //Make it so you can only view 7 days at a time; it's scrollable
        chart.setVisibleXRangeMaximum(7.0)
        
        //Set the default view to toggle the last 2 months first
        let lastSevenPoints = values.count
        chart.moveViewToX(Double(lastSevenPoints))
        
        //Set the chart
        setLineGraph(chart: chart, values: values, label: label)
    }
    
    // Took this one out because it might be more beneficial to users to persist all the different line graphs for comparisons instead of reloading them every time. Could also take the other ones out for this same reason.
   /* //Handle animations upon scrolling to them
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let currentPosition = scrollView.co
        let offset = scrollView.contentOffset.y
        if (prevOffset < 250 || prevOffset > 500) && offset >= 250 {
            //let values = viewModel.getDailyRevenue()
            dateStateChanged(dateState: dateState)
        }
        if (prevOffset > 800 && offset >= 400) {
            setRevenueByLocationGraph()
        }
        prevOffset = Float(offset)
    }
 */
}
