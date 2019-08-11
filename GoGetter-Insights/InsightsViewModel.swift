//
//  InsightsViewModel.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/20/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
protocol InsightsViewModelDelegate: class {
    func dataChanged()
}

class InsightsViewModel: NSObject {
    private weak var delegate:
        InsightsViewModelDelegate? = nil
    
    required init(currentUser: String, delegate: InsightsViewModelDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    public func viewWillAppear() {
        if let delegate = self.delegate {
            delegate.dataChanged()
        }
    }
    
    public func viewDidDisappear() {
        
    }
    
    public func getTotalRevenue() -> Double {
        return 309.0
    }
    
    public func getDailyRevenue() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyRevenue() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyRevenue() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getGenderStats() -> [String: Int] {
        return ["Male": 25, "Female": 30, "Other": 5, "Prefer not to say": 4]
    }
    
    public func getClientZipcodes() -> [Int] {
        return [90000, 90001, 90002, 90003, 90004, 90005]
    }
    
    public func getTotalClients() -> Int {
        return 42
    }
    
    public func getTotalRatings() -> [Int: Int] {
        return [1: 50, 2: 25, 3: 15, 4: 55, 5: 100]
    }
    
    public func getTotalBookings() -> Int {
        return 55
    }
    
    public func getTotalCancellations() -> Int {
        return 7
    }
    
    public func getTotalLocalCompetitors() -> Int {
        return 5
    }
    
    public func getPrimaryServiceRegion() -> String {
        return "San Francisco, CA"
    }
    
    public func getAverageRatings() -> Double {
        let ratingsKeys = getTotalRatings().keys
        var totalStars = 0
        var totalRatings = 0
        for rating in ratingsKeys {
            totalStars += getTotalRatings()[rating]! * rating
        }
        for rating in getTotalRatings().values {
            totalRatings += rating
        }
        return Double(totalStars / totalRatings)
    }
    
    public func getAverageServicePrice() -> Double {
        return 100.0
    }
    
    public func getEventsCompleted() -> Int {
        return 25
    }
    
    public func getMostPopularEvent() -> String {
        return "Youth Golf Summer Camp"
    }
    
    public func getRevenueForLocation(zipcode: Int) -> Int {
        switch zipcode {
        case 90000:
            return 500
        case 90001:
            return 250
        case 90002:
            return 750
        case 90003:
            return 1050
        case 90004:
            return 1200
        case 90005:
            return 200
        default:
            return 0
        }
    }
    
    public func getRevenueByLocation() -> [Int: Int] {
        var revenues = [Int: Int]()
        for zip in getClientZipcodes() {
            revenues[zip] = getRevenueForLocation(zipcode: zip)
        }
        return revenues
    }
    
    public func getPrivateEventRevenue() -> [String: Double] {
        return ["Hour Lessons": 250, "90-minute Lessons": 400, "30-minute Lessons": 150]
    }
    
    public func getPublicEventRevenue() -> [String: Double] {
        return ["Youth Golf Summer Camp": 500, "Golf Boot Camp": 700, "Golf Winter Clinic": 475]
    }
    
    // Fake clients
    var Austin = Client(name: "Austin", totalRevenue: 25, numCancellations: 2, rating: 2.1, numRatings: 5, numReferrals: 3, referrees: ["Alice", "Bob", "Charlie"], numEventReferrals: 3, eventReferrees: ["Lauren", "Maddie", "Nathan"], dealsPurchased: 5)
    
    var Jessica = Client(name: "Jessica", totalRevenue: 12, numCancellations: 1, rating: 1.5, numRatings: 3, numReferrals: 3, referrees: ["Dan", "Eric", "Fred"], numEventReferrals: 6, eventReferrees: ["Olivia", "Penny", "Quinn", "Reese", "Steve", "Trey"], dealsPurchased: 4)
    
    var Geoff = Client(name: "Geoff", totalRevenue: 335, numCancellations: 3, rating: 3.9, numRatings: 7, numReferrals: 1, referrees: ["George"], numEventReferrals: 2, eventReferrees: ["Ursula", "Vicky"], dealsPurchased: 4)
    
    var James = Client(name: "James", totalRevenue: 45, numCancellations: 4, rating: 4.2, numRatings: 5, numReferrals: 4, referrees: ["Heather", "Iris", "Jeff", "Karl"], numEventReferrals: 4, eventReferrees: ["Will", "XXX", "Yossarian", "Zane"], dealsPurchased: 12)
    
    var Andy = Client(name: "Andy", totalRevenue: 70, numCancellations: 3, rating: 1.4, numRatings: 5.0, numReferrals: 5, referrees: ["Abe", "Barb", "Cab", "Darb", "Larry"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Barney = Client(name: "Barney", totalRevenue: 50, numCancellations: 3, rating: 4.5, numRatings: 4, numReferrals: 4, referrees: ["Abe", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Clyde = Client(name: "Clyde", totalRevenue: 75, numCancellations: 3, rating: 5.0, numRatings: 3, numReferrals: 7, referrees: ["Abe", "Barb", "Cab", "Darb", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Dirk = Client(name: "Dirk", totalRevenue: 100, numCancellations: 3, rating: 3.2, numRatings: 6, numReferrals: 7, referrees: ["Abe", "Barb", "Cab", "Darb", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Ed = Client(name: "Ed", totalRevenue: 200, numCancellations: 3, rating: 2.1, numRatings: 7, numReferrals: 9, referrees: ["Abe", "Barb", "Cab", "Darb", "Abe", "Barb", "Cab", "Darb", "Abe"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Frank = Client(name: "Frank", totalRevenue: 15, numCancellations: 3, rating: 1.1, numRatings: 9, numReferrals: 0, referrees: [], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Gerald = Client(name: "Gerald", totalRevenue: 10, numCancellations: 3, rating: 0.1, numRatings: 1, numReferrals: 4, referrees: ["Abe", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Harold = Client(name: "Harold", totalRevenue: 700, numCancellations: 3, rating: 2.5, numRatings: 3, numReferrals: 3, referrees: ["Abe", "Barb", "Cab"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Irene = Client(name: "Irene", totalRevenue: 1000, numCancellations: 3, rating: 3.4, numRatings: 2, numReferrals: 1, referrees: ["Abe"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Jack = Client(name: "Jack", totalRevenue: 54, numCancellations: 3, rating: 4.4, numRatings: 6, numReferrals: 12, referrees: ["Abe", "Barb", "Cab", "Darb", "Abe", "Barb", "Cab", "Darb", "Abe", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Klein = Client(name: "Klein", totalRevenue: 89, numCancellations: 3, rating: 2.0, numRatings: 88, numReferrals: 2, referrees: ["Abe", "Barb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Lauren = Client(name: "Lauren", totalRevenue: 255, numCancellations: 3, rating: 1.0, numRatings: 2, numReferrals: 7, referrees: ["Abe", "Barb", "Cab", "Darb", "Abe", "Barb", "Cab"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    var Mark = Client(name: "Mark", totalRevenue: 122, numCancellations: 3, rating: 0.5, numRatings: 1, numReferrals: 8, referrees: ["Abe", "Barb", "Cab", "Darb", "Abe", "Barb", "Cab", "Darb"], numEventReferrals: 3, eventReferrees: ["Elvin", "Frank", "Geff"], dealsPurchased: 1)
    
    lazy var clients = [Austin, Jessica, Geoff, James, Andy, Barney, Clyde, Dirk, Ed, Frank, Gerald, Harold, Irene, Jack, Klein, Lauren, Mark]
    
    public func getRevenuePerClient() -> [(String, Double)] {
        var rv = [(String, Double)]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestRevenue = 0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.totalRevenue >= Double(highestRevenue) {
                    highestRevenue = Int(client.totalRevenue)
                }
            }
            for client in unusedClients {
                if client.totalRevenue == Double(highestRevenue) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].totalRevenue))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
    
    public func getCancellationsPerClient() -> [(String, Double)] {
        var rv = [(String, Double)]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestCancellations = 0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.numCancellations >= Double(highestCancellations) {
                    highestCancellations = Int(client.numCancellations)
                }
            }
            for client in unusedClients {
                if client.numCancellations == Double(highestCancellations) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].numCancellations))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
    
    public func getRatingsPerClient() -> [(String, Double, Double)] {
        var rv = [(String, Double, Double)]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestRating = 0.0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.rating >= Double(highestRating) {
                    highestRating = client.rating
                }
            }
            for client in unusedClients {
                if client.rating == Double(highestRating) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].rating, unusedClients[i].numRatings))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
    
    public func getReferralsPerClient() -> [(String, [String])] {
        var rv = [(String, [String])]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestReferrals = 0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.numReferrals >= Double(highestReferrals) {
                    highestReferrals = Int(client.numReferrals)
                }
            }
            for client in unusedClients {
                if client.numReferrals == Double(highestReferrals) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].referrees))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
 
    public func getEventReferralsPerClient() -> [(String, [String])] {
        var rv = [(String, [String])]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestReferrals = 0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.numEventReferrals >= Double(highestReferrals) {
                    highestReferrals = Int(client.numEventReferrals)
                }
            }
            for client in unusedClients {
                if client.numEventReferrals == Double(highestReferrals) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].eventReferrees))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
    
    public func getDealsPerClient() -> [(String, Double)] {
        var rv = [(String, Double)]()
        var unusedClients = clients
        while !unusedClients.isEmpty {
            var index = 0
            var highestDeals = 0
            var usedClientsIndexes = [Int]()
            for client in unusedClients {
                if client.dealsPurchased >= Double(highestDeals) {
                    highestDeals = Int(client.dealsPurchased)
                }
            }
            for client in unusedClients {
                if client.dealsPurchased == Double(highestDeals) {
                    usedClientsIndexes.append(index)
                }
                index += 1
            }
            for i in usedClientsIndexes.reversed() {
                rv.append((unusedClients[i].name, unusedClients[i].dealsPurchased))
                unusedClients.remove(at: i)
            }
        }
        return rv
    }
    
    
    public func getWeeklyActiveClients() -> [Double] {
        return [10, 9, 11, 14, 15, 18, 19, 13, 15, 17, 20, 21]
    }
    
    public func getMonthlyActiveClients() -> [Double] {
        return [30, 34, 25, 37, 48, 49, 51, 80, 47]
    }
    
    public func getRetentionRates() -> [String: Double] {
        return ["One-time Booking Clients": 25, "Multiple Booking Clients": 12]
    }
    
    
    public func getDailyStorefrontVisitors() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyStorefrontVisitors() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyStorefrontVisitors() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getDailySearchHits() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklySearchHits() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlySearchHits() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getDailyStorefrontBookmarkers() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyStorefrontBookmarkers() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyStoreFrontBookmarkers() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getDailyEventBookmarkers() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyEventBookmarkers() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyEventBookmarkers() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getDailyStorefrontSharers() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyStorefrontSharers() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyStoreFrontSharers() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getDailyConverted() -> Array<Double> {
        return [10.0, 20.0, 30.0, 40.0, 30.0, 20.0, 10.0, 5.0, 1.0, 17.0, 20.0, 50.0, 20.0, -5.0, -50.0, -25.0]
    }
    
    public func getWeeklyConverted() -> Array<Double> {
        return [100.0, 59.0, 80.0, 78.0, 58.0, 99.0, 1000.0, 0.0, 50.0, 30, 85, 69, 69, 47]
    }
    
    public func getMonthlyConverted() -> [Double] {
        return [2000, 1000, 3000, 500, 4000, 3000, 100, 7000, 800, 249, 4539]
    }
    
    public func getVisitorAges() -> [String: Double] {
        return ["13-18": 20, "19-30": 40, "30-40": 35, "40-50": 72]
    }
    
    public func getVisitorGenders() -> [String: Double] {
        return ["Male": 55, "Female": 40, "Other": 5]
    }
    
    public func getVisitorLocations() -> [String: Double] {
        return ["90001": 15, "90002": 14, "90003": 71]
    }
    
    public func getVisitorEthnicities() -> [String: Double] {
        return ["Asian": 25, "Black": 25, "Hispanic": 25, "White": 25]
    }
    
    public func getMostPopularTimes() -> [(String, Double)] {
        return [("12 AM", 0), ("1 AM", 0), ("2 AM", 0), ("3 AM", 0), ("4 AM", 0), ("5 AM", 0), ("6 AM", 0), ("7 AM", 1), ("8 AM", 0), ("9 AM", 1), ("10 AM", 2), ("11 AM", 4), ("12 PM", 6), ("1 PM", 10), ("2 PM", 12), ("3 PM", 16), ("4 PM", 8), ("5 PM", 9), ("6 PM", 3), ("7 PM", 2), ("8 PM", 0), ("9 PM", 0), ("10 PM", 0), ("11 PM", 0)]
    }
    
    public func getMostPopularDay() -> [(String, Double)] {
        return [("Sun", 12), ("Mon", 3), ("Tues", 4), ("Wed", 5), ("Thurs", 10), ("Fri", 3), ("Sat", 5)]
    }
    
    public func getBestEvents() -> [Event] {
        return [Event(name: "Youth Golf Summer Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Tennis Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Golf Lesson", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Golf Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Tennis Clinic", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "idk", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "idk", revenue: 1000, attendees: clients, date: Date(), minutes: 90)]
    }
    
    public func getMostProfitableEvents() -> [Event] {
        return [Event(name: "Youth Golf Summer Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Tennis Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Golf Lesson", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Golf Camp", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "Tennis Clinic", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "idk", revenue: 1000, attendees: clients, date: Date(), minutes: 90), Event(name: "idk", revenue: 1000, attendees: clients, date: Date(), minutes: 90)]
    }
    
}

struct Client {
    var name: String
    var totalRevenue: Double
    var numCancellations: Double
    var rating: Double
    var numRatings: Double
    var numReferrals: Double
    var referrees: [String]
    var numEventReferrals: Double
    var eventReferrees: [String]
    var dealsPurchased: Double
}

struct Event {
    var name: String
    var revenue: Double
    var attendees: [Client]
    var date: Date
    var minutes: Double
}
