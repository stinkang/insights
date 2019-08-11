//
//  SchedulingViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/28/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit
import Charts


// View controller for scheduling page
class SchedulingViewController: UIViewController, InsightsViewModelDelegate, SchedulingViewControllerDelegate, UIScrollViewDelegate {
    
    //SchedulingViewControllerDelegate function called by InsightsTabViewController
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    // SchedulingViewControllerDelegate function called by InsightsTabViewController
    // Doesn't do anything right now
    func dateStateChanged(dateState: Int) {
        setBarChart(chart: mostPopularTimeBarChartView, values: timePopularities, labels: times)
        
        setBarChart(chart: mostPopularDayBarChartView, values: dayPopularities, labels: days)
    }
    
    func dataChanged() {
    }
    @IBOutlet weak var mostPopularTimeBarChartView: BarChartView!
    @IBOutlet weak var mostPopularDayBarChartView: BarChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bestEventLabel: UILabel!
    @IBOutlet weak var topEventRevenueLabel: UILabel!
    @IBOutlet weak var topEventAttendeesLabel: UILabel!
    @IBOutlet weak var topEventLengthLabel: UILabel!
    @IBOutlet weak var eventPopularityTableView: UITableView!
    @IBOutlet weak var eventProfitabilityTableView: UITableView!
    
    private var prevOffset: Float = 0
    
    // Need two view controller instances to control table views and so that this view controller can instantiate their variables
    private var eventPopularityTableViewController: EventPopularityTableViewController!
    private var eventProfitabilityTableViewController: EventProfitabilityTableViewController!
    
    //For mostPopularTimeBarChartView
    var times = [String]()
    var timePopularities = [Double]()
    
    //For mostPopulartDayBarChartView
    var days = [String]()
    var dayPopularities = [Double]()
    
    private var viewModel: InsightsViewModel!
    private var util = ChartUtils()
    private let currentUser = "test"
    var visibleIndexPath: IndexPath? = nil
    var dateState: Int!
    var startDate: Date!
    var endDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.viewModel = InsightsViewModel(currentUser: self.currentUser, delegate: self)
        
        let mostPopularTimes = viewModel.getMostPopularTimes()
        let mostPopularDays = viewModel.getMostPopularDay()
        
        for i in 0..<mostPopularTimes.count {
            times.append(mostPopularTimes[i].0)
            timePopularities.append(mostPopularTimes[i].1)
        }
        
        for i in 0..<mostPopularDays.count {
            days.append(mostPopularDays[i].0)
            dayPopularities.append(mostPopularDays[i].1)
        }
        setBarChart(chart: mostPopularTimeBarChartView, values: timePopularities, labels: times)
        
        setBarChart(chart: mostPopularDayBarChartView, values: dayPopularities, labels: days)
        
        setBestEventLabels()
        
        // Setting variables for the two view controllers
        self.eventPopularityTableViewController = EventPopularityTableViewController()
        eventPopularityTableViewController.viewModel = self.viewModel
        eventPopularityTableViewController.tableView = eventPopularityTableView
        eventPopularityTableView.dataSource = eventPopularityTableViewController
        
        self.eventProfitabilityTableViewController = EventProfitabilityTableViewController()
        eventProfitabilityTableViewController.viewModel = self.viewModel
        eventProfitabilityTableViewController.tableView = eventProfitabilityTableView
        eventProfitabilityTableView.dataSource = eventProfitabilityTableViewController
    }
    
    func setBarChart(chart: BarChartView, values: [Double], labels: [String]) {
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
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Bookings")
        chartDataSet.valueTextColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        chartDataSet.colors = [ #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.4058836323, green: 1, blue: 0.6449512505, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.1005411402, green: 1, blue: 0.7171660171, alpha: 1),#colorLiteral(red: 0.09044898074, green: 1, blue: 0.9353333129, alpha: 1)]
        chartDataSet.highlightEnabled = false
        let chartData = BarChartData(dataSets: [chartDataSet])
        chart.data = chartData
        chart.rightAxis.enabled = false
        chart.chartDescription?.text = ""
        chart.animate(yAxisDuration: 2.0)
    }
    
    func setBestEventLabels() {
        bestEventLabel.text = viewModel.getBestEvents()[0].name
        topEventRevenueLabel.text = String(viewModel.getBestEvents()[0].revenue)
        topEventAttendeesLabel.text = String(viewModel.getBestEvents()[0].attendees.count)
        topEventLengthLabel.text = String(viewModel.getBestEvents()[0].minutes)
    }
    
    //Handle animations upon scrolling to them
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let currentPosition = scrollView.co
        let offset = scrollView.contentOffset.y
        if (prevOffset > 143.5 && offset <= 143.5) {
            //let values = viewModel.getDailyRevenue()
            setBarChart(chart: mostPopularTimeBarChartView, values: timePopularities, labels: times)
        }
        if (prevOffset > 341 && offset <= 341) {
            setBarChart(chart: mostPopularDayBarChartView, values: dayPopularities, labels: days)
        }
        prevOffset = Float(offset)
    }
    
    // need this to toggle event information from the table views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "togglePopularEvent":
            let vc = segue.destination as?  ToggleEventViewController
            let indexPath = eventPopularityTableView.indexPathForSelectedRow
            vc?.event = viewModel.getBestEvents()[indexPath![0]]
        case "toggleProfitableEvent":
            let vc = segue.destination as?  ToggleEventViewController
            let indexPath = eventProfitabilityTableView.indexPathForSelectedRow
            vc?.event = viewModel.getMostProfitableEvents()[indexPath![0]]
        default:
            print("hello")
        }
    }
}

// view controller for eventPopularityTableView in SchedulingViewController
class EventPopularityTableViewController: UIViewController, UITableViewDataSource, InsightsViewModelDelegate {
    func dataChanged() {
    }
    
    public var tableView: UITableView!
    public var viewModel: InsightsViewModel!
    private let currentUser = "test"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getBestEvents().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        let events = viewModel.getBestEvents()
        for i in 0..<events.count {
            titles.append(events[i].name)
        }
        return titles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventPopularityCell") as! referralTableViewCell
        cell.cellNumberLabel.text = String(indexPath.section + 1) + "."
        cell.referrerLabel.text = viewModel.getBestEvents()[indexPath.section].name
        cell.selectionStyle = .none
        return cell
    }
}

// view controller for eventProfitabilityTableView in SchedulingViewController
class EventProfitabilityTableViewController:UIViewController, UITableViewDataSource, InsightsViewModelDelegate {
    
    public var tableView: UITableView!
    public var viewModel: InsightsViewModel!
    private let currentUser = "test"
    
    func dataChanged() {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getMostProfitableEvents().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        let events = viewModel.getMostProfitableEvents()
        for i in 0..<events.count {
            titles.append(events[i].name)
        }
        return titles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventProfitabilityCell") as! referralTableViewCell
        cell.cellNumberLabel.text = String(indexPath.section + 1) + "."
        cell.referrerLabel.text = viewModel.getMostProfitableEvents()[indexPath.section].name
        cell.selectionStyle = .none
        return cell
    }
    
}
