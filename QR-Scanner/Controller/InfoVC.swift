//
//  InfoVC.swift
//  QR-Scanner
//
//  Created by Skye Brown on 9/3/18.
//  Copyright © 2018 Skye Brown. All rights reserved.
//

import UIKit
import SAConfettiView
import Alamofire

class InfoVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    var confettiView: SAConfettiView!
    var URL: String?
    
    var teams = [Team]()
    var sampleTeams = [Team(teamName: "Team1", uid: "1"),
                       Team(teamName: "Team2", uid: "2"),
                       Team(teamName: "Team3", uid: "3"),
                       Team(teamName: "Team4", uid: "4"),
                       Team(teamName: "Team5", uid: "5")]
    var selectedTeam: Team?
    
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
        print(URL as Any)
        
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
        guard var receivedURL = URL else { return }
        guard let team = selectedTeam else { return }
        guard let name = nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let appendString: String = "&teamId=\(team.uid)&name=\(name)";
        
        receivedURL += appendString
        print(receivedURL)
        Alamofire.request(receivedURL)
        
//        NetworkService.instance.body = ["name": nameTextField.text as Any, "team": teamTextField.text as Any]
//        NetworkService.instance.postData()
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
        selectedTeam = sampleTeams[row]
    }
}

extension InfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confettiView.stopConfetti()
    }
}
