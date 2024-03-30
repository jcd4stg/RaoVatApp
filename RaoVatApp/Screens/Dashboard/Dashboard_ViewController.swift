//
//  Dashboard_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 21/12/2023.
//

import UIKit

class Dashboard_ViewController: UIViewController {
    
    @IBOutlet weak var img_Avatar: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_Avatar.layer.cornerRadius = img_Avatar.frame.size.width / 2
        // hide back buttonItem
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // check login
        checkAuthentication()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        if let userToken = defaults.string(forKey: "UserToken") {
            logout(token: userToken)
        } else {
            self.defaults.removeObject(forKey: "UserToken")
            DispatchQueue.main.async {
                self.goToLoginScreen()
            }

        }
        
    }
    
    func checkAuthentication() {
        if let userToken = defaults.string(forKey: "UserToken") {
            // đã có token => verify
            verifyToken(token: userToken)
            
        } else {
            
            goToLoginScreen()
        }

    }
    func goToLoginScreen() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    func verifyToken(token: String) {
        
        let url = URL(string: "\(Config.serverURL)/verify")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let sData = "token=\(token)"
        
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
                    let user = jsonObject["user"] as! [String: Any]
                    
                    let imgAvatar = user["image"] as? String
                    
                    let queue = DispatchQueue(label: "uploadInformationInDashBoard")
                    queue.async {
                        let urlAvatar = URL(string: "\(Config.serverURL)/upload/\(imgAvatar!)")
                        
                        do {
                            let imgData = try Data(contentsOf: urlAvatar!)
                            DispatchQueue.main.async {
                                self.img_Avatar.image = UIImage(data: imgData)
                            }
                        } catch {
                            print("Error image url")
                        }
                        
                        DispatchQueue.main.async {
                            self.lbl_Name.text = user["name"] as? String
                            self.lbl_Address.text = user["address"] as? String
                            
                            
                        }
                    }
                    
                } else {
                    // that bai
                    // alert
                    self.goToLoginScreen()

                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        taskUserLogin.resume()
        
    }
    
    func logout(token: String) {
        let url = URL(string: "\(Config.serverURL)/logout")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        
        let sData = "token=\(token)"
        
        let postData = sData.data(using: .utf8)
        request.httpBody = postData
        
        let taskUserLogout = URLSession.shared.dataTask(with: request) { (data, response, error)in
            guard error == nil else { return }
            
            guard let data = data else {
                return
            }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
                if (jsonObject["kq"] as! Int == 1) {
                    // thanh cong
                    self.defaults.removeObject(forKey: "UserToken")
                    DispatchQueue.main.async {
                        self.goToLoginScreen()
                    }
                } else {
                    // alert
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Thong Bao", message: jsonObject["errMsg"] as! String, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                        alertView.addAction(okAction)
                        self.present(alertView, animated: true)
                        
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        taskUserLogout.resume()
        
        
    }
}

