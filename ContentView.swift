import SwiftUI

struct ContentView: View {
    @StateObject var storage = BirthdayStorage()
    @State private var showAddBirthday = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Add Birthday") {
                    showAddBirthday = true
                }
                .padding()
                .sheet(isPresented: $showAddBirthday) {
                    AddBirthdayView(storage: storage)
                }

                List {
                    ForEach(storage.birthdays) { birthday in
                        VStack(alignment: .leading) {
                            Text(birthday.name).font(.headline)
                            Text(birthday.formattedDate).font(.subheadline)
                        }
                    }
                    .onDelete(perform: storage.deleteBirthday)
                }
                .navigationTitle("Birthdays")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
}

struct AddBirthdayView: View {
    @ObservedObject var storage: BirthdayStorage
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var date = Date()

    var body: some View {
        VStack {
            TextField("Enter Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Select Date", selection: $date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("Save") {
                if !name.isEmpty {
                    storage.addBirthday(name: name, date: date)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .navigationTitle("Add Birthday")
    }
}