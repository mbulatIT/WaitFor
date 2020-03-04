//
//  ActivitiesTableViewController.swift
//  WaitFor
//
//  Created by Maksim Bulat on 22.02.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    var needsUpdate = false
    var events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.noEventsLabel.isHidden = !self.events.isEmpty                
            }
        }
    }
    var activeEvent: Event?

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "События"
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onPlusButton))
        barButton.tintColor = .defaultYellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onPlusButton))
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if needsUpdate {
            reloadData()
            needsUpdate = false
        }
    }
    
    func reloadData() {
        let group = DispatchGroup()
        group.enter()
        EventManager.shared.getActiveEvent { (event) in
            self.activeEvent = event
            group.leave()
        }
        group.enter()
        EventManager.shared.getEvents() { events in
            self.events = events
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    @objc
    func onPlusButton() {
        let viewController = ViewControllerFactory.makeNewEventViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSelectAlert(event: Event) {
        let alert = UIAlertController(title: event.title, message: "Сделать событие активным?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (_) in
            EventManager.shared.setActiveEvent(event)
            self.needsUpdate = true
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0
            }
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alert, animated: true)
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.reusableIdentifier) as? EventTableViewCell else {
            return UITableViewCell()
        }
        let event = events[indexPath.row]
        cell.titleLabel.text = event.title
        cell.titleLabel.font = UIFont.systemFont(ofSize: 15)
        cell.titleLabel.font = event.id == activeEvent?.id ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 15)
        cell.activeImageView.image = event.id == activeEvent?.id ? UIImage(systemName: "clock") : nil
        cell.backgroundColor = .clear
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        EventManager.shared.removeEvent(events[indexPath.row]) { events in
            self.events = events
            DispatchQueue.main.async {
                self.tableView.reloadData()                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showSelectAlert(event: events[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension EventsViewController: TabBarViewControllerProtocol {
    func tabBarItemImages() -> (normalImage: UIImage?, selectedImage: UIImage?) {
        return (UIImage(systemName: "list.bullet")!, UIImage(systemName: "list.bullet")!)
    }
    
    func tabBarItemTitle() -> String {
        return ""
    }
    
    
}
