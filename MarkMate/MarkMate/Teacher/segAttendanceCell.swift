//
//  segAttendanceCell.swift
//  MarkMate
//
//  Created by Macbook on 07/12/2023.
//

import UIKit

class segAttendanceCell: UITableViewCell {

    static let cellIdentifier = "cell"
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
