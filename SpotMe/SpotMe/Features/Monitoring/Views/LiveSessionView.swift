import SwiftUI

struct LiveSessionView: View {
    let sessionId: String
    @State private var viewModel = MonitoringViewModel()

    var body: some View {
        Group {
            if let session = viewModel.liveSession {
                Text("Monitoring: \(session.programName) — TODO")
            } else {
                ProgressView("Connecting...")
            }
        }
        .navigationTitle("Live Session")
        .onAppear { viewModel.startMonitoring(sessionId: sessionId) }
        .onDisappear { viewModel.stopMonitoring() }
        .errorAlert(error: $viewModel.error)
    }
}
