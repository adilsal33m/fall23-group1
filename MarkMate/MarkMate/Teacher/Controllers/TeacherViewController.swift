//
//  TeacherViewController.swift
//  MarkMate
//
//  Created by Macbook on 17/11/2023.
//

import Foundation
import UIKit

protocol AddStudentsViewControllerDelegate: AnyObject {
    func didEnterData(name: String, erp: String)
}

class AddingStudentsViewController: UIViewController, UIDocumentPickerDelegate, AddStudentsViewControllerDelegate {
    
    var studentsData: [Student] = []
    
    @IBOutlet weak var ImportExcelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImportExcelButton.addTarget(self, action: #selector(importExcelButtonTapped), for: .touchUpInside)
    }
    
    @objc func importExcelButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.comma-separated-values-text"], in: .import)
        documentPicker.delegate = self
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        print("Selected file URL: \(selectedFileURL.path)")
        
        do {
                    let csvString = try String(contentsOf: selectedFileURL, encoding: .utf8)
                    let csvRows = csvString.components(separatedBy: .newlines)

                    guard let headers = csvRows.first?.components(separatedBy: ","), headers.count >= 2 else {
                        print("Invalid CSV format")
                        return
                    }

                    var nameColumnIndex: Int?
                    var erpColumnIndex: Int?

                    for (index, header) in headers.enumerated() {
                        if header.localizedCaseInsensitiveContains("Name") {
                            nameColumnIndex = index
                        } else if header.localizedCaseInsensitiveContains("ERP") {
                            erpColumnIndex = index
                        }
                    }

                    guard let nameIndex = nameColumnIndex, let erpIndex = erpColumnIndex else {
                        print("Could not find 'Name' or 'ERP' columns")
                        return
                    }

                    for csvRow in csvRows.dropFirst() {
                        let rowComponents = csvRow.components(separatedBy: ",")

                        if rowComponents.count > max(nameIndex, erpIndex) {
                            let student = Student(name: rowComponents[nameIndex], erp: rowComponents[erpIndex])
                            studentsData.append(student)
                        }
                    }

                    tableView.reloadData()
            } catch {
                print("Error reading CSV file: \(error)")
            }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
    
    
    @IBAction func AddManuallyButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToAddStudent", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddStudent" {
            if let addStudentVC = segue.destination as? AddStudentViewController {
                addStudentVC.studentsData = studentsData
                addStudentVC.delegate = self
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func didEnterData(name: String, erp: String) {
        let newStudent = Student(name: name, erp: erp)
        studentsData.append(newStudent)
        tableView.reloadData()
    }
}

class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var erpLabel: UILabel!

    func configure(with student: Student) {
        nameLabel.text = "\(student.name)"
        erpLabel.text = "\(student.erp)"
    }
}

    // Adopting UITableViewDelegate and UITableViewDataSource
extension AddingStudentsViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)  as! StudentTableViewCell
        let student = studentsData[indexPath.row]
        cell.configure(with: student)
        return cell
    }
}

class AddStudentViewController: UIViewController, AddStudentsViewControllerDelegate {
    
    func didEnterData(name: String, erp: String) {
    }
    

    @IBOutlet weak var StudentName: UITextField!
    @IBOutlet weak var StudentERP: UITextField!

    weak var delegate: AddStudentsViewControllerDelegate?
    
    var studentsData: [Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func SaveButtonTapped(_ sender: UIButton) {
        addStudent()
        printStudentData()
        dismiss(animated: true, completion: nil)
    }
        
    @IBAction func AddAnotherButtonTapped(_ sender: UIButton){
        addStudent()
        clearTextFields()
    }

    private func addStudent() {
        guard let name = StudentName.text, let erp = StudentERP.text else {
            return
        }
        let student = Student(name: name, erp: erp)
        delegate?.didEnterData(name: name, erp: erp)
        studentsData.append(student)
    }

    private func clearTextFields() {
        StudentName.text = ""
        StudentERP.text = ""
    }
        
    private func printStudentData() {
        print("Student Data:")
        for student in studentsData {
            print("Name: \(student.name), ERP: \(student.erp)")
        }
    }
}
