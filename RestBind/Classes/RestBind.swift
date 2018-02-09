//
//  RestBind.swift
//  Voy
//
//  Created by Daniel Amaral on 08/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

public class RestBind: NSObject {

    static var url:String?
    //** The identificator key of json results (key,id) **//
    static var keyIdentificator:String?
    public static var paginationCount:Int?
    
    public init (withURL url:String!, keyIdentificator:String!, paginationCount:Int? = 20) {
        RestBind.url = url
        RestBind.keyIdentificator = keyIdentificator
        RestBind.paginationCount = paginationCount
    }
    
    
    
}
