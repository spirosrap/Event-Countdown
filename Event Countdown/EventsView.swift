//
//  EventsView.swift
//  Event Countdown
//
//  Created by Spiros Raptis on 12/29/23.
//

import Foundation
import SwiftUI


struct EventsView: View {
    @State private var events: [Event] = EventDataManager.shared.loadEvents()
    @State private var showingEventForm = false
    @State private var eventToEdit: Event?
    @State private var draftEvent: Event?
    @State private var navigationPath = NavigationPath()
    
    enum NavigationDestination: Hashable {
        case eventForm(Event?)

        static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
            switch (lhs, rhs) {
            case (.eventForm(let lhsEvent), .eventForm(let rhsEvent)):
                return lhsEvent == rhsEvent
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .eventForm(let event):
                hasher.combine(event)
            }
        }
    }


    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(events, id: \.id) { event in
                    EventRow(event: event)
                        .onTapGesture {
                            self.eventToEdit = event
                            self.showingEventForm = true
                            navigationPath.append(NavigationDestination.eventForm(event))  // Use append to navigate
                        }
                
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                    delete(at: IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                    }
            }
            .onAppear {
                self.events = self.events.sorted { $0.date > $1.date }

            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.eventToEdit = nil
                        self.showingEventForm = true
                        navigationPath.append(NavigationDestination.eventForm(nil)) // For editing an existing event
                    }) {
                        Label("Add Event", systemImage: "plus")
                    }
                }
            }
//            .onChange(of: eventToEdit) { newValue in
//                print("eventToEdit changed to: \(String(describing: newValue))")
//                events = events.sorted { $0.date > $1.date }
//            }
            
            .navigationDestination(for: NavigationDestination.self) { destination in
                EventForm(eventToEdit: self.$eventToEdit, onSave: { updatedEvent in

                    if let index = self.events.firstIndex(where: { $0.id == updatedEvent.id }) {
                        var updatedEvents = self.events
                        updatedEvents[index] = updatedEvent
                        self.eventToEdit = nil
                        self.eventToEdit = updatedEvent
                        self.events = []
                        self.events = updatedEvents
                        self.addOrUpdateEvent(updatedEvent)
                    } else {
                        self.events.append(updatedEvent)
                        self.addOrUpdateEvent(updatedEvent)
                    }
                    print(events.count)

                })
            }
            
        }
    }

    private func delete(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
        print(events.count)
        EventDataManager.shared.saveEvents(events)
    }
    
    private func loadEvents() {
        self.events = EventDataManager.shared.loadEvents()
        self.events = self.events.sorted { $0.date > $1.date }
    }

    func addOrUpdateEvent(_ event: Event) {
        if let index = self.events.firstIndex(where: { $0.id == event.id }) {
            self.events = events.sorted { $0.date > $1.date }
            EventDataManager.shared.saveEvents(self.events)
        } else {
            self.events.append(event)
            self.events = events.sorted { $0.date > $1.date }
            EventDataManager.shared.saveEvents(self.events)
        }
    }

}
