import SwiftUI

struct TraineeHomeView: View {
    @State private var viewModel = SessionViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                Group {
                    if let session = viewModel.activeSession {
                        ActiveSessionView(session: session)
                    } else {
                        ContentUnavailableView("No Active Session", systemImage: "figure.run", description: Text("Your trainer will assign you a program."))
                    }
                }
                .navigationTitle("Workout")
                .task { await viewModel.loadActiveSession() }
                .errorAlert(error: $viewModel.error)
            }
            .tabItem { Label("Workout", systemImage: "figure.run") }

            SessionHistoryView()
                .tabItem { Label("History", systemImage: "clock") }
        }
    }
}
