# TABCommunicate

A lightweight Multipeer connectivity wrapper to allow sending an object between devices

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Create and instance of TABCommunicate specifying it to a TABCommunicatable type and specifying a unique service name up to fifteen characters

```swift
let communicate = TABCommunicate<SomeTABCommunicatable>("myuniqueservice")
```

Now conform to the TABCommunicateDelegate protocol to receive objects and connection updates, note these updates do not currently come through on the main thread so if you are planning to update UI it's important to call out to the main thread here.

```swift
extension ViewController: TABCommunicateDelegate {
  func communicatableObjectRecieved(object: TABCommunicatable) {
    dispatch_async(dispatch_get_main_queue()) {
      //Do something
    }
  }

  func connectionDidUpdate(connected: Bool) {
    dispatch_async(dispatch_get_main_queue()) {
      //Do something
    }
  }
}
```

Send an object to connected peers with the following

```swift
communicate.sendCommunicatableObject(myObject)
```

## Requirements

iOS 9 or later

## Installation

TABCommunicate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'git@bitbucket.org:theappbusiness/tab-pods.git'
pod "TABCommunicate"
```

## Author

Neil, neil.horton@theappbusiness.com

## License

TABCommunicate is available under the MIT license. See the LICENSE file for more info.
