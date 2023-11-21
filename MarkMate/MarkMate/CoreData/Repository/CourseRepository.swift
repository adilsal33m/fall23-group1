import Foundation
import CoreData

struct CourseRepository
{

    //returns true if course successfully created, false otherwise
    //checks if a course with a similar ID already exist
    func create(record: Course) -> Bool
    {
        guard alreadyExists(byIdentifier: record.class_nbr) == nil else {return false}
        
        let cdCourse = Courses(context: PersistentStorage.shared.context)
        cdCourse.course_name = record.course_name
        cdCourse.class_nbr = record.class_nbr
        cdCourse.semester = record.semester
        
        if(record.roster != nil && record.roster?.count != 0)
        {
            var studentList = Set<Students>()
            record.roster?.forEach({ (student) in
                let cdStudent = Students(context: PersistentStorage.shared.context)
                cdStudent.name = student.name
                cdStudent.erp = student.erp
                studentList.insert(cdStudent)
            })
            cdCourse.addToCoursesToStudents(studentList)
        }

        PersistentStorage.shared.saveContext()
        
        return true
    }

    //return all Courses that exist
    func getAll() -> [Course]?
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path)

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Courses.self)

        var courses : [Course] = []

        result?.forEach({ (cdCourse) in
            courses.append(convertToCourse(cdCourse))
        })

        return courses
    }
    
    //checks if a course associated with the given ID exists
    func alreadyExists(byIdentifier class_nbr: Int32) -> Courses?
    {

         let fetchRequest = NSFetchRequest<Courses>(entityName: "Courses")
         let predicate = NSPredicate(format: "class_nbr==%@", NSNumber(value: class_nbr))

         fetchRequest.predicate = predicate
         do
         {
             let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
             guard result != nil else {return nil}
             return result
         }
        catch let error
        {
             debugPrint(error)
         }

         return nil
     }

    //updates course information associated with id
    //class id cannot be manipulated
    func update(course: Course) -> Bool
    {
        let result = alreadyExists(byIdentifier: course.class_nbr)
        guard result != nil else {return false}
        
        result?.course_name = course.course_name
        result?.semester = course.semester
        PersistentStorage.shared.saveContext()
     
        return true
    }

    //deletes course associated with id
    func delete(class_nbr: Int32) -> Bool
    {
        let course = alreadyExists(byIdentifier: class_nbr)
        guard course != nil else {return false}

        PersistentStorage.shared.context.delete(course!)
        PersistentStorage.shared.saveContext()
        
        return true
    }
    
    //remove student from the course
    func removeStudent(class_nbr : Int32, student:Student) -> Bool
    {
        let result = alreadyExists(byIdentifier: class_nbr)
        
        guard result != nil else {return false}
        
        let cdStudent = Students(context: PersistentStorage.shared.context)
        cdStudent.name = student.name
        cdStudent.erp = student.erp
        
        result?.coursesToStudents?.remove(cdStudent)
        result?.removeFromCoursesToStudents(cdStudent)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    //saves the Core Data instance of Courses into Course class
    func convertToCourse(_ course: Courses) -> Course
    {
        return Course(
            class_nbr: course.class_nbr,
            semester: course.semester!,
            course_name: course.course_name!,
            roster: convertToStudent(course)
        )
    }
    //saves the Core Data instance of Students associated with a course to an array of class Student
    func convertToStudent(_ course: Courses) -> [Student]?
    {
        guard course.coursesToStudents != nil else{return nil}
        var students : [Student] = []

        course.coursesToStudents?.forEach({ (cdStudent) in
            students.append(Student(name: cdStudent.name!, erp: cdStudent.erp))
        })

        return students
    }
}

