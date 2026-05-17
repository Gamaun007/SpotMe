import SwiftUI

struct ProgramEditorView: View {
    var program: Program?

    var body: some View {
        Text("Program Editor — TODO")
            .navigationTitle(program == nil ? "New Program" : "Edit Program")
    }
}
