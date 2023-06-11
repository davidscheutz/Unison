import SwiftUI

extension View {
    @ViewBuilder
    func apply(_ condition: Bool, apply: (Self) -> some View) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
}
