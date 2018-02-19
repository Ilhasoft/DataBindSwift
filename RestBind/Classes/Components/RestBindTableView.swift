//
//  RestBindTableViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

open class RestBindTableView: ISOnDemandTableView {

    @IBInspectable var apiURL:String?
    @IBInspectable var endPoint:String!
    @IBInspectable var keyPath:String?
    
    private var configuration:RestBindConfiguration!
    
    public func getConfiguration() -> RestBindConfiguration {
        configuration = RestBindConfiguration()
        configuration.apiURL = apiURL
        configuration.endPoint = endPoint
        configuration.keyPath = keyPath
        return configuration
    }
    
}
