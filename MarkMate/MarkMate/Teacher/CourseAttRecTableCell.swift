//
//  CourseAttRecTableCell.swift
//  MarkMate
//
//  Created by Macbook on 07/12/2023.
//

import UIKit

class CourseAttRecTableCell: UITableViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var PresenceLabel: UILabel!
    
    @IBOutlet weak var ERPLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
