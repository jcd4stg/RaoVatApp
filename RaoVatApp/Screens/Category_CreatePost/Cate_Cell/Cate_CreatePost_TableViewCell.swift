//
//  Cate_CreatePost_TableViewCell.swift
//  RaoVatApp
//
//  Created by lynnguyen on 11/01/2024.
//

import UIKit

class Cate_CreatePost_TableViewCell: UITableViewCell {

    static let identifier = String(describing: Cate_CreatePost_TableViewCell.self)
    
    @IBOutlet weak var img_Cate: UIImageView!
    @IBOutlet weak var lbl_Cate_Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
