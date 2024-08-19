#  Git Hub Sample App

For the assignment details, please refer to `AssignmentDetails.pdf` in the project root.

---

The app is devided into several packages:
- **API**: Contains the model structs, API interface and its implementations - both real and previews that provide mocked data.

- **ViewModel**: Pretty much self-decribing - all the view models are located here. In addition to the view models and a couple of complementary types, it has a view model factory. If not for unit testing and issues with @testable (see "Xcode bugs" below), view model initializers would have been made internal, and the factory used as a single place to initialize them. 

- **UI**: Contains all the UI of the app, except for the top level `struct GitHubSampleApp: App`.

- **GitHubSample**: the app. It is responsible only for placing the root view, and for the dependency injection.

I prefer not to use 3d parties unless they have some considerable value. It is especially true in the recent years, as so many great standard frameworks have been introduced. Thus, the only external lib I've used here is `SDWebImage`, which handles remote images in a magnificent way (including cache).  

As there were no requirements on backward compatibility, I've followed the common practice and set it to the last 2 versions - that is, starting from iOS 16. 

There are also some component-specific considerations - please refer to the respective docs to see them.

## Important Notes

As token is a sensitive piece of data, it has not been pushed into the repo. In order to use one, please add `./GitHubSample/Config/Secrets.xcconfig` file (added to .gitignore) locally, with `GITHUB_AUTH_TOKEN=your_token_here` in it. You will also need to add the file to the project.
It is worth mentioning that the app works perfectly fine without a token set, so you might skip this step if you wish to.

Several consideration related to Xcode bugs:
- I had to remove `@testable import`s from packages, as they were preventing the app from building for profiling (i.e., to analyze it via Instruments). For this reason, I had to change the access rights of some methods from internal to public.
- In order to use SwiftUI previews in the UI package, please open the package directly. If opened in context of the main project, the Preview bundle can't be properly loaded, which in turn renders the previews virtually impossible to use.
- Not surprisingly, the debugger makes the app work much slower than it actually is, which is is even more so due to extensive logging. Therefore, to properly assess the performance, please launch the app without the debugger attached.

## Nice extras:

- Japanese localization (except for error messages). Can't guarantee the translations quality though! 
- TipKit integration - on rather basic level, can be seen in the user details screen.
- Comprehensive API that allows adding new endpoints in a matter of minutes - and several new scenes in a single day.
- Mocks powering extensive unit tests and highly customizable data for previews.

## Area for improvement:

While the minimum specifications have been met, there are quite a few things I would love to add on top of them, if there was more time:

- WebView layout tunes (e.g. an activity indicator on initial load)
- Extensive unit tests coverege of `ViewModel` package
- Animation during fetch operation
- Handling cases for missing URLs (esp. for avatars) - seems like it never happens, but still it is not safe to depend on it.
- Extend ViewModel & UI to support filters - sort order, first page etc. (The model already supports them)
- Implement UI tests
- iPadOS-tuned layout. While the iOS version of the app works ok on iPad, the layout can be significantly enhanced. Most of all, I would've used grids instead of lists for repos, and a master-detail navigation style (users list -> user details).
- Localized and clear error messages
- Accessibility
- Network status tracking - e.g. no internet connection. (however, it's somewhat covered with the existed errors)
- WatchOS & MacOS apps. (as all sub-libraries up to `ViewModel`, as well as significant parts of `UI`, are platform-agnostic)
- Process some GitHub remote API errors mentioned in the docs that indicate rate limit excess.
- UIKit version of the app (just for fun, to see how good the SwiftUI-tuned `ViewModel` would power it)
- Moving response parsing & disc access operations to a background thread. However, taking into account the rather limited magnitude of these operations in the app, it might not be feasible.
- Pull Request pipeline - 1) run unit- (and UI-, if any) tests and block merge to develop/main if any fails. 2) check minimum test coverage for `ViewModel` and `API` packages and block the PR if it is not sufficient. 
- Enhance TipKit integration
- Tune the image resize animation in user details (e.g. animation path of the text and overlap with the image while animating)
- Disable landscape orientation for certain scenes on iOS (at least in the users list, probably user details and web view as well)
