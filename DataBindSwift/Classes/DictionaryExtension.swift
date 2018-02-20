//
//  DictionaryExtension.swift
//  DataBindSwift
//
//  Created by Daniel Amaral on 20/02/18.
//

import UIKit

extension Dictionary {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}
