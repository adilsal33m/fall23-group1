//
//  TeacherViewController.swift
//  MarkMate
//
//  Created by Macbook on 17/11/2023.
//

import Foundation
import UIKit

import UIKit

class AddingStudentsViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var ImportExcelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImportExcelButton.addTarget(self, action: #selector(importExcelButtonTapped), for: .touchUpInside)
    }
    
    @objc func importExcelButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
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
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
    
    
    @IBAction func AddManuallyButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToAddStudent", sender: self)
    }
    
    var studentsData: [Student] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddStudent" {
            if let addStudentVC = segue.destination as? AddStudentViewController {
                addStudentVC.studentsData = studentsData
            }
        }
    }
    
}
    class AddStudentViewController: UIViewController {

        @IBOutlet weak var StudentName: UITextField!
        @IBOutlet weak var StudentERP: UITextField!

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
