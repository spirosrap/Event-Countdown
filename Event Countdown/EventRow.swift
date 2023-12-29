import SwiftUI

struct EventRow: View {
    var event: Event
    private let dateFormatter: RelativeDateTimeFormatter
    
    init(event: Event) {
        self.event = event
        self.dateFormatter = RelativeDateTimeFormatter()
        self.dateFormatter.unitsStyle = .full // This can be .short, .abbreviated, or .spellOut
        self.dateFormatter.dateTimeStyle = .named // This can be .numeric, .named, .abbreviated, depending on your needs
    }

    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                if let imageData = event.imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    // Placeholder for when image is not available
                    Rectangle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }

                Text(event.title)
                    .foregroundColor(event.textColor)
                
                Text(dateFormatter.localizedString(for: event.date, relativeTo: Date()))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        // Assuming your Event struct has an initializer that accepts these parameters
        // And assuming that the textColor is of type Color
        EventRow(event: Event(id: UUID(), title: "Sample Event", date: Date(), textColor: Color.blue))
            .previewLayout(.sizeThatFits)
    }
}
#endif
