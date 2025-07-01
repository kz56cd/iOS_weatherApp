
import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("showBackgroundImage") var showBackgroundImage: Bool = true
}
