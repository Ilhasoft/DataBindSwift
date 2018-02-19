//
//  RestBindFillData.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher

public protocol RestBindFillViewDelegate {
    func didFetch(error:Error?)
    func willFill(component:Any, value:Any) -> Any?
    func didFill(component:Any, value: Any)
    func willSet(component:Any, value:Any) -> Any?
    func didSet(component:Any, value: Any)
}

public class RestBindFillView: UIView {

    @IBOutlet open var fields:[AnyObject]!
    
    private var isFieldSorted = false
    private var currentKeyPath = [String]()
    private var nextObjectQueue = [[String:Map]]()
    var fetchedObject:Map!
    
    public var delegate:RestBindFillViewDelegate?
    
    private func sortFields() {
        if isFieldSorted == true {
            return
        }
        
        let fieldsSortered = fields.sorted { (parseField1, parseField2) -> Bool in
            if parseField1 is RestBindable && parseField2 is RestBindable {
                return (parseField1 as! RestBindable).fieldPath.components(separatedBy: ".").count < (parseField2 as! RestBindable).fieldPath.components(separatedBy: ".").count
            }else {
                return false
            }
        }
        
        fields = fieldsSortered
        isFieldSorted = true
    }
    
    private func extractValueAndUpdateComponent(map:Map,component:UIView) {
        
        var valueIsPFObject = false
        
        for key in map.JSON.keys {
            valueIsPFObject = map.JSON[key] is [String:Any]
            if valueIsPFObject {
                let filtered = nextObjectQueue.filter {($0.keys.first! == key.capitalizeFirst)}
                if filtered.isEmpty {
                    let downMap = Map(mappingType: .fromJSON, JSON: map.JSON[key] as! [String:Any])
                    nextObjectQueue.append([key:downMap])
                    extractValueAndUpdateComponent(map:downMap,component:component)
                }
                continue
            }
            if key == currentKeyPath.last {
                
                if let map = map.JSON[key] as? [String:Any] {
                    extractValueAndUpdateComponent(map: Map(mappingType: .fromJSON, JSON: map), component: component)
                }else {
                    
                    var value = map.JSON[key]!
                    
                    if let label = component as? UILabel {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value as Any) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        label.text = String(describing: value)
                        self.delegate?.didFill(component: component, value: value as Any)
                    }else if let imageView = component as? UIImageView {
                        if verifyUrl(urlString: value as? String) {
                            
                            if let delegate = delegate {
                                if let newValue = delegate.willFill(component: component, value: value as Any) {
                                    value = newValue
                                }else {
                                    return
                                }
                            }
                            
                            if value is UIImage {
                                imageView.image = (value as! UIImage)
                                self.delegate?.didFill(component: component, value: imageView.image!)
                            }else if value is String {
                                imageView.kf.setImage(with: URL(string:(value as! String)), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                    self.delegate?.didFill(component: component, value: imageView.image ?? UIImage())
                                })
                            }
                            
                        }else {
                            print("field \(key) doesn't contains a valid URL")
                        }
                    }else if let _ = component as? UIScrollView {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value as Any) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                    }else if let textField = component as? UITextField {
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        textField.text = String(describing: value)
                        
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let textView = component as? UITextView {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        textView.text = value as! String
                        
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let slider = component as? UISlider {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        slider.value = value as! Float
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let uiSwitch = component as? UISwitch {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        uiSwitch.isOn = value as! Bool
                        self.delegate?.didFill(component: component, value: value)
                    }
                    
                    return
                }
            }
        }
    }
    
    public func fillFields(withObject object:Map) {
        self.fetchedObject = object
        sortFields()
        if let fields = fields , !fields.isEmpty {
            for field in fields {
                if let field = field as? RestBindable, field is UIView {
                    
                    if  !(field.fieldPath.count > 0) {
                        continue
                    }
                    
                    var keyPath = [String]()
                    var keyPathString = ""
                    for (index,path) in field.fieldPath.components(separatedBy: ".").enumerated() {
                        let path = path
                        if index == 0 {
                            continue
                        }
                        if index != field.fieldPath.components(separatedBy:".").count - 1 {
                            keyPathString = path
                        }
                        keyPath.append(path)
                    }
                    
                    //print(keyPath)
                    currentKeyPath = keyPath
                    
                    if nextObjectQueue.isEmpty {
                        nextObjectQueue.append(["":fetchedObject])
                    }
                    
                    if currentKeyPath.count == 1 {
                        extractValueAndUpdateComponent(map:self.fetchedObject, component: (field as! UIView))
                    }else {
                        
                        let filtered = nextObjectQueue.filter {($0.keys.first! == keyPathString.capitalizeFirst)}
                        if filtered.isEmpty {
                            extractValueAndUpdateComponent(map:self.fetchedObject, component: (field as! UIView))
                        }else {
                            extractValueAndUpdateComponent(map:filtered.first!.values.first!, component: (field as! UIView))
                        }
                    }
                }
            }
            self.delegate?.didFetch(error: nil)
        }
    }
 
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
}
