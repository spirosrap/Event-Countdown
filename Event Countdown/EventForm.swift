//
//  EventForm.swift
//  Event Countdown
//
//  Created by Spiros Raptis on 12/29/23.
//

import Foundation
import SwiftUI

struct EventForm: View {
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var textColor: Color = .black
    @State private var showingImagePicker = false
    @State private var imageData: Data?
    @State private var selectedColorString: String!

    @Environment(\.presentationMode) var presentationMode

    @Binding var eventToEdit: Event?
    var onSave: (Event) -> Void
    
    var selectedColor: Color {
        get { Color.fromRGBString(selectedColorString) }
        set { selectedColorString = newValue.toRGBString() }
    }

    var body: some View {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    ColorPicker("Text Color", selection: $textColor)
                    
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200) // Set a fixed height for the image
                    }
                    
                    Button("Choose Image") {
                        showingImagePicker = true
                    }
                }
            }
            .onAppear{
                if let event = eventToEdit {
                    self.title = event.title
                    self.date = event.date
                    self.imageData = event.imageData
                    self.textColor = event.textColor                    
                }
            }
            .navigationTitle(eventToEdit != nil ? "Edit Event" : "Add Event")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let newEvent = Event(id: eventToEdit?.id ?? UUID(), title: title, date: date, textColor: textColor, imageData: imageData)
                        onSave(newEvent) // Make sure to call the onSave closure with the new event
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "checkmark")
                            .imageScale(.large) // Adjust the size of the image if needed
                            .foregroundColor(.blue) // You can choose any color you like
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(imageData: $imageData)
            }
    }
    
//    func save() {
//        let newEvent = Event(id: UUID(), title: title, date: date, textColor: textColor, imageData: imageData)
//        onSave(newEvent)
//        // Handle dismissing the view here if necessary
//    }

}

//struct EventForm_Previews: PreviewProvider {
//    static var previews: some View {
//        EventForm(onSave: { _ in })
//    }
//}

extension Color {
    // Convert Color to a String (RGB)
    func toRGBString() -> String {
        // Convert Color to UIColor
        let uiColor = UIColor(self)
        
        // Get RGB components from UIColor
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Convert components to 0-255 scale and create a string
        return "\(Int(red * 255)),\(Int(green * 255)),\(Int(blue * 255))"
    }

    static func fromRGBString(_ rgbString: String) -> Color {
        // Split the string into components
        let components = rgbString.split(separator: ",").compactMap { Int($0) }
        guard components.count == 3 else { return Color.black } // Fallback color

        // Convert components to UIColor
        let uiColor = UIColor(
            red: CGFloat(components[0]) / 255.0,
            green: CGFloat(components[1]) / 255.0,
            blue: CGFloat(components[2]) / 255.0,
            alpha: 1.0
        )

        // Convert UIColor to Color
        return Color(uiColor)
    }
}
