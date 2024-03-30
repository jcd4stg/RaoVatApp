//
//  Welcome_ViewController.swift
//  RaoVatApp
//
//  Created by lynnguyen on 21/12/2023.
//

import UIKit

class Welcome_ViewController: UIViewController {
    
    @IBOutlet weak var img_BG: UIImageView!
    @IBOutlet weak var img_Logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let widthView = view.frame.size.width
        let heightView = view.frame.size.height
        
        //bg image
        img_BG.alpha = 0.3
        img_Logo.frame.origin.x = 0 - img_Logo.frame.size.width
        img_BG.frame.origin = CGPoint(x: 0, y: 0)
        img_BG.frame.size.width = widthView
        img_BG.frame.size.height = heightView
        
        UIView.animate(withDuration: 3) { [weak self] in
            self?.img_BG.frame.size.width = widthView * 2
            self?.img_BG.frame.size.height = heightView * 2
            
            self?.img_BG.frame.origin = CGPoint(x: widthView / 2 - ((widthView * 2) / 2), y:  heightView / 2 - ((heightView * 2) / 2))
            
        } completion: { _ in
            
            
            UIView.animate(withDuration: 2) {
                self.img_BG.alpha = 0.5
                self.img_BG.frame.size = CGSize(width: widthView, height: heightView)
                self.img_BG.frame.origin = CGPoint(x: 0, y: 0)
            }
        }
        
        // logo image
        UIView.animate(withDuration: 5, animations: {
            self.img_Logo.frame.origin = CGPoint(
                x: widthView / 2 - (self.img_Logo.frame.size.width / 2),
                y: heightView / 2 - (self.img_Logo.frame.size.height / 2)
            )
        })
    }
}

