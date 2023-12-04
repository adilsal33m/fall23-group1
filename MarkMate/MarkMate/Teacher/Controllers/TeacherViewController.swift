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

protocol FinishAddingCourseDelegate: AnyObject {
    func didFinishAddingCourse(course: Course, numberOfStudents: Int)
}

// MARK: - Adding Students View Controller

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
    
    // MARK: - End of UIDocumentPickerDelegate Code
    
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
    
    weak var delegate: FinishAddingCourseDelegate?
    var courseFromAddCourses: Course?
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        let numberOfStudents = studentsData.count

        if let course = courseFromAddCourses {
            delegate?.didFinishAddingCourse(course: course, numberOfStudents: numberOfStudents)
        }
        
        performSegue(withIdentifier: "segueToCourses", sender: self)
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

// MARK: - Add Student View Controller

class AddStudentViewController: UIViewController, AddStudentsViewControllerDelegate {
    
    func didEnterData(name: String, erp: String) {
    }
    
    @IBOutlet weak var StudentName: UITextField!
    @IBOutlet weak var StudentERP: UITextField!

    weak var delegate: AddStudentsViewControllerDelegate?
    
    var studentsData: [Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        StudentName.backgroundColor = .white
        StudentERP.backgroundColor = .white
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

// MARK: - Courses View Controller

class ClassTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 8
    }
}

class CoursesViewController:UIViewController, AddCoursesDelegate{
    func didAddCourse(course: Course) {
        courses.append(course)
        coursesTableView.reloadData()
    }
    
    
    @IBOutlet weak var coursesTableView: UITableView!
    
    var courses: [Course] = []
    
    @IBOutlet weak var teacherInitialsButton: UIButton!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Making both the buttons round
        teacherInitialsButton.layer.cornerRadius = teacherInitialsButton.bounds.width / 2
        teacherInitialsButton.layer.cornerRadius = teacherInitialsButton.bounds.height / 2
        teacherInitialsButton.clipsToBounds = true
        
        plusButton.layer.cornerRadius = plusButton.bounds.width / 2
        plusButton.layer.cornerRadius = plusButton.bounds.height / 2
        plusButton.clipsToBounds = true
        
        addLineToLabel(label: lineLabel)
        
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
    }
    
    func addLineToLabel(label: UILabel) {
        // Creating a CALayer for the line
        let lineLayer = CALayer()
        lineLayer.frame = CGRect(x: 0, y: label.bounds.height - 1, width: label.bounds.width, height: 1)
        lineLayer.backgroundColor = UIColor.black.cgColor
        
        // Adding the layer to the label's layer
        label.layer.addSublayer(lineLayer)
    }
    
    @IBAction func AddCoursesButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AddCourseSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCourseSegue" {
            if let addCourseVC = segue.destination as? AddCourseViewController {
                addCourseVC.delegate = self
            }
        }
        if let addingStudentsVC = segue.destination as? AddingStudentsViewController {
            addingStudentsVC.delegate = self
        }
    }
    
}

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! ClassTableViewCell
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.name
        cell.detailTextLabel?.text = "Number: \(course.number), Semester: \(course.semester))"
        return cell
    }
}

extension CoursesViewController: FinishAddingCourseDelegate{
    func didFinishAddingCourse(course: Course, numberOfStudents: Int) {
        courses.append(course)
        coursesTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Add Course View Controller

protocol AddCoursesDelegate: AnyObject {
    func didAddCourse(course: Course)
}
class AddCourseViewController: UIViewController{
    
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var semesterTextField: UITextField!
    @IBOutlet weak var attendanceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    weak var delegate: AddCoursesDelegate?
    var selectedCourse: Course?
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let name = courseNameTextField.text,
              let number = courseNumberTextField.text,
              let semester = semesterTextField.text,
              let attendance = attendanceTextField.text,
              let attendance = Int(attendance) else {
            return
        }
        
        let course = Course(name: name, number: number, semester: semester, attendance: attendance)
        selectedCourse = course
        delegate?.didAddCourse(course: course)
        performSegue(withIdentifier: "AddingStudentsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addingStudentsVC = segue.destination as? AddingStudentsViewController {
            addingStudentsVC.courseFromAddCourses = selectedCourse
        }
    }
}

extension AddCourseViewController: FinishAddingCourseDelegate {
    func didFinishAddingCourse(course: Course, numberOfStudents: Int) {
        dismiss(animated: true, completion: nil)
    }
}
