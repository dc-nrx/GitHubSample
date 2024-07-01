#  Git Hub Sample App

The app is devided into several packages:
- **API**: Contains the model structs, API interface and its implementations - both real and previews that provide mocked data.

- **ViewModel**: Pretty much self-decribing - all the view models are located here. In addition to the view models and a couple of complementary types, it has a view model factory. If not for unit testing and issues with @testable (see "Xcode bugs" below), view model initializers would have been made internal, and the factory used as a single place to initialize them. 

- **UI**: Contains all the UI of the app, except for the top level `struct GitHubSampleApp: App`.

- **GitHubSample**: the app. It is responsible only for placing the root view, and for the dependency injection.

## Important Notes

As token is a sensitive piece of data, it has not been pushed into the repo. In order to use one, please add **Config/Secrets.xcconfig** (added to .gitignore) locally, with `GITHUB_AUTH_TOKEN=your_token_here`. It is worth mentioning that the app works perfectly fine without a token set, so you might skip this step if you wish to. 

Several consideration related to Xcode bugs:
- I had to remove @testable imports from packages, as it was preventing the app to build for profiling (that is, to analyze it via Instruments). For this reason, I had to change access rights to some methods frome internal to public.
- In order to use SwiftUI previews in the UI package, please open the package directly. If opened in context of the main project, the Preview bundle can't be properly loaded, which in turn renders the previews virtually impossible to use.
- Not surprisingly, the debugger makes the app work much slower than it actually is, which is is even more so due to extensive logging. Therefore, in order to properly see the preformance level, please launch the app withoug the debugger attached.

## Area for improvement:

While the minimum specifications have been met, there are quite a few things I would love to add on top of them, if there was more time:

- WebView layout tunes (e.g. a loader)
- Animations showing fetch operation
- Extend ViewModel & UI to support filters (sort order, first page). The model already supports them.
- Implement UI tests
- iPadOS-tuned layout. While the iOS version of the app works ok, the layout can be significantly enhanced. Most of all, I would've used grids instead of lists for repos, and a master-detail navigation style (users list -> user details).
- Localized and clear error messages
- Accessibility
- Network status tracking - e.g. no internet connection. (however, it's somewhat covered with the error messages)
- WatchOS & MacOS apps. (as all sub-libraries up to `ViewModel`, as well as significant pieces of `UI`, are platform-agnostic)
- Process some API errors mentioned in the docs that indicate rate limit excess. 
- UIKit version of the app (just for fun, to see how good the SwiftUI-tuned `ViewModel` would power it)
- Moving response parsing & disc access operations to a background thread. However, taking into account the rather limited magnitude of these operations in the app, it might not be quite feasible.
