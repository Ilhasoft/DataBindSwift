//
//  RestBindProvider.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import ISOnDemandTableView
import Alamofire
import ObjectMapper

public class RestBindTableViewProvider : ISOnDemandTableViewInteractor {
    
    private var endPoint:String!
    private var keyPath:String?
    private var apiURL:String?
    private var params:[String:Any]?
    
    public init(configuration:RestBindConfiguration, params:[String:Any]? = nil, paginationCount:Int? = RestBind.paginationCount!) {
        self.endPoint = configuration.endPoint
        self.keyPath = configuration.keyPath
        self.apiURL = configuration.apiURL
        self.params = params
        super.init(paginationCount: UInt(paginationCount!))
    }
    
    override public func fetchObjects(forPage page: UInt, with handler: (([Any]?, Error?) -> Void)!) {
        
        var parameters = [String:Any]()
        var headers = [String:String]()
        if !NetworkReachabilityManager()!.isReachable {
            headers["Cache-Control"] = "public, only-if-cached, max-stale=86400"
        }else {
            headers["Cache-Control"] = "public, max-age=86400, max-stale=120"
        }
        
        guard var url = RestBind.url else {
            NSException(name: NSExceptionName(rawValue: "Exception"), reason: "Error: You need to init class RestBind(withURL:https://)", userInfo: nil).raise()
            return
            
        }
        
        if apiURL != nil {
            url = apiURL!
        }

        if let params = self.params {
            parameters = params
        }
        
        self.currentPage = page == 0 ? 1 : page
        
        parameters["page_size"] = self.paginationCount
        parameters["page"] = self.currentPage
        
        let request = Alamofire.request(url + endPoint, parameters: parameters, headers: headers)
        
        print(url + endPoint)
        print(parameters)
        print(headers)
        
        let cachedResponse = URLCache.shared.cachedResponse(for: request.request!)
        
        if NetworkReachabilityManager()!.isReachable {
            
            //TODO: Check internet connection
         
            request.responseJSON { (dataResponse:DataResponse<Any>) in
                if dataResponse.result.error == nil {
                    let cachedURLResponse = CachedURLResponse(response: dataResponse.response!, data: dataResponse.data! , userInfo: nil, storagePolicy: .allowed)
                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataResponse.request!)
                }
                
                if let keyPath = self.keyPath {
                    if let results = (dataResponse.result.value as! [String:Any])[keyPath] as? [[String:Any]] {
                        self.prepareForHandlerData(results, completion: { (objects, error) in
                            handler(objects,error)
                        })
                    }
                }else if let results = dataResponse.result.value as? [[String:Any]] {
                    self.prepareForHandlerData(results, completion: { (objects, error) in
                        handler(objects,error)
                    })
                }else if let error = dataResponse.result.error {
                    handler([],error)
                }else {
                    handler([],nil)
                }
                
            }
            
        }else if let cachedResponse = cachedResponse {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: cachedResponse.data, options: [])
                prepareForHandlerData(jsonObject as! [[String : Any]], completion: { (objects, error) in
                    handler(objects,error)
                })
            } catch {
                print(error.localizedDescription)
                handler([],error)
            }

        }else {
            print("User haven't internet connection and don't have cached data")
            handler([],nil)
        }
        
    }
    
    private func prepareForHandlerData(_ arrayDictionary: [[String:Any]], completion: (([Any]?, Error?) -> Void)!) {
        var objects = [Map]()
        
        for result in arrayDictionary {
            let object = Map(mappingType: .fromJSON, JSON: result)
            objects.append(object)
        }
        completion(objects,nil)
    }
    
}
