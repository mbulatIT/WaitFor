//
//  Double+Round.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/20/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
