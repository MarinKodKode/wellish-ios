
import Foundation
import SwiftUI

extension Binding where Value == String? {
    func replacingNilWith(_ defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
