//
//  SummaryViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/19/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import Charts
import MXSegmentedPager
import MapKit
import UICountingLabel

// view Controller for summary page
class SummaryViewController: UIViewController, InsightsViewModelDelegate, UIScrollViewDelegate, SummaryViewControllerDelegate {
    
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    // SummaryViewControllerDelegate function. Called by InsightsTabViewController when the dateState changes over there.
    func dateStateChanged(dateState: Int) {
        self.dateState = dateState
    }
    
    
    func dataChanged() {
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var totalClientsLabel: UILabel!
    @IBOutlet weak var totalBookingsLabel: UILabel!
    @IBOutlet weak var totalCancellationsLabel: UILabel!
    
    // Used to have the regular labels be counting labels, but was too laggy. If there is a better implementation of counting labels they can be implented.
//    @IBOutlet weak var totalRevenueLabel: UICountingLabel!
//    @IBOutlet weak var totalClientsLabel: UICountingLabel!
//    @IBOutlet weak var totalBookingsLabel: UICountingLabel!
//    @IBOutlet weak var totalCancellationsLabel: UICountingLabel!
    
    @IBOutlet weak var localCompetitorsLabel: UILabel!
    @IBOutlet weak var primaryServiceRegionLabel: UILabel!
    @IBOutlet weak var averageClientLocationMap: MKMapView!
    @IBOutlet weak var averageServicePriceLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var eventsCompletedLabel: UILabel!
    @IBOutlet weak var mostPopularEventLabel: UILabel!
    
    //To initialize viewModel
    private var viewModel: InsightsViewModel!
    private let currentUser = "test"
    //daily, weekly, monthly
    var dateState: Int!
    var startDate: Date!
    var endDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //need to set the scrollview delegate to self to see use scrollviewdidscroll
        scrollView.delegate = self
        self.viewModel = InsightsViewModel(currentUser: self.currentUser, delegate: self)
        
        //set labels
        setTotalRevenueLabel()
        setTotalClientsLabel()
        setTotalBookingsLabel()
        setTotalCancellationsLabel()
        setLocalCompetitorsLabel()
        setPrimaryServiceRegionLabel()
        setAverageClientLocationMap()
        setAverageServicePriceLabel()
        setAverageRatingLabel()
        setEventsCompletedLabel()
        setMostPopularEventLabel()
        
    }
    
    func setTotalRevenueLabel() {
//        totalRevenueLabel.format = "%d"
//        totalRevenueLabel.method = UILabelCountingMethod.easeOut
//        totalRevenueLabel.count(from: 0.0, to: CGFloat(Float(viewModel.getTotalRevenue())), withDuration: 2.0)
        totalRevenueLabel.text = String(viewModel.getTotalRevenue())
    }

    func setTotalClientsLabel() {
        totalClientsLabel.text = String(viewModel.getTotalClients())
    }

    func setTotalBookingsLabel() {
        totalBookingsLabel.text = String(viewModel.getTotalBookings())
    }

    func setTotalCancellationsLabel() {
        totalCancellationsLabel.text = String(viewModel.getTotalCancellations())
    }
    
    func setLocalCompetitorsLabel() {
        localCompetitorsLabel.text = String(viewModel.getTotalLocalCompetitors())
    }
    
    func setPrimaryServiceRegionLabel() {
        primaryServiceRegionLabel.text = viewModel.getPrimaryServiceRegion()
    }
    
    // Helper func for setAverageClientLocationMap
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        averageClientLocationMap.setRegion(coordinateRegion, animated: true)
    }
    
    func setAverageClientLocationMap() {
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        centerMapOnLocation(location: initialLocation)
        averageClientLocationMap.isScrollEnabled = false
        averageClientLocationMap.isZoomEnabled = false
    }
    
    func setAverageServicePriceLabel() {
        averageServicePriceLabel.text = "$" + String(viewModel.getAverageServicePrice())
    }
    
    func setAverageRatingLabel() {
        averageRatingLabel.text = String(viewModel.getAverageRatings())
    }
    
    func setEventsCompletedLabel() {
        eventsCompletedLabel.text = String(viewModel.getEventsCompleted())
    }
    
    func setMostPopularEventLabel() {
        mostPopularEventLabel.text = viewModel.getMostPopularEvent()
    }
}
