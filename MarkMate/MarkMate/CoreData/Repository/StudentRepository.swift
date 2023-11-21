import Foundation
import CoreData

struct StudentRepository
{

    func create(record: Student)
    {

        let cdStudent = Students(context: PersistentStorage.shared.context)
        cdStudent.name = record.name
        cdStudent.erp = record.erp

        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [Student]?
    {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Students.self)

        var students : [Student] = []

        result?.forEach({ (cdStudent) in
            students.append(Student(name: cdStudent.name!, erp: cdStudent.erp))
        })

        return students
    }

}

