//
//  ViewController.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLeftView: SpentTimeView!
    @IBOutlet weak var timeSpentView: SpentTimeView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    let event = EventManager.shared.getEvent()

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeftView.title = "Осталось"
        timeSpentView.title = "Прошло"
        timeLeftView.date = event.endDate
        timeSpentView.date = event.startDate
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.progressBar.setProgress(self.calculateProgress())
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func onSegmentedControlValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            timeSpentView.displayType = .day
            timeLeftView.displayType = .day
        case 1:
            timeSpentView.displayType = .monthDay
            timeLeftView.displayType = .monthDay
            case 2:
                timeSpentView.displayType = .monthWeekDay
                timeLeftView.displayType = .monthWeekDay
            case 3:
                timeSpentView.displayType = .weekDay
                timeLeftView.displayType = .weekDay
        default:
            return
        }
    }
    
    private func calculateProgress() -> Double {
        let eventProgress = Calendar.current.dateComponents([.second], from: event.startDate, to: Date()).second ?? 0
        return Double(eventProgress) / Double(event.durationInSeconds())
    }
    
}

