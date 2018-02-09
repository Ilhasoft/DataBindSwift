//
//  RestBindProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ISOnDemandTableView
import Alamofire
import ObjectMapper

public class RestBindTableViewProvider : ISOnDemandTableViewInteractor {
    
    private var endPoint:String!
    private var keyPath:String?
    private var filteredBy:String?
    private var params:[String:Any]?
    
    public init(tableViewConfiguration:RestBindTableViewConfiguration, params:[String:Any]? = nil, paginationCount:Int? = RestBind.paginationCount!) {
        self.endPoint = tableViewConfiguration.endPoint
        self.keyPath = tableViewConfiguration.keyPath
        self.filteredBy = tableViewConfiguration.filteredBy
        self.params = params
        super.init(paginationCount: UInt(paginationCount!))
    }
    
    override public func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        var objects = [Map]()
        var parameters = [String:Any]()
        
        guard let url = RestBind.url else {
            NSException(name: NSExceptionName(rawValue: "Exception"), reason: "Error: You need to init class RestBind(withURL:https://)", userInfo: nil).raise()
            return
            
        }
        
//        if let filteredBy = filteredBy, let tuple = filteredFromMap {
//            for param in filteredBy.split(separator: ",") {
//                let param = String(param)
//                let className = tuple.className
//                let map = tuple.map
//                var paramKey = param
//
//                if className == param {
//                    paramKey = RestBind.keyIdentificator!
//                }
//
//                if map.JSON[paramKey] != nil {
//                    params[param] = map.JSON[paramKey]! as Any
//                }else {
//                    print("param " + param + " not found in map")
//                }
//            }
//        }else if let params = self.params {
        
        if let params = self.params {
            parameters = params
        }
        
        self.currentPage = page == 0 ? 1 : page
        
        parameters["page_size"] = self.paginationCount
        parameters["page"] = self.currentPage
        
        Alamofire.request(url + endPoint, parameters: parameters).responseJSON { (dataResponse:DataResponse<Any>) in
            var rootResults = [[String:Any]]()
            if let keyPath = self.keyPath {
                if let results = (dataResponse.result.value as! [String:Any])[keyPath] as? [[String:Any]] {
                    rootResults = results
                    for result in rootResults {
                        let object = Map(mappingType: .fromJSON, JSON: result)
                        objects.append(object)
                    }
                    handler(objects,nil)
                }
            }else if let results = dataResponse.result.value as? [[String:Any]] {
                rootResults = results
                for result in rootResults {
                    let object = Map(mappingType: .fromJSON, JSON: result)
                    objects.append(object)
                }
                handler(objects,nil)
            }else if let error = dataResponse.result.error {
                handler([],error)
            }else {
                handler([],nil)
            }
            
        }
    }
    
}
