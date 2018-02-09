//
//  RestBindTableViewCell.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import ObjectMapper
import ISOnDemandTableView

open class RestBindTableViewCell: UITableViewCell, ISOnDemandTableViewCell {
    
    @IBOutlet public var restBindFillView:RestBindFillView!
    
    public var object:Map!
    
    override open func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    open func setupCell(with object: Any, at indexPath: IndexPath) {
        self.object = object as! Map
        restBindFillView.fetchedObject = self.object
        restBindFillView.fillFields()
    }
    
}
