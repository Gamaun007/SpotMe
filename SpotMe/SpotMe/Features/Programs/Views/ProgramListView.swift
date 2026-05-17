import SwiftUI

struct ProgramListView: View {
    @Environment(DependencyContainer.self) private var container
    @State private var viewModel: ProgramViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.programs.isEmpty {
                        ContentUnavailableView("No Programs", systemImage: "list.bullet.clipboard", description: Text("Create your first workout program."))
                    } else {
                        List(viewModel.programs) { program in
                            NavigationLink(program.name) {
                                ProgramDetailView(program: program)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Programs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        ProgramEditorView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                if viewModel == nil {
                    viewModel = ProgramViewModel(
                        programRepository: container.programRepository,
                        authService: container.authService
                    )
                }
                await viewModel?.loadPrograms()
            }
            .errorAlert(error: Bindable(viewModel ?? ProgramViewModel(programRepository: container.programRepository, authService: container.authService)).error)
        }
    }
}
