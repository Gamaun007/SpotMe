import SwiftUI

struct TrainerHomeView: View {
    var body: some View {
        TabView {
            ProgramListView()
                .tabItem { Label("Programs", systemImage: "list.bullet.clipboard") }

            TraineeListView()
                .tabItem { Label("Trainees", systemImage: "person.2") }
        }
    }
}
