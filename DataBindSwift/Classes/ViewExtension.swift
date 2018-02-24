//
//  ViewExtension.swift
//  DataBindSwift
//
//  Created by Daniel Amaral on 20/02/18.
//

import UIKit

extension UIView {
    
    func getSubviewsOfView(recursive: Bool = false) -> [DataBindable] {
        return self.getSubviewsInner(view: self, recursive: recursive)
    }
    
    private func getSubviewsInner(view: UIView, recursive: Bool = false) -> [DataBindable] {
        var subviewArray = [DataBindable]()
        guard view.subviews.count>0 else { return subviewArray }
        view.subviews.forEach {
            if recursive {
                subviewArray += self.getSubviewsInner(view: $0, recursive: recursive) as [DataBindable]
            }
            if let subview = $0 as? DataBindable {
                subviewArray.append(subview)
            }
        }
        return subviewArray
    }
    
}
