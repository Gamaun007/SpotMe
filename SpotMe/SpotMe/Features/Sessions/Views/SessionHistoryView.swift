import SwiftUI

struct SessionHistoryView: View {
    @State private var viewModel = SessionViewModel()

    var body: some View {
        Group {
            if viewModel.sessionHistory.isEmpty {
                ContentUnavailableView("No Sessions Yet", systemImage: "clock", description: Text("Completed sessions will appear here."))
            } else {
                List(viewModel.sessionHistory) { session in
                    VStack(alignment: .leading) {
                        Text(session.programName).font(Typography.headline)
                        Text(session.startedAt, style: .date).font(Typography.caption)
                    }
                }
            }
        }
        .navigationTitle("History")
        .task { await viewModel.loadHistory() }
        .errorAlert(error: $viewModel.error)
    }
}
