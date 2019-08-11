//
//  InsightsViewController.swift
//  GoGetter Insights
//
//  Created by JMD on 7/19/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import UIKit
import MXSegmentedPager

class InsightsViewController: MXSegmentedPagerController {

    var services = ["Tennis", "Golf"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundColor = UIColor(hex: "1c2541")
        let tintColor = UIColor(hex: "0be182")
        let textColor = UIColor(hex: "4f6d92")
        segmentedPager.backgroundColor = backgroundColor
        
        segmentedPager.segmentedControlEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = backgroundColor
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .heavy), NSAttributedStringKey.foregroundColor : textColor]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .heavy),NSAttributedStringKey.foregroundColor : tintColor]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.segmentEdgeInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        segmentedPager.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segmentedPager.segmentedControl.selectionIndicatorHeight = 4
        segmentedPager.segmentedControl.selectionIndicatorColor = tintColor
        segmentedPager.segmentedControl.segmentWidthStyle = .dynamic
        segmentedPager.segmentedControl.type = .textImages
        segmentedPager.segmentedControl.imagePosition = .aboveText
        segmentedPager.segmentedControl.textImageSpacing = 3
        
        segmentedPager.segmentedControl.shouldStretchSegmentsToScreenSize = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        switch index {
        case 0:
            return "All Services"
        default:
            return self.services[index - 1]
        }
    }
    
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return self.services.count + 1
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, segueIdentifierForPageAt index: Int) -> String {
        switch index {
        case 0:
            return "allServicesPage"
        default:
            return "servicePage"
        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, imageForSectionAt index: Int) -> UIImage {
        switch index {
        case 0:
            return squareImageForService(nil)
        default:
            return squareImageForService(self.services[index - 1], size: CGSize(width: 29, height: 29))
        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, selectedImageForSectionAt index: Int) -> UIImage {
        switch index {
        case 0:
            return squareImageForService(nil)
        default:
            return squareImageForService(self.services[index - 1], size: CGSize(width: 29, height: 29))
            
        }
    }
    
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 67
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "allServicesPage":
                if let viewController = segue.destination as? InsightsTabViewController {
//                            viewController.selectedService = nil
                }
            case "servicePage":
                if let viewController = segue.destination as? InsightsTabViewController {
                    if let pageSegue = segue as? MXPageSegue {
//                            viewController.selectedService = services[pageSegue.pageIndex - 1]
                    }
                }
            default:
                break
            }
        }
    }
    
}
