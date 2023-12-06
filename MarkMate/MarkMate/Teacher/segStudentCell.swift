//
//  segStudentCell.swift
//  MarkMate
//
//  Created by Macbook on 06/12/2023.
//

import UIKit

class segStudentCell: UITableViewCell {

    static let cellIdentifier = "cell"
    @IBOutlet weak var studentAttendanceLabel: UILabel!
    @IBOutlet weak var studentERPLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
