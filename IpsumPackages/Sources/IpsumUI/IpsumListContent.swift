import IpsumModels
import SwiftUI

public struct IpsumListContent: View {
    private let entries: [IpsumEntry]
    private let isLoading: Bool
    private let errorMessage: String?
    private let retry: () async -> Void

    public init(entries: [IpsumEntry], isLoading: Bool, errorMessage: String?, retry: @escaping () async -> Void) {
        self.entries = entries
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.retry = retry
    }

    public var body: some View {
        if isLoading {
            ProgressView("Loading...")
        } else if let errorMessage {
            ContentUnavailableView {
                Label("Unable to load", systemImage: "exclamationmark.triangle")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Retry") {
                    Task { await retry() }
                }
            }
        } else {
            List(entries) { entry in
                Text(entry.text)
                    .padding(.vertical, 8)
            }
            .overlay {
                if entries.isEmpty {
                    ContentUnavailableView("No entries", systemImage: "text.alignleft")
                }
            }
        }
    }
}
