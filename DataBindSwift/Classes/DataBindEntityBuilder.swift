//
//  DataBindEntityBuilder.swift
//  DataBindSwift
//
//  Created by Daniel Amaral on 20/02/18.
//

import UIKit

class DataBindEntityBuilder: NSObject {
    
    open static var mainDictionary = NSMutableDictionary()
    var currentIndex = 0
    var currentEntityIndex = 0
    var totalFieldsAndValues = 0
    var currentCompletePathArray = [String]()
    
    open var dictionaryObjectsList = [[String:Any]]()
    
    init(fieldPath:String, value: Any) {
        super.init()
        currentIndex = 0
        currentCompletePathArray = fieldPath.components(separatedBy: ".")
        self.buildEntityStructure(fieldPath: fieldPath, value: value)
    }
    
    init(with fieldPathsAndValues: [[String:Any]]) {
        super.init()
        DataBindEntityBuilder.mainDictionary = NSMutableDictionary()
        
        totalFieldsAndValues = fieldPathsAndValues.count
        for fieldAndValue in fieldPathsAndValues {
            currentIndex = 0
            currentCompletePathArray = fieldAndValue.keys.first!.components(separatedBy: ".")
            self.buildEntityStructure(fieldPath: fieldAndValue.keys.first!, value: fieldAndValue.values.first!)
            currentEntityIndex = currentEntityIndex + 1
        }
    }
    
    func buildEntityStructure(fieldPath:String,value:Any) {
        
        let path = fieldPath.components(separatedBy: ".")
        let itemPath = path[0]
        
        let isLastItemPath = path.count == 1
        
        if isLastItemPath {
            
            let getCurrentValue = (DataBindEntityBuilder.mainDictionary as Dictionary).getValue(forKeyPath: getKeyPathFromPreviousFieldPath(currentIndex:currentIndex).1)
            
            if let dictionary = getCurrentValue as? NSMutableDictionary {
                dictionary.addEntries(from: [itemPath:value])
                DataBindEntityBuilder.mainDictionary.setValue(dictionary, forKeyPath: getKeyPathWithoutLastItemField(fieldPath: currentCompletePathArray))
            }else {
                DataBindEntityBuilder.mainDictionary.setValue(self.buld(key: itemPath, value: value), forKeyPath: getKeyPathWithoutLastItemField(fieldPath:  currentCompletePathArray))
            }
            
        }else {
            
            if DataBindEntityBuilder.mainDictionary.allKeys.isEmpty {
                DataBindEntityBuilder.mainDictionary = self.buld(key: itemPath, value: "")
                currentCompletePathArray = path
                
                self.buildEntityStructure(fieldPath: getNext(currentIndex: currentIndex, fieldPath: path), value: value)
            }else {
                
                let getCurrentValue = (DataBindEntityBuilder.mainDictionary as Dictionary).getValue(forKeyPath: getKeyPathFromPreviousFieldPath(currentIndex:currentIndex).1)
                
                if let _ = getCurrentValue as? NSMutableDictionary {
                    self.buildEntityStructure(fieldPath: getNext(currentIndex: currentIndex, fieldPath: path), value: value)
                }else {
                    //                    DataBindEntityBuilder.mainDictionary.setValue(self.buld(key: itemPath, value: (["className":itemPath,"__type":"Pointer"] as NSMutableDictionary)), forKeyPath: getKeyPathFromPreviousFieldPath(currentIndex:currentIndex).0)
                    DataBindEntityBuilder.mainDictionary.setValue(self.buld(key: itemPath, value: ""), forKeyPath: getKeyPathFromPreviousFieldPath(currentIndex:currentIndex).0)
                    self.buildEntityStructure(fieldPath: getNext(currentIndex: currentIndex, fieldPath: path), value: value)
                }
                
            }
            
        }
        
    }
    
    func getNext(currentIndex:Int,fieldPath:[String]) -> String {
        let fieldPath = fieldPath
        
        let newFieldPath = fieldPath.dropFirst()
        var newFieldPathString = ""
        
        for (_,path) in newFieldPath.enumerated() {
            
            if newFieldPathString.isEmpty {
                newFieldPathString = "\(path)"
            }else {
                newFieldPathString = "\(newFieldPathString).\(path)"
            }
        }
        
        //print("next : \(newFieldPathString)")
        self.currentIndex = currentIndex + 1
        
        return newFieldPathString
    }
    
    func getKeyPathWithoutLastItemField(fieldPath:[String]) -> String {
        let newFieldPath = fieldPath.dropLast()
        var newFieldPathString = ""
        
        for (_,path) in newFieldPath.enumerated() {
            
            if newFieldPathString.isEmpty {
                newFieldPathString = "\(path)"
            }else {
                newFieldPathString = "\(newFieldPathString).\(path)"
            }
        }
        return newFieldPathString
    }
    
    func getKeyPathFromPreviousFieldPath(currentIndex:Int) -> (String,[String]) {
        var newFieldPath = [String]()
        var newFieldPathString = ""
        
        if currentIndex == 0 {
            return (currentCompletePathArray.first!,[currentCompletePathArray.first!])
        }
        
        for (index,itemPath) in currentCompletePathArray.enumerated() {
            if index < currentIndex {
                newFieldPath.append(itemPath)
            }
        }
        
        //print(newFieldPath)
        
        for (_,path) in newFieldPath.enumerated() {
            
            if newFieldPathString.isEmpty {
                newFieldPathString = "\(path)"
            }else {
                newFieldPathString = "\(newFieldPathString).\(path)"
            }
        }
        
        return (newFieldPathString,newFieldPath)
    }
    
    func buld(key:String,value:Any) -> NSMutableDictionary {
        return [key:value]
    }
    
    func extractObjectsBeforeSave(mainEntity:String,includeKeys:[String]) {
        for includeKey in includeKeys {
            
            var keyPath = "\(mainEntity).\(includeKey)"
            var keyPathArray = keyPath.components(separatedBy: ".")
            
            if keyPathArray.count >= 2 {
                
                for _ in keyPathArray {
                    
                    let value = DataBindEntityBuilder.mainDictionary.value(forKeyPath: keyPath)
                    let filtered = dictionaryObjectsList.filter {( $0.keys.first! == keyPath )}
                    
                    if filtered.isEmpty {
                        dictionaryObjectsList.append([keyPath:value as Any])
                    }
                    
                    var includeKeyArrayWithoutLastItem = [String]()
                    keyPath = ""
                    for (index,key) in keyPathArray.enumerated() {
                        if index == keyPathArray.count - 1 {
                            continue
                        }
                        
                        if index == 0 {
                            keyPath = "\(mainEntity)"
                        }else {
                            keyPath = "\(keyPath).\(key)"
                        }
                        
                        includeKeyArrayWithoutLastItem.append(key)
                    }
                    
                    keyPathArray = includeKeyArrayWithoutLastItem
                    
                }
            }else {
                _ = DataBindEntityBuilder.mainDictionary.value(forKeyPath: keyPath)
            }
        }
        
        let keyPathSortered = dictionaryObjectsList.sorted { (keyAndValue1, keyAndValue2) -> Bool in
            return keyAndValue1.keys.first!.components(separatedBy: ".").count > keyAndValue2.keys.first!.components(separatedBy: ".").count
        }
        
        dictionaryObjectsList = keyPathSortered
        
        if dictionaryObjectsList.isEmpty {
            dictionaryObjectsList.append([mainEntity:DataBindEntityBuilder.mainDictionary.allValues.first!])
        }
    }
    
}

