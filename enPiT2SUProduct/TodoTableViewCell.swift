//
//  TodoTableViewCell.swift
//  enPiT2SUProduct
//
//  Created by funabashi naoyuki on 2021/11/18.
//

import UIKit
import RealmSwift

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todocount: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
