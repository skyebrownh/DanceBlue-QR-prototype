//
//  InfoVC.swift
//  QR-Scanner
//
//  Created by Skye Brown on 9/3/18.
//  Copyright © 2018 Skye Brown. All rights reserved.
//

import UIKit
import SAConfettiView

class InfoVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    var confettiView: SAConfettiView!
    
    var teams = [Team]()
    var sampleTeams = [Team(teamName: "Team1", uid: ""),
                       Team(teamName: "Team2", uid: ""),
                       Team(teamName: "Team3", uid: ""),
                       Team(teamName: "Team4", uid: ""),
                       Team(teamName: "Team5", uid: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        teamTextField.delegate = self
        
        createPickerView()
        createToolbar()
        
        modalPresentationCapturesStatusBarAppearance = true
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        self.view.sendSubviewToBack(confettiView)
        confettiView.colors = [UIColor.blue, UIColor.yellow, UIColor.white]
        confettiView.intensity = 1.0
        confettiView.startConfetti()
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        teamTextField.inputView = pickerView
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension InfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sampleTeams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sampleTeams[row].teamName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teamTextField.text = sampleTeams[row].teamName
    }
}

extension InfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confettiView.stopConfetti()
    }
}
