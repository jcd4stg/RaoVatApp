//
//  CreatePost_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 11/01/2024.
//

import UIKit

class CreatePost_ViewController: UIViewController {
    
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lbl_Nhom: UILabel!
    @IBOutlet weak var lbl_NoiBan: UILabel!
    @IBOutlet weak var txt_TieuDe: UITextField!
    @IBOutlet weak var txt_Gia: UITextField!
    @IBOutlet weak var txt_DienThoai: UITextField!
    
    var idNhom: String!
    var idNoiBan: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dangTin(_ sender: Any) {
        var url = URL(string: "\(Config.serverURL)/uploadFile")
        
        let boundary = UUID().uuidString
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imgData = Data()
        imgData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        imgData.append("Content-Disposition:form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        imgData.append("Content-Type:image/png\r\n\r\n".data(using: .utf8)!)
        imgData.append(imgPost.image!.pngData()!)
        imgData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let _ = URLSession.shared.uploadTask(with: urlRequest, from: imgData) { [weak self] (dataResponse, codeResponse, error) in
            
            guard let dataResponse = dataResponse, let _ = codeResponse as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Not defined")")
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments)
            if let jsonObject = jsonData as? [String: Any] {
                if jsonObject["kq"] as! Int == 1 {
                    let urlFile = jsonObject["urlFile"] as? [String: Any]
                    print(jsonObject)
                    DispatchQueue.main.async {
                        url = URL(string: "\(Config.serverURL)/post/add")
                        
                        var request = URLRequest(url: url!)
                        request.httpMethod = "POST"
                        
                        let fileName = urlFile!["filename"] as! String
                        
                        let sData = "tieuDe=\(self!.txt_TieuDe.text!)&gia=\(self!.txt_Gia.text!)&dienThoai=\(self!.txt_DienThoai.text!)&image=\(fileName)&nhom=\(self!.lbl_Nhom.text!)&noiBan=\(self!.lbl_NoiBan.text!)"
                        
                        let postData = sData.data(using: .utf8)
                        request.httpBody = postData
                        
                        let _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            guard error == nil else { return }
                            
                            guard let data = data else { return }
                            do {
                                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                                
                                print(jsonObject)
                                if (jsonObject["kq"] as! Int == 1) {
                                    // thanh cong
                                
                                    // push to login screen
                                    DispatchQueue.main.async {
                                        let alertView = UIAlertController(title: "Thong Bao 2", message: "POST thanh cong", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                                        alertView.addAction(okAction)
                                        self?.present(alertView, animated: true)
                                    }

                                } else {
                                    // alert
                                    //print(jsonObject["errMsg"])
                                    DispatchQueue.main.async {
                                        let alertView = UIAlertController(title: "Thong Bao", message: "Error", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                                        alertView.addAction(okAction)
                                        self?.present(alertView, animated: true)
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)

                            }
                        }.resume()

                    }
                }
            }
        

        }.resume()
    }
    
    @IBAction func chon_Noi_Ban(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "Place_CreatePost_ViewController") as! Place_CreatePost_ViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func chon_Nhom(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "Category_CreatePost_ViewController") as! Category_CreatePost_ViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func tap_Image(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true)
        
    }
}

extension CreatePost_ViewController: CityDelegate {
    func chooseCity(id: String, name: String) {
        self.navigationController?.popViewController(animated: true)
        lbl_NoiBan!.text = name
        idNoiBan = id
    }
}
extension CreatePost_ViewController: CategoryDelegate {
    func chonNhom(id: String, name: String) {
        self.navigationController?.popViewController(animated: true)
        lbl_Nhom!.text = name
        idNhom = id
    }
}

extension CreatePost_ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgPost.image = image
        } else {
            let alert = UIAlertController(title: "❌", message: "Please choose the image", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        self.dismiss(animated: true)
    }
    
    
}
