# Unison

Whether you're looking to prototype your UI first, test drive it, or do a technical planning with your team before starting development, Unison is designed with modern practices in mind. This framework provides guidelines and enforces strict rules for updating the state of your application, promoting reliable, bug-free code and making it easy to reason about the system's behavior.

With Unison, you can build applications with confidence, knowing that the framework is optimized for scalability, maintainability, and performance.

Join the Unison community today and discover a new world of modern, reactive programming that can take your applications to the next level.

### How does it work?

<img src="https://github.com/davidscheutz/Unison/blob/master/Unison.png" alt="Unison" width="300" height="390">

**View**

Every `SwiftUI.View` is constructed with only two parameters: an immutable state and a completion to return defined user-interaction events.

```
struct YourView: View, UnisonView {
    
    let state: YourViewState
    let handler: (YourViewEvent) -> Void    
    
```

// TODO add code snippet for state & event

Unison provides a simple class extension to instantiate your view and connect it with the framework:

```
YourView.create(
     update: YourUpdate(),
     effectHandler: YourEffectHandler()
)
```

**Update**

This is the **only** place where state updates happen. The `Update` class

// TODO add code snippet

**Effect Handler**

This is where all the side effects are handled, e.g. API calls, navigation etc.

// TODO add code snippet

### Benefits of using Unison

- **Simplicity**: Unison provides a simple, concise API for defining reactive systems. The framework is designed to be easy to use and understand, even for developers who are new to reactive programming.
- **Clear responsibilites**: Unison provides guidelines that help you build a cohesive system with clear responsibilities, making it easy to scale your project and team.
- **Testabilty**: Unison separates the pure and impure code, making it easy to write unit tests for each component of the system.
- **Thread-safe**: Unison is designed to work well in a concurrent environment, where multiple threads or processes may be updating the app state simultaneously. The framework provides built-in mechanisms for handling concurrency and preventing race conditions.
- **Preview-abilty**: Unlock the power of SwiftUI's previews and render all the different states of your screen.
- **Performance**: Unison is designed to be efficient and performant, to ensure that even large, complex systems are fast and responsive.

## Installation

TODO
1. Add Swift Package dependency
2. Add UsingCodeGenerator as Build Tool Plugin

## Demo

To see Unison in action, you can check out the included demo project. The demo project showcases some example of how to use the framework in a real-world-ish scenario.

To run the demo project, follow these steps:

1. Clone the Unison repository
2. Open the project using Xcode
3. Select UnisonDemo target
4. Build and run the project

## Inpsiration

TODO

## Contributing

Contributions to Unison are welcome and encouraged! If you have an idea for a feature or improvement, please submit a pull request or open an issue.

## License

Unison is available under the MIT license. See the LICENSE file for more information.

## Credits

Unison was created by [David Scheutz](https://www.linkedin.com/in/david-scheutz-192334157/).
