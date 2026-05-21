import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var dueDate: Date
    var isDone: Bool

    init(id: UUID = UUID(), title: String, dueDate: Date, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isDone = isDone
    }
}
