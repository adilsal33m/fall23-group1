//
//  SegStudentViewController.swift
//  MarkMate
//
//  Created by Abdur Rafae on 02/12/2023.
//

import UIKit

class SegStudentViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var searchField: UITextField!
    private let TableView = UITableView()
    let students = [studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828),studentCellData(name: "ABC", percentage: 23, Erp: 22828)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "segStudentCell", bundle: nil)
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
        TableView.frame = CGRect(x: ((view.bounds.width - 352) / 2)-20, y: 40, width: 352, height: view.bounds.height-170)
    }

}

extension SegStudentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: segStudentCell.cellIdentifier, for: indexPath) as! segStudentCell
        
        cell.studentNameLabel.text = students[indexPath.section].name
        cell.studentERPLabel.text = "\(students[indexPath.section].Erp)"
        cell.studentAttendanceLabel.text = "\(students[indexPath.section].percentage) %"
        if students[indexPath.section].percentage <= 60 {
            cell.studentAttendanceLabel.textColor = UIColor.red
        }
        else {
            cell.studentAttendanceLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
        }
       
        
        
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2.0

        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)

        cell.layer.cornerRadius = 8.0
        return cell
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        print("You tapped cell number \(indexPath.section).")
    }
}

struct studentCellData {
    var name: String
    var percentage: Int
    var Erp: Int
}
