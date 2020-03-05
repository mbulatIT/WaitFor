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
    private var navigationTitleButton = UIButton()
    private var selectActiveViewController: SelectActiveViewController?
    
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeftView.title = "Осталось"
        timeSpentView.title = "Прошло"
        tabBarController?.tabBar.clipsToBounds = true
        navigationItem.titleView = navigationTitleButton
        navigationTitleButton.tintColor = .white
        navigationTitleButton.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        navigationTitleButton.addTarget(self, action: #selector(showSelectEventViewController), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectActiveViewController = selectActiveViewController {
            selectActiveViewController.dismiss(animated: false)
            navigationItem.rightBarButtonItem = nil
            navigationTitleButton.isEnabled = true
            self.selectActiveViewController = nil
        }
    }
    
    private func reloadData() {
        EventManager.shared.getActiveEvent(completion: { (event) in
            self.event = event
            DispatchQueue.main.async {
                guard let event = event else {
                    self.showNoEventAlert()
                    return
                }
                self.timeLeftView.date = event.endDate
                self.timeSpentView.date = event.startDate
                self.navigationTitleButton.setTitle(event.title, for: .normal)
                self.navigationTitleButton.sizeToFit()
                
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
    
    @objc
    private func showSelectEventViewController() {
        navigationTitleButton.isEnabled = false
        selectActiveViewController = UIStoryboard(name: "ActiveEventViewController", bundle: nil).instantiateViewController(identifier: "SelectActiveViewController") as SelectActiveViewController
        guard let selectActiveViewController = selectActiveViewController else {
            return
        }
        selectActiveViewController.preferredContentSize = CGSize(width: view.frame.width * 0.7, height: 200)
        selectActiveViewController.modalPresentationStyle = .popover
        if let ppc = selectActiveViewController.popoverPresentationController {
            ppc.sourceView = navigationItem.titleView
            ppc.sourceRect = navigationTitleButton.frame
            ppc.permittedArrowDirections = .up
            ppc.delegate = self
            var passthroughViews = [UIView]()

            if let tabbar = tabBarController?.tabBar {
                passthroughViews.append(contentsOf: tabbar.subviews)
                passthroughViews.append(tabbar)
            }
            
            if let navigationBar = navigationController?.navigationBar {
                passthroughViews.append(contentsOf: navigationBar.subviews)
                passthroughViews.append(navigationBar)
            }

            ppc.passthroughViews = passthroughViews
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(onDoneButton))
        navigationItem.rightBarButtonItem?.tintColor = .white
        present(selectActiveViewController, animated: true)
    }
    
    @objc
    private func onDoneButton() {
        guard let selectActiveViewController = selectActiveViewController else {
            return
        }
        let activeEvent = selectActiveViewController.selectedEvent
        EventManager.shared.setActiveEvent(activeEvent)
        reloadData()
        navigationItem.rightBarButtonItem?.tintColor = .clear
        selectActiveViewController.dismiss(animated: true) {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationTitleButton.isEnabled = true
            self.selectActiveViewController = nil
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

extension ActiveEventViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        navigationItem.rightBarButtonItem = nil
        navigationTitleButton.isEnabled = true
        self.selectActiveViewController = nil
        return true
    }
    
}
