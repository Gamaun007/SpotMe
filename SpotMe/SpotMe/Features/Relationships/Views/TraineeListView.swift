import SwiftUI

struct TraineeListView: View {
    @State private var viewModel = RelationshipViewModel()

    var body: some View {
        Group {
            if viewModel.trainees.isEmpty {
                ContentUnavailableView("No Trainees", systemImage: "person.2", description: Text("Share your invite code to link a trainee."))
            } else {
                List(viewModel.trainees) { relationship in
                    Text(relationship.traineeId)
                }
            }
        }
        .navigationTitle("Trainees")
        .task { await viewModel.loadTrainees() }
        .errorAlert(error: $viewModel.error)
    }
}
