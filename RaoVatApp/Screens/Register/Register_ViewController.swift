//
//  Register_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 17/12/2023.
//

import UIKit

struct File: Decodable {
    var kq: Int
    var urlFile: String
}

class Register_ViewController: UIViewController {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_FullName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Address: UITextField!
    @IBOutlet weak var txt_PhoneNumber: UITextField!
    
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySpinner.isHidden = true
        txt_Username.text = "Teo"
        txt_Password.text = "123456"
        txt_FullName.text = "Teo"
        txt_Email.text = "teo@yahoo.com"
        txt_Address.text = "12 le lai"
        txt_PhoneNumber.text = "0812421123"
    }
    
    @IBAction func chooseImageFromPhotoGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true)
        
        
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        
        mySpinner.isHidden = false
        mySpinner.startAnimating()
        // upload Avatar
        
        var url = URL(string: "\(Config.serverURL)/uploadFile")
        
        let boundary = UUID().uuidString
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imgData = Data()
        
        imgData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        imgData.append("Content-Disposition:form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        imgData.append("Content-Type:image/png\r\n\r\n".data(using: .utf8)!)
        imgData.append(imgAvatar.image!.pngData()!)
        imgData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        let _ = URLSession.shared.uploadTask(with: urlRequest, from: imgData) { [weak self] (dataResponse, codeResponse, error) in
            
            guard let self = self else {
                print("")
                return
            }
            guard let dataResponse = dataResponse, let _ = codeResponse as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Not defined")")
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments)
            if let jsonObject = jsonData as? [String: Any] {
                if jsonObject["kq"] as! Int == 1 {
                    
                    // available urlFile
                    let urlFile = jsonObject["urlFile"] as? [String: Any]
                    
                    // 2.send user register infomation
                    DispatchQueue.main.async {
                        url = URL(string: "\(Config.serverURL)/register")
                        
                        var request = URLRequest(url: url!)
                        request.httpMethod = "POST"
                        
                        let fileName = urlFile!["filename"] as! String
                        let sData = "username=\(self.txt_Username.text!)&password=\(self.txt_Password.text!)&name=\(self.txt_FullName.text!)&image=\(fileName)&email=\(self.txt_Email.text!)&address=\(self.txt_Address.text!)&phoneNumber=\(self.txt_PhoneNumber.text!)"
                        
                        let postData = sData.data(using: .utf8)
                        request.httpBody = postData
                        
                        let _ = URLSession.shared.dataTask(with: request) { (data, response, error)in
                            guard error == nil else { return }
                            
                            guard let data = data else { return }
                            
                            do {
                                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                
                                DispatchQueue.main.async {
                                    self.mySpinner.isHidden = true
                                }
                                
                                if (jsonObject["kq"] as! Int == 1) {
                                    // thanh cong
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
                        }.resume()
                    }
                    
                } else {
                    print("Upload failed!")
                }
            }
        }.resume()
        
    }
    
    
    
    func uploadImageToServer() {
        
        mySpinner.isHidden = false
        mySpinner.startAnimating()
        
        guard let url = URL(string: "\(Config.serverURL)/uploadFile") else {
            print("URL is error")
            return
        }
        
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        
        imageData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        imageData.append("Content-Disposition:form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        imageData.append("Content-Type:image/png\r\n".data(using: .utf8)!)
        imageData.append(imgAvatar.image!.pngData()!)
        imageData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let _ = URLSession.shared.uploadTask(with: request, from: imageData) { [weak self] (data, res, err) in
            guard let self = self else { return }
            guard let data = data, let res = res as? HTTPURLResponse, err == nil else {
                print("Error: \(String(describing: err?.localizedDescription))")
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let jsonObject = jsonData as? [String: Any] {
                if jsonObject["kq"] as! Int == 1 {
                    let urlFile = jsonObject["urlFile"] as? [String: Any]
                    
                    DispatchQueue.main.async {
                        let url = URL(string: "\(Config.serverURL)/register")
                        var request = URLRequest(url: url!)
                        request.httpMethod = "POST"
                        
                        let filename = urlFile!["filename"] as! String
                        let sData = "username=\(self.txt_Username.text!)&password=\(self.txt_Password.text!)&name=\(self.txt_FullName.text!)&image=\(filename)&email=\(self.txt_Email.text!)&address=\(self.txt_Address.text!)&phoneNumber=\(self.txt_PhoneNumber.text!)"
                        
                        request.httpBody = sData.data(using: .utf8)
                        
                        let _ = URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
                            guard let self = self else { return }
                            guard let data = data, let res = res as? HTTPURLResponse, err == nil else {
                                print("Error: \(String(describing: err?.localizedDescription))")
                                return
                            }
                            
                            do {
                                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                DispatchQueue.main.async {
                                    self.mySpinner.stopAnimating()
                                    self.mySpinner.isHidden = true
                                }
                                
                                if jsonObject["kq"] as! Int == 1 {
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        let alertView = UIAlertController(title: "Thong Bao", message: jsonObject["errMsg"] as? String, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                                        alertView.addAction(okAction)
                                        self.present(alertView, animated: true)
                                        
                                    }
                                }
                            } catch {
                                print(err?.localizedDescription ?? "Undefined")
                            }
                            
                        }.resume()
                    }
                } else {
                    print("Upload failed")
                }
            }
            
        }.resume()
    }
    
}

extension Register_ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvatar.image = image
        } else {
            let alert = UIAlertController(title: "❌", message: "Please choose the image", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        self.dismiss(animated: true)
    }
}

