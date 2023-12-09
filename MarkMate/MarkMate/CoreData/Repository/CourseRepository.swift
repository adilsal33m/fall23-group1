// let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
// print(path)
import Foundation
import CoreData

struct CourseRepository
{
    let studentRepo = StudentRepository()
    let attendanceRepo = AttendanceRepository()
    
    //returns true if course successfully created, false otherwise
    //checks if a course with a similar ID already exist
    func create(record: Course, list:[Student]) -> Bool
    {
        guard exists(byIdentifier: record.course_nbr) == nil else {return false}
        
        let cdCourse = Courses(context: PersistentStorage.shared.context)
        cdCourse.course_name = record.course_name
        cdCourse.class_nbr = record.course_nbr
        cdCourse.semester = record.semester
        
        if(list.count !=  0)
        {
            var studentList = Set<Students>()
            list.forEach(
            { (student) in
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
    func getAll() -> [Courses]?
    {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Courses.self)
        return result
    }
    
    //checks if a course associated with the given ID exists
    func exists(byIdentifier class_nbr: Int32) -> Courses?
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

    //updates course information associated with course nbr
    //course nbr cannot be manipulated
    func updateCourse(course: Course) -> Bool
    {
        let result = exists(byIdentifier: course.course_nbr)
        guard result != nil else {return false}
        
        result?.course_name = course.course_name
        result?.semester = course.semester
        result?.attendance_requirement = course.attendance_req
        PersistentStorage.shared.saveContext()
     
        return true
    }

    //deletes course associated with id
    func deleteCourse(course_nbr: Int32) -> Bool
    {
        let course = exists(byIdentifier: course_nbr)
        guard course != nil else {return false}

        PersistentStorage.shared.context.delete(course!)
        PersistentStorage.shared.saveContext()
        
        return true
    }
    
    //remove student from the course
    func removeStudent(course_nbr : Int32, erp:Int32) -> Bool
    {
        let result = exists(byIdentifier: course_nbr)
        guard result != nil else {return false}
        
        if let studentToRemove = result!.coursesToStudents?.first(where: {$0.erp == erp})
        {
            result!.removeFromCoursesToStudents(studentToRemove)
            PersistentStorage.shared.saveContext()
            return true
        }
        else{return false}

    }

    //add student to course
    func addStudent(course_nbr : Int32, student:Student) -> Bool
    {
        let result = exists(byIdentifier: course_nbr)
        
        guard result != nil else {return false}
        
        if (result!.coursesToStudents?.contains(where: {$0.erp == student.erp}) == nil)
        {
            let response = studentRepo.add(student: student)
            result?.addToCoursesToStudents(response)
            PersistentStorage.shared.saveContext()
            return true
        }
        else{return false}
    }
    
    //get students enrolled in a course
    func getStudents(course_nbr : Int32) -> Set<Students>?
    {
        let result = exists(byIdentifier: course_nbr)
        guard result != nil else {return nil}
        
        return result?.coursesToStudents
    }
    
    //get sessions' information held for this course
    func getSessions(course_nbr : Int32) -> Set<Attendance>?
    {
        let result = exists(byIdentifier: course_nbr)
        guard result != nil else {return nil}
        
        return result?.coursesToAttendance
    }
    
    //remove session from the course
    func removeSession(course_nbr : Int32, id:UUID) -> Bool
    {
        let result = exists(byIdentifier: course_nbr)
        guard result != nil else {return false}
        
        if let sessionToRemove = result!.coursesToAttendance?.first(where: {$0.id == id})
        {
            result!.removeFromCoursesToAttendance(sessionToRemove)
            PersistentStorage.shared.saveContext()
            return true
        }
        else{return false}

    }

    //add student to course
    func addSession(course_nbr : Int32, session:Session, absentees:[Int32]) -> Bool
    {
        let result = exists(byIdentifier: course_nbr)
        guard result != nil else {return false}
        
        let response = attendanceRepo.add(session: session)
        result!.addToCoursesToAttendance(response)
        absentees.forEach({ (erp) in
            if let student = result!.coursesToStudents?.first(where: {$0.erp == erp})
            {
                let studentResponse = attendanceRepo.add(session: session)
                student.addToStudentsToAttendance(studentResponse)
            }
        })
        PersistentStorage.shared.saveContext()
        return true
    }
    
}

