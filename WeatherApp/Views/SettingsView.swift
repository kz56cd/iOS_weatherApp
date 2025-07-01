
import SwiftUI

struct SettingsView: View {
    @Binding var showingSettingsSheet: Bool
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $appSettings.showBackgroundImage) {
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
