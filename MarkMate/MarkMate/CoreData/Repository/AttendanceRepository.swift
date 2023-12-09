import Foundation
struct AttendanceRepository
{
    func add(session:Session) -> Attendance
    {
        let cdAttendance = Attendance(context: PersistentStorage.shared.context)
        cdAttendance.id = session.id
        cdAttendance.date = session.date
        
        return cdAttendance
    }

}
