//
//  bookmarkCell.swift
//  NewsApp
//
//  Created by BJIT on 28/10/1401 AP.
//

import UIKit

class bookmarkCell: UITableViewCell {
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
