//
//  Login_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 22/12/2023.
//

import UIKit

class Login_ViewController: UIViewController {

    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func gotoNewDashboard() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let dashboardVC = sb.instantiateViewController(withIdentifier: "DASHBOARD") as! Dashboard_ViewController
        
        
        self.navigationController?.pushViewController(dashboardVC, animated: false)
    }
    
    @IBAction func login(_ sender: Any) {
        
        // send username and password
        
        let url = URL(string: "\(Config.serverURL)/login")
    
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let sData = "username=\(txt_Username.text!)&password=\(txt_Password.text!)"

        let postData = sData.data(using: .utf8)
        request.httpBody = postData

        let taskUserLogin = URLSession.shared.dataTask(with: request) { (data, response, error)in
            guard error == nil else { return }
            
            guard let data = data else {
                return
            }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
                if (jsonObject["kq"] as! Int == 1) {
                    // thanh cong
                    print(jsonObject)
                    let defaults = UserDefaults.standard
                    defaults.setValue(jsonObject["token"], forKey: "UserToken")
                    
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Thong Bao", message: "Login successfully", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
                            
                            self.gotoNewDashboard()
                        }
                        alertView.addAction(okAction)
                        self.present(alertView, animated: true)

                    }

                    // push to login screen
                } else {
                    // alert
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Thong Bao", message: jsonObject["errMsg"] as? String, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                        alertView.addAction(okAction)
                        self.present(alertView, animated: true)

                    }
                                                   
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        taskUserLogin.resume()

    }
    
    @IBAction func register(_ sender: Any) {
        
        
    }
}
