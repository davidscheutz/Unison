# Unison

First things first: This is the beginning of a community-driven open-source project actively seeking contributions, be it code, documentation, or ideas.

### Overview

Unison is tailored to suit modern development practices. Whether you prefer to prototype and preview the UI first, test-drive it or work based on specifications resulting from a technical planning.

Applications build with Unison are consistent and simple, harnessing the power of both Functional Programming (FP) and Object-Oriented Programming (OOP). 

By incorporating key principles from these paradigms, Unison offers:

- **Predictability**: Pure functions and immutability for consistent, reliable behavior.
- **Testability**: Easily perform unit testing and debugging with isolated functions.
- **Concurrency**: Safeguard against data races in concurrent environments using immutable data structures.
- **Encapsulation**: Enhance code organization and maintainability by grouping data and related methods.
- **Inheritance**: Promote modularity and code reuse through class hierarchies.
- **Polymorphism**: Increase flexibility and extensibility with a unified interface for various data types.

These principles facilitate the development of robust, reliable, and bug-free Swift applications. 

Unison is compatible with all Apple platforms (iOS, macOS, tvOS, and watchOS) and comes with convenient syntax for seamless integration with SwiftUI.

### Concepts

The Unison framework is based on the Model-Update-Effect (MUE) pattern. MUE emphasizes unidirectional data flow and the separation of state, business logic, and side effects, fostering maintainable and testable applications.

<img src="https://github.com/davidscheutz/Unison/blob/master/Unison.png" alt="Unison" width="300" height="390">

## Demo

Not in the mood to read more documentation?
To see Unison in action, checkout the included demo project that showcases some examples of how to use the framework in real-world-ish scenarios.

<img width="336" alt="Screenshot 2023-06-15 at 21 12 50" src="https://github.com/davidscheutz/Unison/assets/14020916/bf78b04b-df33-4e30-af7a-87ba21240179">

To run the demo project, follow these steps:

1. Clone or downlaod the Unison repository
2. Open the project using Xcode
3. Select UnisonDemo target
4. Build and run the project

## Installation

TODO add more details
1. Add Swift Package dependency
2. Add Unison CodeGenerator as Build Tool Plugin

### How does it work?

**State**

The State component is a model containing all the information required to render the view. It should be immutable, with all fields declared using the `let` keyword.

```swift
struct YourViewState: Equatable, SmartCopy {
    let userInput: String
}
```

Unison generates copy functions for each struct that conforms to the `SmartCopy` protocol.

Implementing the `Equatable` protocol is required by Unison to determine state changes. 

**Event**

The Event component defines all user interactions that can be captured by the screen. It should be designed to be as granular as possible to enable more precise control over state updates.

```swift
enum YourViewEvent {
    case userInputChanged(String)
}
```

**Update**

The Update component is the only place where state updates occur. It is designed to be pure, meaning that all functions implemented here are deterministic and therefore easily testable. 

`Update` requires two functions to be implemented: one to handle user input (events), and another to handle results from effects.

```swift
typealias Result = UpdateResult<YourViewState, YourEffect>

func handle(event: YourViewEvent, _ currentState: YourViewState) -> Result
func handle(result: YourEffect.Result, _ currentState: YourViewState) -> Result
```

The return value for an update function can be:

```swift
public enum UpdateResult<State, Effect> {
    case noChange
    case newState(state: State)
    case dispatchEffect(state: State, effect: Effect)
}
```

**Effect**

The Effect component represents functions that have side effects, such as API calls, persisting data, and navigation. Effects need to have defined results as well.

```swift
enum YourEffect: Effect {
    case action(input: String)
    
    enum YourResult {
        case success
        case failure(Error)
    }
}
```

**Effect Handler**

The Effect Handler is where code is implemented to perform each effect defined previously.

```swift
func handle(_ effect: YourEffect) async -> EffectResult<YourEffect.Result> {
```

The retrun value for an effect can be:

```swift
public enum EffectResult<Result> {
    case repeating(AsyncStream<Result>)
    case single(Result)
    case empty
}
```

**Putting it all together**

Every `View` is constructed with two parameters: an immutable state and a completion that handles user input.

```swift
struct YourView: View, UnisonView {
    
    let state: YourViewState
    let handler: (YourViewEvent) -> Void

```

`UnisonView` provides a several extension to instantiate and connect your views.

```swift
YourView.create(
     initialState: YourViewState(),
     update: YourUpdate.self,
     effectHandler: YourEffectHandler.self
)
```

## Inpsiration

This framework is inpired mainly inspired by [Mobius](https://github.com/spotify/mobius). The intention was to create something more leight-weight and straight-forward to use for iOS.

## Contributing

Contributions to Unison are welcome and encouraged! If you have an idea for a feature or improvement, please submit a pull request or open an issue.

## License

Unison is available under the MIT license. See the LICENSE file for more information.

## Credits

Unison was created by [David Scheutz](https://www.linkedin.com/in/david-scheutz-192334157/).
