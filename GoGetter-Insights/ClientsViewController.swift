//
//  ClientsViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/28/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import Charts
import UIKit

class ClientsViewController: UIViewController, InsightsViewModelDelegate, UIScrollViewDelegate, UITableViewDataSource, ClientsViewControllerDelegate {
    
    //ClientsViewControllerDelegate function called by InsightsTabViewController
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    //ClientsViewControllerDelegate function called by InsightsTabViewController
    func dateStateChanged(dateState: Int) {
        self.dateState = dateState
        if dateState == 1 || dateState == 0 {
            weekViewWasSelected(chart: activeClientsChartView, values: viewModel.getWeeklyActiveClients(), label: "Active Clients")
        }
        if dateState == 2 {
            monthViewWasSelected(chart: activeClientsChartView, values: viewModel.getMonthlyActiveClients(), label: "Active Clients")
        }
    }
    
    
    @IBOutlet weak var revenueComparisonChartView: HorizontalBarChartView!
    @IBOutlet weak var cancellationComparisonChartView: HorizontalBarChartView!
    @IBOutlet weak var ratingComparisonTableView: UITableView!
    @IBOutlet weak var referralTableView: UITableView!
    @IBOutlet weak var eventReferralTableView: UITableView!
    @IBOutlet weak var dealsChartView: BarChartView!
    @IBOutlet weak var activeClientsChartView: LineChartView!
    @IBOutlet weak var retentionPieChartView: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var prevOffset: Float = 0
    
    private var viewModel: InsightsViewModel!
    private var util = ChartUtils()
    private let currentUser = "test"
    var visibleIndexPath: IndexPath? = nil
    var dateState: Int!
    var startDate: Date!
    var endDate: Date!
    
    //For revenueComparisonChartView
    var clientRevenue = [Double]()
    var clientNames = [String]()
    
    //For cancellationComparisonChartView
    var clientCancellations = [Double]()
    var clientCancellationNames = [String]()
    
    //For dealsChartView
    var clientDealsPurchased = [Double]()
    var clientDealNames = [String]()
    
    private var referralTableViewReferralNumberLabel: [String] = []
    private var referralTableViewReferrerName: [String] = []
    
    private var eventReferralsTableViewController:
    EventReferralsTableViewController!
    
    private var ratingTableViewController:
    RatingTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.viewModel = InsightsViewModel(currentUser: self.currentUser, delegate: self)
        
        //Setting up eventReferralsTableView (with eventReferralsTableViewController as datasource)
        self.eventReferralsTableViewController = EventReferralsTableViewController()
        eventReferralsTableViewController.viewModel = self.viewModel
        eventReferralsTableViewController.tableView = eventReferralTableView
        eventReferralTableView.dataSource = eventReferralsTableViewController
        //setting up labels and names in eventReferralsTableViewController
        for (k, v) in Array(viewModel.getEventReferralsPerClient()) {
            eventReferralsTableViewController.eventReferralTableViewReferralNumberLabels.append(String(v.count))
            eventReferralsTableViewController.eventReferralTableReferrerNames.append(k)
        }

        // setting up referralsTableView (with self as datasource)
        referralTableView.dataSource = self
        //setting  up labels and names for the referralTable
        for (k, v) in Array(viewModel.getReferralsPerClient()) {
            referralTableViewReferralNumberLabel.append(String(v.count))
            referralTableViewReferrerName.append(k)
        }
        
        // setting up RatingsTableView (with RatingTableViewController as datasource)
        self.ratingTableViewController = RatingTableViewController()
        ratingTableViewController.viewModel = self.viewModel
        ratingTableViewController.tableView = ratingComparisonTableView
        ratingComparisonTableView.dataSource = ratingTableViewController
        //setting up labels and names in RatingsTableViewController
        for (k, v, n) in Array(viewModel.getRatingsPerClient()) {
        ratingTableViewController.ratingLabels.append(String(v))
            ratingTableViewController.names.append(k)
            ratingTableViewController.numRatings.append(n)
        }
        
        //Setting the graphs

        let revenuePerClient = viewModel.getRevenuePerClient()
        for i in 0..<revenuePerClient.count {
            clientRevenue.append(revenuePerClient[i].1)
            clientNames.append(revenuePerClient[i].0)
        }
        
        let cancellationsPerClient = viewModel.getCancellationsPerClient()
        for i in 0..<cancellationsPerClient.count {
            clientCancellations.append(cancellationsPerClient[i].1)
            clientCancellationNames.append(cancellationsPerClient[i].0)
        }
        
        let dealsPerClient = viewModel.getDealsPerClient()
        for i in 0..<dealsPerClient.count {
            clientDealsPurchased.append(dealsPerClient[i].1)
            clientDealNames.append(dealsPerClient[i].0)
        }
        
