//
//  StringExtension.swift
//  RestBind_Example
//
//  Created by Daniel Amaral on 09/02/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

extension String {
    
    public var capitalizeFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).uppercased())
        return result
    }
    
    public var uncapitalizeFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
}
