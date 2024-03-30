//
//  Place_CreatePost_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 12/01/2024.
//

import UIKit

protocol CityDelegate {
    func chooseCity(id: String, name: String)
}
class Place_CreatePost_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrCity: [City] = []
    
    var delegate: CityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadCity()
    }
    
    func loadCity() {
        let url = URL(string: "\(Config.serverURL)/city")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let _ = URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data,
                  let res = res as? HTTPURLResponse,
                  err == nil else { return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let listCity = try jsonDecoder.decode(CityPost.self, from: data)
                if listCity.kq == 1 {
                    self.arrCity = listCity.list
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(err?.localizedDescription ?? "Undefined")
            }
        }.resume()
    }

}

extension Place_CreatePost_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CITY_CELL")
        cell?.textLabel!.text = arrCity[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.chooseCity(id: arrCity[indexPath.row]._id, name: arrCity[indexPath.row].name)
    }
    
}
