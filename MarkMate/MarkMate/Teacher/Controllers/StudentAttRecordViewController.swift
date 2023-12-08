//
//  StudentAttRecordViewController.swift
//  MarkMate
//
//  Created by Macbook on 07/12/2023.
//

import UIKit

struct StudentAttRecord {
    let date: String
    let time: String
    let Presense: Character
}

class StudentAttRecordViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var AbsentCountLabel: UILabel!
    @IBOutlet weak var PresentCountLabel: UILabel!
    @IBOutlet weak var CountView: UIView!
    @IBOutlet weak var studentERPLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    var NameLabel: String = ""
    var ERPLabel: String = ""
    private let TableView = UITableView()
    let attendanceRecord = [StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "P"),StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "P"),StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "A"),StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "P"),StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "P"),StudentAttRecord(date: "23 October, 2023", time: "2:44 PM", Presense: "A"),]
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameLabel.text = NameLabel
        studentERPLabel.text = ERPLabel
        var absentCount = 0
        var presentCount = 0
        for record in attendanceRecord {
            if record.Presense == "A"{
                absentCount+=1
            }
            else{
                presentCount+=1
            }
        }
        AbsentCountLabel.text = "\(absentCount)"
        AbsentCountLabel.textColor = UIColor.red
        PresentCountLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
        PresentCountLabel.text = "\(presentCount)"
        

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "StudentAttCell", bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: StudentAttCell.cellIdentifier)
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
        TableView.frame = CGRect(x: ((view.bounds.width - 352) / 2), y: 250, width: 352, height: view.bounds.height-270)
    }
}

extension StudentAttRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2.5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.attendanceRecord.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentAttCell.cellIdentifier, for: indexPath) as! StudentAttCell
        
        cell.attendanceTimeLabel.text = attendanceRecord[indexPath.section].date + " " + attendanceRecord[indexPath.section].time
        cell.presenceLabel.text = "\(attendanceRecord[indexPath.section].Presense)"
        if attendanceRecord[indexPath.section].Presense == "A" {
            cell.presenceLabel.textColor = UIColor.red
        }
        else {
            cell.presenceLabel.textColor = UIColor(red: 34/255.0, green: 118/255.0, blue: 141/255.0, alpha: 1.0)
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

