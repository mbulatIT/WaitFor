//
//  ViewControllersFactory.swift
//  WaitFor
//
//  Created by Maksim Bulat on 01.03.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerFactory {

    internal static func makeActiveEventViewController() -> UIViewController {
        guard let viewController = ActiveEventViewController.storyboardInstance() as? ActiveEventViewController else {
            fatalError("Cannot load view controller from storyboard")
        }
        return viewController
    }
    
    internal static func makeEventsViewController() -> UIViewController {
        guard let viewController = EventsViewController.storyboardInstance() as? EventsViewController else {
            fatalError("Cannot load view controller from storyboard")
        }
        return viewController
    }
    
    internal static func makeNewEventViewController() -> UIViewController {
        guard let viewController = NewEventViewController.storyboardInstance() as? NewEventViewController else {
            fatalError("Cannot load view controller from storyboard")
        }
        return viewController
    }
}
