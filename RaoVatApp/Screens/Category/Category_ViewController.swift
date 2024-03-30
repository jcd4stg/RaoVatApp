//
//  Category_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 21/12/2023.
//

import UIKit

class Category_ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
        
    var categories = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategory()

    }
    
    func fetchCategory() {
        
        let url = URL(string: "\(Config.serverURL)/post")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let _ = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data,
                  let _ = res as? HTTPURLResponse,
                  err == nil else { return }
            print(data)
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let jsonObject = jsonData as? [String: Any] {
                print(jsonObject)
                if jsonObject["kq"] as! Int == 1 {
                    let listPost = jsonObject["listPost"] as? [[String: Any]]
                    self.categories = listPost!
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
            
        }.resume()

    }

}

extension Category_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Category_TableViewCell.identifier) as! Category_TableViewCell
        let category = categories[indexPath.row]
        cell.dienThoai!.text = category["dienThoai"] as? String
        cell.gia.text = category["gia"] as? String
        cell.nhom.text = category["nhom"] as? String
        cell.tieuDe.text = category["tieuDe"] as? String
        cell.noiBan.text = category["noiBan"] as? String
        
        let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
        queueLoadCateImg.async {
            
            let urlCateImg = URL(string: "\(Config.serverURL)/upload/\(category["image"]!)")
            do {
                let data = try Data(contentsOf: urlCateImg!)

                DispatchQueue.main.async {
                    cell.imgHinh.image = UIImage(data: data)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width / 2.5
    }
}
