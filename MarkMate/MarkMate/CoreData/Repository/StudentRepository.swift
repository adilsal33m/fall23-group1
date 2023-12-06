import Foundation
import CoreData

struct StudentRepository
{
    func add(student:Student) -> Students
    {
        let cdStudent = Students(context: PersistentStorage.shared.context)
        cdStudent.name = student.name
        cdStudent.erp = student.erp
        
        return cdStudent
    }
    

}