        setBarChart(chart: revenueComparisonChartView, values: clientRevenue, labels: clientNames, label: "Dollars")
        setBarChart(chart: cancellationComparisonChartView, values: clientCancellations, labels: clientCancellationNames, label: "Cancellations")
        cancellationComparisonChartView.legend.enabled = false
        setBarChart(chart: dealsChartView, values: clientDealsPurchased, labels: clientDealNames, label: "Deals")
        dateStateChanged(dateState: dateState)
        setActiveClientsPieChart()
    }

    func dataChanged() {
        // do stuff
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getReferralsPerClient().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        let referrals = viewModel.getReferralsPerClient()
        for i in 0..<referrals.count {
            titles.append(referrals[i].0)
        }
        return titles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! referralTableViewCell
        let num = referralTableViewReferralNumberLabel[indexPath.section]
        let name = referralTableViewReferrerName[indexPath.section]
        cell.referralNumberLabel.text = num
        cell.referrerLabel.text = name
        cell.cellNumberLabel.text = String(indexPath.section + 1) + "."
        cell.selectionStyle = .none
        return cell
    }
    
    func setBarChart(chart: BarChartView, values: [Double], labels: [String], label: String) {
        chart.doubleTapToZoomEnabled = false
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chart.xAxis.granularity = 1
        chart.xAxis.labelPosition = .bottom
        
        chart.xAxis.axisLineColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.chartDescription?.text = ""
        chart.legend.textColor = .white
        chart.setVisibleXRangeMaximum(7)
        chart.moveViewTo(xValue: 0, yValue: 0, axis: .left)
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.valueTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.4058836323, green: 1, blue: 0.6449512505, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.09044898074, green: 1, blue: 0.9353333129, alpha: 1)]
        chartDataSet.highlightEnabled = false
        chartDataSet.drawValuesEnabled = true
    
        let chartData = BarChartData(dataSets: [chartDataSet])
        chart.data = chartData
        chart.rightAxis.enabled = false
        chart.chartDescription?.text = ""
        chart.animate(yAxisDuration: 2.0)
        chart.drawValueAboveBarEnabled = true
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
    
    func setLineGraph(chart: LineChartView, values: [Double], label: String) {
        chart.rightAxis.drawLabelsEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.gridColor = .lightGray
        chart.chartDescription?.text = ""
        
        chart.xAxis.axisLineColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.xAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.labelTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chart.leftAxis.gridColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
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
        chartDataSet.highlightEnabled = false
        let chartData = LineChartData(dataSets: [chartDataSet])
        chart.data = chartData
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
    }
    
    func setActiveClientsPieChart() {
    retentionPieChartView.translatesAutoresizingMaskIntoConstraints = false
        retentionPieChartView.chartDescription?.text = ""
        retentionPieChartView.drawHoleEnabled = false
        retentionPieChartView.legend.enabled = true
        retentionPieChartView.legend.textColor = .white
        var dataEntries = [PieChartDataEntry]()
        for (key, val) in viewModel.getRetentionRates() {
            let entry = PieChartDataEntry(value: Double(val), label: String(key))
            dataEntries.append(entry)
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.sliceSpace = 2
        chartDataSet.selectionShift = 7
        chartDataSet.valueTextColor = .white
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),.cyan]

        let chartData = PieChartData(dataSet: chartDataSet)
        
        
        retentionPieChartView.data = chartData
        retentionPieChartView.animate(yAxisDuration: 2)
    }
    
    func setTableView(view: UITableView) {
        view.beginUpdates()
        view.insertRows(at: [IndexPath(row: 10, section: 0)], with: .automatic)
        view.endUpdates()

    }
    
    // Need this to toggle the referree names (toggleNamesViewController)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toggleNames1" {
            let vc = segue.destination as? ToggleNamesViewController
            let indexPath = referralTableView.indexPathForSelectedRow
            let names = viewModel.getReferralsPerClient()[indexPath![0]].1
            vc?.names = names
            vc?.referrer = viewModel.getReferralsPerClient()[indexPath!.section].0 + "'s "
        }
        if segue.identifier == "toggleNames2" {
            let vc = segue.destination as? ToggleNamesViewController
            let indexPath = eventReferralTableView.indexPathForSelectedRow
            let names = viewModel.getEventReferralsPerClient()[indexPath![0]].1
            vc?.names = names
            vc?.referrer = viewModel.getEventReferralsPerClient()[indexPath!.section].0 + "'s Event "
        }
    }
    
    //Handle animations upon scrolling to them
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let currentPosition = scrollView.co
        let offset = scrollView.contentOffset.y
        if (prevOffset > 227.5 && offset <= 227.5) {
            setBarChart(chart: revenueComparisonChartView, values: clientRevenue, labels: clientNames, label: "Dollars")
        }
        if (prevOffset > 468.5 && offset <= 468.5) {
            setBarChart(chart: cancellationComparisonChartView, values: clientCancellations, labels: clientCancellationNames, label: "Cancellations")
        }
        if ((prevOffset < 1015 && offset >= 1015) || (prevOffset > 1839 && offset < 1839)) {
            setBarChart(chart: dealsChartView, values:clientDealsPurchased, labels: clientDealNames, label: "Deals")
        }
        if (prevOffset < 1370 && offset >= 1370) {
            dateStateChanged(dateState: dateState)
        }
        if (prevOffset < 1625 && offset >= 1625) {
            setActiveClientsPieChart()
        }
        prevOffset = Float(offset)
    }
}
