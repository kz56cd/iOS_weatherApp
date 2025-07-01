
import SwiftUI

struct SettingsView: View {
    @Binding var showingSettingsSheet: Bool
    @State private var showBackgroundColor = false // Dummy state for toggle

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showBackgroundColor) {
                    Text("背景色を表示する")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettingsSheet = false // Close the sheet
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showingSettingsSheet: .constant(true))
    }
}
