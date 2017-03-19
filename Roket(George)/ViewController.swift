//
//  ViewController.swift
//  Roket(George)
//
//  Created by george chin fu hou on 17/03/2017.
//  Copyright © 2017 George Chin. All rights reserved.
//

import UIKit
import CoreMotion
import HealthKit

class ViewController: UIViewController {
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let endDate = NSDate()
//        let calendar = NSCalendar.current
//        let startDate = calendar.dateByAddingUnit(.Day, value: -7, toDate: endDate, options: [])
//        
//        let weightSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
//        
//        let query = HKSampleQuery(sampleType: weightSampleType, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
//            (query, results, error) in
//            if results == nil {
//                println("There was an error running the query: \(error)")
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                var dailyAVG:Double = 0
//                for steps in results as [HKQuantitySample]
//                {
//                    // add values to dailyAVG
//                    dailyAVG += steps.quantity.doubleValueForUnit(HKUnit.countUnit())
//                    println(dailyAVG)
//                    println(steps)
//                    
//                    healthStore?.executeQuery(query)
//                }
//            }
//        })
//        
//        
}
}

