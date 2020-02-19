//
//  SpentTimeView.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class SpentTimeView: BaseView {

    enum DisplayType {
        case day
        case monthDay
        case monthWeekDay
        case weekDay

        fileprivate func cellsCount() -> Int {
            switch self {
            case .day:
                return 4
            case .monthDay, .weekDay:
                return 5
            case .monthWeekDay:
                return 6
            }
        }

        fileprivate func titleForCellAt(indexPath: IndexPath) -> String {
            switch indexPath.row {
            case 0:
                switch self {
                case .day:
                    return "дня"
                case .monthDay, .monthWeekDay:
                    return "месяцев"
                case .weekDay:
                    return "недель"
                }
            case 1:
                switch self {
                case .day:
                    return "часов"
                case .monthDay:
                    return "дней"
                case .monthWeekDay:
                    return "недель"
                case .weekDay:
                    return "дней"
                }
            case 2:
                switch self {
                case .day:
                    return "минут"
                case .monthDay:
                    return "часов"
                case .monthWeekDay:
                    return "дней"
                case .weekDay:
                    return "часов"
                }
            case 3:
                switch self {
                case .day:
                    return "секунд"
                case .monthDay:
                    return "минут"
                case .monthWeekDay:
                    return "часов"
                case .weekDay:
                    return "минут"
                }
            case 4:
                switch self {
                case .monthDay:
                    return "секунд"
                case .monthWeekDay:
                    return "минут"
                case .weekDay:
                    return "секунд"
                default:
                    return ""
                }
            case 5:
                switch self {
                case .monthWeekDay:
                    return "секунд"
                default:
                    return ""
                }
            default:
                return ""
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: TableViewWithoutScroll!
    @IBOutlet var view: UIView!

    var displayType: DisplayType = .day {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var date = Date() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var title = "" {
        willSet(value) {
            DispatchQueue.main.async {
                self.titleLabel.text = value
            }
        }
    }

    override func setup() {
        UINib(nibName: "SpentTimeView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        clipViewToBounds(view: view)
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = title
    }
}

extension SpentTimeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayType.cellsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = displayType.titleForCellAt(indexPath: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}
