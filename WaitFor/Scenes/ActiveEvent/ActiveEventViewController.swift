//
//  ViewController.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class ActiveEventViewController: UIViewController {

    @IBOutlet weak var timeLeftView: SpentTimeView!
    @IBOutlet weak var timeSpentView: SpentTimeView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeftView.title = "Осталось"
        timeSpentView.title = "Прошло"
        tabBarController?.tabBar.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventManager.shared.getActiveEvent(completion: { (event) in
            self.event = event
            DispatchQueue.main.async {
                guard let event = event else {
                    self.showNoEventAlert()
                    return
                }
                self.timeLeftView.date = event.endDate
                self.timeSpentView.date = event.startDate
                self.navigationItem.title = event.title
                self.segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                self.segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    self.progressBar.setProgress(self.calculateProgress())
                }
            }
        })
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
        guard let event = event else {
            return 0
        }
        let eventProgress = Calendar.current.dateComponents([.second], from: event.startDate, to: Date()).second ?? 0
        return Double(eventProgress) / Double(Calendar.current.dateComponents([.second], from: event.startDate, to: event.endDate).second ?? 0)
    }
    
    private func showNoEventAlert() {
        let alert = UIAlertController(title: "Упс", message: "Похоже у вас пока нет активного события", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Перейти к списку событий", style: .default, handler: { (_) in
            self.tabBarController?.selectedIndex = 1
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ActiveEventViewController: TabBarViewControllerProtocol {
    func tabBarItemImages() -> (normalImage: UIImage?, selectedImage: UIImage?) {
        return (UIImage(systemName: "clock")!, UIImage(systemName: "clock"))
    }
    
    func tabBarItemTitle() -> String {
        return ""
    }
    
    
}

