//
//  NewEventViewController.swift
//  WaitFor
//
//  Created by Maksim Bulat on 23.02.2020.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class NewEventViewController: ScrollContentViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    @IBOutlet weak var startDatePickerView: UIDatePicker!
    @IBOutlet weak var endDatePickerView: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollContentView: TappableScrollView!
    @IBOutlet weak var startDatePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var endDatePickerHeightConstraint: NSLayoutConstraint!
    private let dateFormatter = DateFormatter()
    private let placeholderText = "Название.."
    private var isStartDateSelected = false
    private var isEndDateSelected = false
    
    
    override var scrollView: TappableScrollView? {
        return scrollContentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor(hex: 0xDADB3E, alpha: 0.7).cgColor
        titleTextField.delegate = self
        titleTextField.text = placeholderText
        endDatePickerView.minimumDate = startDatePickerView.date
        navigationController?.title = "Новое событие"
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func startDateChanged(_ sender: Any) {
        startDateButton.setTitle("Начало: \(dateFormatter.string(from: startDatePickerView.date))", for: .normal)
        endDatePickerView.minimumDate = startDatePickerView.date
        endDateButton.setTitle("Конец: \(dateFormatter.string(from: startDatePickerView.date))", for: .normal)
    }

    @IBAction func endDateChanged(_ sender: Any) {
        endDateButton.setTitle("Конец: \(dateFormatter.string(from: endDatePickerView.date))", for: .normal)
    }
    
    @IBAction func onSaveEventButton(_ sender: Any) {
        guard let title = titleTextField.text else {
            print("Title cannot be nil")
            return
        }
        guard isStartDateSelected else {
            showErrorAlert(message: "Пожалуйста, выберите дату начала события")
            return
        }
        
        guard isEndDateSelected else {
            showErrorAlert(message: "Пожалуйста, выберите дату окончания события")
            return
        }
        
        guard titleTextField.text?.isEmpty == false else {
            showErrorAlert(message: "Пожалуйста, введите название события")
            return
        }

        let event = Event(title: title, startDate: startDatePickerView.date, endDate: endDatePickerView.date)
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        EventManager.shared.addEvent(event) { (_) in
            DispatchQueue.main.async {
                if let viewController = self.navigationController?.viewControllers.first(where: { $0 as? EventsViewController != nil }),
                    let eventsViewController = viewController as? EventsViewController {
                    eventsViewController.needsUpdate = true
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func onStartDateButton(_ sender: Any) {
        isStartDateSelected = true
        let isSelected = !startDateButton.isSelected
        startDateButton.isSelected = isSelected
        self.startDatePickerHeightConstraint.priority = isSelected ? UILayoutPriority(700) : UILayoutPriority(rawValue: 800)
        self.startDatePickerView.isHidden = isSelected ? false : true
        startDateButton.setTitle("Начало: \(dateFormatter.string(from: startDatePickerView.date))", for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func onEndDateButton(_ sender: Any) {
        isEndDateSelected = true
        let isSelected = !endDateButton.isSelected
        endDateButton.isSelected = isSelected
        endDatePickerHeightConstraint.priority = isSelected ? UILayoutPriority(700) : UILayoutPriority(rawValue: 800)
        endDateButton.setTitle("Конец: \(dateFormatter.string(from: endDatePickerView.date))", for: .normal)
        endDatePickerView.isHidden = isSelected ? false : true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Проблемка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension NewEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == placeholderText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil {
            textField.text = placeholderText
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil {
            textField.text = placeholderText
        }
    }
}
