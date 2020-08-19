//
//  UIView.swift
//  BLEPeripheral
//
//  Created by Agustin Castaneda on 18/08/20.
//  Copyright © 2020 Agustin Castaneda. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewForAutoLayout(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
    }
}
