import Foundation
import CoreData

struct Course
{
    var class_nbr: Int32
    var semester,course_name: String
    
    func create(course: Courses)
    {

        let cdCourse = Courses(context: PersistentStorage.shared.context)
        cdCourse.course_name = course.course_name
        cdCourse.class_nbr = course.class_nbr
        cdCourse.semester = course.semester

        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [Course]?
    {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Courses.self)

        var courses : [Course] = []

        result?.forEach({ (cdCourse) in
            courses.append(cdCourse.convertToCourse())
        })

        return courses
    }
    
    func get(byIdentifier class_nbr: Int32) -> Courses?
    {

         let fetchRequest = NSFetchRequest<Courses>(entityName: "Courses")
         let predicate = NSPredicate(format: "class_nbr==%@", class_nbr as CVarArg)

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

    func update(course: Course) -> Bool
    {
        let result = get(byIdentifier: course.class_nbr)
        guard result != nil else {return false}
        
        result?.course_name = course.course_name
        result?.class_nbr = course.class_nbr
        result?.semester = course.semester
        PersistentStorage.shared.saveContext()
     
        return true
    }

    func delete(class_nbr: Int32) -> Bool
    {
        let course = get(byIdentifier: class_nbr)
        guard course != nil else {return false}

        PersistentStorage.shared.context.delete(course!)
        PersistentStorage.shared.saveContext()
        return true
    }
}

