//
//  Session.swift
//  MarkMate
//
//  Created by Macbook on 06/12/2023.
//

import Foundation
class Session:CustomStringConvertible
{
    var id: UUID
    var date: Date
    
    init(id: UUID, date:Date)
    {
        self.id = id
        self.date = date
    }
    
    var description: String {
        return "session id: \(self.id), session date: \(self.date)"
      }
}
