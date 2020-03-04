//
//  TabbarViewControllerProtocol.swift
//  WaitFor
//
//  Created by Maksim Bulat on 01.03.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarViewControllerProtocol {
    func tabBarItemImages() -> (normalImage: UIImage?, selectedImage: UIImage?)
    func tabBarItemTitle() -> String
}
