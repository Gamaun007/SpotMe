import SwiftUI

struct ProgramDetailView: View {
    let program: Program

    var body: some View {
        List(program.exercises) { exercise in
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(exercise.name).font(Typography.headline)
                Text("\(exercise.targetSets) sets × \(exercise.targetReps) reps")
                    .font(Typography.caption)
                    .foregroundStyle(Color.spotSecondaryText)
            }
        }
        .navigationTitle(program.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    ProgramEditorView(program: program)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
