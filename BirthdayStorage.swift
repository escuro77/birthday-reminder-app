import Foundation

struct Birthday: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

class BirthdayStorage: ObservableObject {
    @Published var birthdays: [Birthday] {
        didSet {
            if let encoded = try? JSONEncoder().encode(birthdays) {
                UserDefaults.standard.set(encoded, forKey: "birthdays")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(forKey: "birthdays"),
           let decoded = try? JSONDecoder().decode([Birthday].self, from: savedData) {
            birthdays = decoded
        } else {
            birthdays = []
        }
    }

    func addBirthday(name: String, date: Date) {
        birthdays.append(Birthday(name: name, date: date))
    }

    func deleteBirthday(at offsets: IndexSet) {
        birthdays.remove(atOffsets: offsets)
    }
}