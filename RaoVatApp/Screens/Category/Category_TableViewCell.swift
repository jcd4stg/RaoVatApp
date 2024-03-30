//
//  Category_TableViewCell.swift
//  RaoVatApp
//
//  Created by lynnguyen on 14/01/2024.
//

import UIKit

class Category_TableViewCell: UITableViewCell {
    
    static let identifier = String(describing: Category_TableViewCell.self)
    
    @IBOutlet weak var imgHinh: UIImageView!
    @IBOutlet weak var tieuDe: UILabel!
    @IBOutlet weak var gia: UILabel!
    @IBOutlet weak var dienThoai: UILabel!
    @IBOutlet weak var nhom: UILabel!
    @IBOutlet weak var noiBan: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
