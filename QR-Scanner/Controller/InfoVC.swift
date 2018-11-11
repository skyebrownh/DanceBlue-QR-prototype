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
import SwiftyJSON

class InfoVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var confettiView: SAConfettiView!
    var URL: String?
    
    let pickerView = UIPickerView()
    
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
        signInButton.layer.cornerRadius = 5;
        
        createPickerView()
        createToolbar()
        
        modalPresentationCapturesStatusBarAppearance = true
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        // get all teams
        getTeams()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(URL as Any)
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        self.view.sendSubviewToBack(confettiView)
        confettiView.colors = [UIColor(red:0.02, green:0.22, blue:0.62, alpha:1.0), UIColor(red:0.95, green:0.74, blue:0.27, alpha:1.0)]
        confettiView.intensity = 1.0
        confettiView.startConfetti()
        
        // instantiate back button
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: 80, height: 40))
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        button.setTitle("BACK", for: .normal)
        button.layer.cornerRadius = 0.5 * button.frame.height
        button.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createCALayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func newButtonAction() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func createPickerView() {
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
    
    func createCALayer() {
        // function that creates the blue top overlay
        
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.height * 2, height: self.view.frame.height * 2))
        
        let delta = self.view.frame.height - 0.5 * self.view.frame.width
        layer.frame.origin.x -= delta
        layer.frame.origin.y -= 1.6 * self.view.frame.height
        layer.cornerRadius = 0.5 * layer.frame.height
        layer.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        self.view.layer.insertSublayer(layer, at: 0)
        self.view.clipsToBounds = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard var receivedURL = URL else { return }
        guard let team = selectedTeam else { return }
        guard let name = nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let appendString: String = "&teamId=\(team.uid)&name=\(name)";
        
        receivedURL += appendString
        //        print(receivedURL)
        Alamofire.request(receivedURL)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func getTeams() {
        // http request to populate teams array with teams
        Alamofire.request("http://192.168.1.171:8000/api/getTeamNames").responseJSON { (response) in

//            print(response)

            guard let data = response.data else {
                print("failed response.data")
                return
            }
//            print(data)
            do {
                let jsonResponse = try JSON(data: data)
                guard let jsonData = jsonResponse["teams"].array else {
                    print("failed JSON(data: data)")
                    return
                }
                print("JSON data: ", jsonData)
                
                for teamData in jsonData {
                    print("Team data: ", teamData)
                    if let teamName = teamData["teamName"].string,
                    let teamID = teamData["id"].int {
                        let team = Team(teamName: teamName, uid: String(teamID))
                        self.teams.append(team)
                        print("Team count: ", self.teams.count)
                    }
                }
                self.pickerView.reloadAllComponents()
            } catch {
                print("error trying to print JSON data")
            }
        }
    }
    
}

extension InfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row].teamName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teamTextField.text = teams[row].teamName
        selectedTeam = teams[row]
    }
}

extension InfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confettiView.stopConfetti()
    }
}
