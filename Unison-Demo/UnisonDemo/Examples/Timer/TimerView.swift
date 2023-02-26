import SwiftUI
import Unison

struct TimerView: View, UnisonView {
    
    let state: TimerViewState
    let handler: (TimerEvent) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(state.elapsedFormatted)
                .font(.largeTitle)
                .padding(.top, 100)
                .frame(minWidth: 100)
            
            timerButtons
            
            durationSlider
            
            Spacer()
        }
    }
}

extension TimerView {
    private var durationSlider: some View {
        VStack {
            Slider(
                value: .init(
                    get: { state.duration },
                    set: { handler(.durationChanged(duration: $0)) }
                ),
                in: state.minDuration...state.maxDuration,
                step: 1
            )
            Text(String(format: "Duration: %.f sec", state.duration))
        }
        .padding()
    }
    
    private var timerButtons: some View {
        HStack {
            switch state.state {
            case .idle:
                button(systemName: "play") { handler(.start) }
            case .paused:
                button(systemName: "play") { handler(.start) }
                button(systemName: "stop") { handler(.reset) }
            case .running:
                button(systemName: "pause") { handler(.pause) }
                button(systemName: "stop") { handler(.reset) }
            }
        }
    }
    
    private func button(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .contentShape(Rectangle())
        }
    }
}

#if DEBUG
struct TimerView_Previews: PreviewProvider {

    static var previews: some View {
        render(.initial)
        render(.initial.copy(state: .running, elapsed: 61))
        render(.initial.copy(state: .paused, elapsed: 1_000))
    }
    
    static func render(_ state: TimerViewState) -> some View {
        TimerView(state: state, handler: { _ in })
    }
}
#endif
