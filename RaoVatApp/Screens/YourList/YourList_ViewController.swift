//
//  YourList_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 21/12/2023.
//

import UIKit

class YourList_ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func goTo_CreatePost(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: "CreatePost_ViewController") as! CreatePost_ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
