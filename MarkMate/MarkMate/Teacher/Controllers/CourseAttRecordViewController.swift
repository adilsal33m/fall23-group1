//
//  CourseAttRecordViewController.swift
//  MarkMate
//
//  Created by Macbook on 07/12/2023.
//

import UIKit

struct attendanceRecord{
    let name: String
    let ERP: String
    let Presence: Character
}

class CourseAttRecordViewController: UIViewController, UITableViewDelegate {


    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CountView: UIView!
    @IBOutlet weak var TotalCountLabel: UILabel!
    @IBOutlet weak var AbsentCountLabel: UILabel!
    @IBOutlet weak var PresentCountLabel: UILabel!
    var date = ""
    var time = ""
    private let TableView = UITableView()
    let attendancerecordList = [attendanceRecord(name: "Rafae", ERP: "22828", Presence: "P"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "A"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "P"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "P"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "A"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "P"),attendanceRecord(name: "Rafae", ERP: "22828", Presence: "P")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var absentCount = 0
        var presentCount = 0
        for record in attendancerecordList {
            if record.Presence == "A"{
                absentCount+=1
            }
            else{
                presentCount+=1
            }
        }
        DateLabel.text = date + " "+time
        TotalCountLabel.text = "\(attendancerecordList.count)"
        TotalCountLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
        AbsentCountLabel.text = "\(absentCount)"
        AbsentCountLabel.textColor = UIColor.red
        PresentCountLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
        PresentCountLabel.text = "\(presentCount)"

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CourseAttRecTableCell", bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: CourseAttRecTableCell.cellIdentifier)
        view.addSubview(TableView)
        TableView.delegate = self
        TableView.dataSource = self
        
        CountView.layer.cornerRadius = 10
        CountView.layer.masksToBounds = true
        CountView.layer.borderColor = UIColor.black.cgColor
        CountView.layer.borderWidth = 1.0
        CountView.layer.shadowColor = UIColor.black.cgColor
        CountView.layer.shadowOpacity = 0.8
        CountView.layer.shadowOffset = CGSize(width: 2, height: 5)
        CountView.layer.shadowRadius = 5.0
        CountView.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TableView.frame = CGRect(x: ((view.bounds.width - 352) / 2), y: 300, width: 352, height: view.bounds.height-300)
    }
}

extension CourseAttRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.attendancerecordList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseAttRecTableCell.cellIdentifier, for: indexPath) as! CourseAttRecTableCell
        
        cell.NameLabel.text = attendancerecordList[indexPath.section].name
        cell.ERPLabel.text = attendancerecordList[indexPath.section].ERP
        cell.PresenceLabel.text = "\(attendancerecordList[indexPath.section].Presence)"
        if attendancerecordList[indexPath.section].Presence == "A" {
            cell.PresenceLabel.textColor = UIColor.red
        }
        else {
            cell.PresenceLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
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
    }
}
