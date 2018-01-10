//
//  CustomCellDelegator.swift
//  TodoApp_iPhone
//
//  Created by Kevin Li on 1/9/18.
//  Copyright © 2018 Kevin Li. All rights reserved.
//

import Foundation

// protocol allowing for button in table view cell to perform segue
protocol CustomCellDelegator {
    func callSegueFromCell(withCellData data: Any?)
}
