//
//  CustomCollectionViewCell.swift
//  NewsApp
//
//  Created by BJIT on 22/10/1401 AP.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionCellText: UILabel!
    override func prepareForReuse() {
        collectionCellText.backgroundColor = .white
        }
}
