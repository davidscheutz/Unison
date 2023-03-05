# Unison

First things first: This is the beginning of a community-driven open-source project actively seeking contributions, be it code, documentation, or ideas.

Whether you're looking to prototype your UI first, test drive it, or do a technical planning with your team before starting development, Unison is designed with modern practices in mind. 

This framework provides guidelines and enforces strict rules for updating the state of your application, promoting reliable, bug-free code and making it easy to reason about the system's behavior.

### Overview

The Unison framework is based on the Model-View-Update (MVU) pattern. MVU promotes a unidirectional flow of data, where the state of the system is represented by a model, and user interactions or external events trigger updates to the model, which in turn trigger updates to the view.

<img src="https://github.com/davidscheutz/Unison/blob/master/Unison.png" alt="Unison" width="300" height="390">

### Benefits of using Unison

- **Simplicity**: Unison provides a simple, concise API for defining reactive systems. The framework is designed to be easy to use and understand, even for developers who are new to reactive programming.
- **Separation of Concerns**: Unison provides guidelines that help you build a cohesive system with clear responsibilities, making it easy to scale your project and team.
- **Testabilty**: Unison separates the pure and impure code, making it easy to write unit tests for each component of the system.
- **Thread-safe**: Unison is designed to work well in a concurrent environment, where multiple threads or processes may be updating the app state simultaneously. The framework provides built-in mechanisms for handling concurrency and preventing race conditions.
- **Preview-abilty**: Unlock the power of SwiftUI's previews and render all the different states of your screen.
- **Performance**: Unison is designed to be efficient and performant, to ensure that even large, complex systems are fast and responsive.

## Installation

TODO add more details
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

This framework is inpired mainly inspired by [Mobius](https://github.com/spotify/mobius). The intention was to create something more leight-weight and straight-forward to use for iOS.

## Contributing

Contributions to Unison are welcome and encouraged! If you have an idea for a feature or improvement, please submit a pull request or open an issue.

## License

Unison is available under the MIT license. See the LICENSE file for more information.

## Credits

Unison was created by [David Scheutz](https://www.linkedin.com/in/david-scheutz-192334157/).
