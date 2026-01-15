# shopping-sample-code
Sample code for an imaginary e-commerce app

This app is multiplatform. It can be run on both iPhone and Apple TV.

** Data loading **
The data could be deserialized directly from the included data.json file, but instead, we download it from the github repository for the sake of example to simulate a call to an API. Likewise, images should be downloaded, but for the sake of example, they are just Image Resources from the Asset Catalog, referred to by name from the data.

** Thread yielding **
Since properties marked with the @Published property wrapper will be accessed by SwiftUI,
I mark ContentViewModel with @MainActor to ensure they are always accessed from the main queue. By contrast, any async call in the view model will be executed on a background queue.
