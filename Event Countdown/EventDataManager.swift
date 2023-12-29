//
//  EventDataManager.swift
//  Event Countdown
//
//  Created by Spiros Raptis on 12/29/23.
//

import Foundation
import SwiftUI
class EventDataManager {
    static let shared = EventDataManager()
    
    private let eventsKey = "eventsData"

    func saveEvents(_ events: [Event]) {
        do {
            // Convert your events to Data
            let encoder = JSONEncoder()
            let data = try encoder.encode(events)
            print(events.count)
            UserDefaults.standard.set(data, forKey: eventsKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving events: \(error)")
        }
    }

    func loadEvents() -> [Event] {
        guard let data = UserDefaults.standard.data(forKey: eventsKey) else { return [] }
        do {
            // Decode the data back into an array of Events
            let decoder = JSONDecoder()
            return try decoder.decode([Event].self, from: data)
        } catch {
            print("Error loading events: \(error)")
            return []
        }
    }
    
//    func saveImageForEvent(image: UIImage, event: Event) {
//        let imageName = "\(UUID().uuidString).jpg"
//        let imagePath = saveImageToDocumentsDirectory(image: image, filename: imageName)
//
//        // Update your event object here with imagePath
//        event.imagePath = imagePath
//        // Save event object using your data manager
//        EventDataManager.shared.updateEvent(event)
//    }

}
