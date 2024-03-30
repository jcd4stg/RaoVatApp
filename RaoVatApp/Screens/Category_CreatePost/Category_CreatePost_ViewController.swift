//
//  Category_CreatePost_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 11/01/2024.
//

import UIKit

protocol CategoryDelegate {
    func chonNhom(id: String, name: String)
}

class Category_CreatePost_ViewController: UIViewController {

    @IBOutlet weak var myTable_Cate: UITableView!
    
    var arrCategory: [Category] = []
    
    var delegate: CategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTable_Cate.delegate = self
        myTable_Cate.dataSource = self
        
        loadCate()
    }
    
    func loadCate() {
        let url = URL(string: "\(Config.serverURL)/category")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let _ = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data,
                  let res = res as? HTTPURLResponse,
                  err == nil else { return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let listCate = try jsonDecoder.decode(CategoryPost.self, from: data)
                if listCate.kq == 1 {
                    self.arrCategory = listCate.cateList
                    
                    DispatchQueue.main.async {
                        self.myTable_Cate.reloadData()
                    }
                }
            } catch {
                print(err?.localizedDescription ?? "Undefined")
            }
        }.resume()
    }
}

extension Category_CreatePost_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable_Cate.dequeueReusableCell(withIdentifier: Cate_CreatePost_TableViewCell.identifier) as! Cate_CreatePost_TableViewCell
        cell.lbl_Cate_Name.text = arrCategory[indexPath.row].name
        
        let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
        queueLoadCateImg.async {
            
            let urlCateImg = URL(string: "\(Config.serverURL)/upload/\(self.arrCategory[indexPath.row].image)")
            do {
                let data = try Data(contentsOf: urlCateImg!)

                DispatchQueue.main.async {
                    cell.img_Cate.image = UIImage(data: data)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chonNhom(id: arrCategory[indexPath.row]._id, name: arrCategory[indexPath.row].name)
    }
    
}
