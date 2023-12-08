//
//  segHistoryViewController.swift
//  MarkMate
//
//  Created by Macbook on 07/12/2023.
//

import UIKit

struct attendanceHistory {
    let date: String
    let time: String
}
class segHistoryViewController: UIViewController, UITableViewDelegate{
    @IBOutlet weak var searchField: UITextField!
    private let TableView = UITableView()
    let attendanceHistoryList = [attendanceHistory(date: "October 18, 2023", time: "2:44 PM"),attendanceHistory(date: "October 18, 2023", time: "2:44 PM"), attendanceHistory(date: "October 18, 2023", time: "2:44 PM"),attendanceHistory(date: "October 18, 2023", time: "2:44 PM"),attendanceHistory(date: "October 18, 2023", time: "2:44 PM"),attendanceHistory(date: "October 18, 2023", time: "2:44 PM"),attendanceHistory(date: "October 18, 2023", time: "2:44 PM")]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "segAttendanceCell", bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: segStudentCell.cellIdentifier)
        view.addSubview(TableView)
        TableView.delegate = self
        TableView.dataSource = self
        searchField.layer.shadowColor = UIColor.black.cgColor
        searchField.layer.shadowOpacity = 0.5
        searchField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchField.layer.shadowRadius = 4.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TableView.frame = CGRect(x: ((view.bounds.width - 352) / 2), y: 40, width: 352, height: view.bounds.height-80)
    }
}

extension segHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.attendanceHistoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: segAttendanceCell.cellIdentifier, for: indexPath) as! segAttendanceCell
        
        cell.dateLabel.text = attendanceHistoryList[indexPath.section].date + attendanceHistoryList[indexPath.section].time

        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2.0

        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)

        cell.layer.cornerRadius = 8.0
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.section).")
        NotificationCenter.default.post(name: .sessionSelected, object: nil, userInfo: ["sessionInfo": attendanceHistoryList[indexPath.section]])
    }
}
