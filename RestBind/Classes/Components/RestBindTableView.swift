//
//  RestBindTableViewController.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView

public struct RestBindTableViewConfiguration {
    var endPoint:String!
    var keyPath:String!
    var filteredBy:String!
}

open class RestBindTableView: ISOnDemandTableView {

    @IBInspectable var endPoint:String!
    @IBInspectable var keyPath:String?
    @IBInspectable var filteredBy:String?    
    
    private var configuration:RestBindTableViewConfiguration!
    
    public func getConfiguration() -> RestBindTableViewConfiguration {
        configuration = RestBindTableViewConfiguration()
        configuration.endPoint = endPoint
        configuration.keyPath = keyPath
        configuration.filteredBy = filteredBy
        return configuration
    }
    
}
