import SwiftUI

struct ContentView: View {
    @AppStorage("reminders_json") private var remindersJSON: String = ""

    @State private var reminders: [Reminder] = []
    @State private var newTitle: String = ""
    @State private var newDueDate: Date = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                VStack(spacing: 10) {
                    TextField("Nhap noi dung nhac nho", text: $newTitle)
                        .textFieldStyle(.roundedBorder)

                    DatePicker("Thoi gian", selection: $newDueDate)
                        .datePickerStyle(.compact)

                    Button(action: addReminder) {
                        Text("Them nhac nho")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                if reminders.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 42))
                            .foregroundStyle(.secondary)
                        Text("Chua co nhac nho")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach($reminders) { $reminder in
                            HStack(spacing: 12) {
                                Toggle("", isOn: $reminder.isDone)
                                    .labelsHidden()

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reminder.title)
                                        .strikethrough(reminder.isDone, color: .gray)
                                        .foregroundStyle(reminder.isDone ? .secondary : .primary)

                                    Text(Self.dateFormatter.string(from: reminder.dueDate))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteReminder)
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Simple Reminder")
            .navigationBarItems(
                trailing: EditButton()
                    .disabled(reminders.isEmpty)
                    .opacity(reminders.isEmpty ? 0 : 1)
            )
        }
        .onAppear(perform: loadReminders)
        .onChange(of: reminders) { _ in
            saveReminders()
        }
    }

    private func addReminder() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }

        reminders.append(Reminder(title: title, dueDate: newDueDate))
        reminders.sort { $0.dueDate < $1.dueDate }

        newTitle = ""
        newDueDate = Date()
    }

    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }

    private func loadReminders() {
        guard !remindersJSON.isEmpty, let data = remindersJSON.data(using: .utf8) else {
            reminders = []
            return
        }

        do {
            reminders = try JSONDecoder().decode([Reminder].self, from: data)
            reminders.sort { $0.dueDate < $1.dueDate }
        } catch {
            reminders = []
        }
    }

    private func saveReminders() {
        do {
            let data = try JSONEncoder().encode(reminders)
            remindersJSON = String(data: data, encoding: .utf8) ?? ""
        } catch {
            remindersJSON = ""
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    ContentView()
}
