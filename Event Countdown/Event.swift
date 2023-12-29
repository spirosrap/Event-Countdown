//
//  Event.swift
//  Event Countdown
//
//  Created by Spiros Raptis on 12/29/23.
//

import Foundation
import SwiftUI

struct Event: Identifiable, Comparable, Codable {
    let id: UUID
    var title: String
    var date: Date
    private var textColorString: String // Storing color as a string
    var imageData: Data?
    
    var textColor: Color {
        get {
            // Convert the string to Color
            Color.fromRGBString(textColorString)
        }
        set {
            // Convert the Color to a string when setting
            textColorString = newValue.toRGBString()
        }
    }

    // Use coding keys to exclude non-Codable properties from automatic encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, title, date, textColorString, imageData
    }
    
    // Example of manually encoding a Color property
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(imageData, forKey: .imageData)
        try container.encode(textColorString, forKey: .textColorString)
        // Convert Color to a hex string or other Codable form and encode it
        // let hexColor = textColor.toHexString() // Implement this conversion
        // try container.encode(hexColor, forKey: .textColor)
    }
    
    init(id: UUID, title: String, date: Date, textColor: Color, imageData: Data? = nil) {
        self.id = id
        self.title = title
        self.date = date
        self.textColorString = textColor.toRGBString() // Convert Color to string
        self.imageData = imageData
    }

    // Example of manually decoding a Color property
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        
        // Decode the hex string or other Codable form to a Color
        // let hexColor = try container.decode(String.self, forKey: .textColor)
        // textColor = Color(hex: hexColor) // Implement this conversion
        textColorString = try container.decode(String.self, forKey: .textColorString)
    }

    

    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }
}


extension Event: Hashable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id // Assuming `id` is a unique identifier of `Event`
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Hash the unique identifier
    }
}

func saveImageToDocumentsDirectory(image: UIImage, filename: String) -> Bool {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let filePath = paths[0].appendingPathComponent(filename)

    guard let data = image.jpegData(compressionQuality: 1) else { return false }

    do {
        try data.write(to: filePath, options: .atomic)
        return true
    } catch {
        print("Error saving image: \(error)")
        return false
    }
}

func storeImagePath(path: String) {
    UserDefaults.standard.set(path, forKey: "imagePath")
}

func retrieveImagePath() -> String? {
    return UserDefaults.standard.string(forKey: "imagePath")
}

func loadImageFromPath(path: String) -> UIImage? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let filePath = paths[0].appendingPathComponent(path)
    return UIImage(contentsOfFile: filePath.path)
}
