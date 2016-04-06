![The App Business](https://github.com/theappbusiness/TABCommunicate/blob/master/Banner.png)

[![Version](https://img.shields.io/cocoapods/v/TABCommunicate.svg?style=flat)](http://cocoapods.org/pods/TABCommunicate)
[![License](https://img.shields.io/cocoapods/l/TABCommunicate.svg?style=flat)](http://cocoapods.org/pods/TABCommunicate)
[![Platform](https://img.shields.io/cocoapods/p/TABCommunicate.svg?style=flat)](http://cocoapods.org/pods/TABCommunicate)

# TABCommunicate

A lightweight, strongly typed Multipeer connectivity wrapper to allow sending an object between devices.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

###TABCommunicateConfiguration

Create a TABCommunicateConfiguration like so

```swift
let configuration = TABCommunicateConfiguration("myuniqueservice", numberOfRetryAttempts: 3, retryDelay: 1, identity: nil)
```

The configuration object lets you describe how TABCommunicate will establish a connection to other devices and handle failures. numberOfRetryAttempts has a default value of 0 and retryDelay has a default value of 1. In the identity field you can pass a certificate chain to enable you to identify and authenticate yourself to other devices.

###TABCommunicator

To send and receive objects create and retain an instance of TABCommunicator passing a configuration. When we create an instance we define what object we want to send. This Object MUST conform to the TABCommunicable protocol. We must also pass an object of type TABCommunicatorDelegate on initialization. This will handle receiving objects, authenticating certificates and updates indicating if a any peers are connected,

```swift
let communicator = TABCommunicator<SomeTABCommunicable>(configuration, delegate: self)
```

Send an object to connected peers with the following

```swift
communicator.sendCommunicableObject(myObject) { result in
  switch result {
  case .Success:
    //Do something
  case .Failure(let error):
    //Handle error
  }
}
```

###TABCommunicable

In order to for a object to be sent and received it must conform to the TABCommunicable protocol which requires the two functions

```swift
public protocol TABCommunicable {
  static func create(data: NSData) -> Self
  func dataRepresentation() throws -> NSData
}
```

###TABCommunicatorDelegate

The TABCommunicatorDelegate will receive updates when an object is sent and when the connection did update. It is also in charge of deciding if we trust a peer enough to connect to it based on their certificate.

```swift
extension ViewController: TABCommunicateDelegate {
  func CommunicableObjectRecieved(object: SomeTABCommunicable) {
    //Do something
  }

  func connectionDidUpdate(connected: Bool) {
    //Do something
  }

  func validateCertificate(certificate: [SecCertificateRef]?) -> Bool {
    //Decide if we trust this certificate
    return trustCertificate ? true : false
  }
}
```

## Requirements

iOS 9 or later

## Installation

TABCommunicate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TABCommunicate"
```

## Author

Neil3079, neil.horton@theappbusiness.com

## License

TABCommunicate is available under the MIT license. See the LICENSE file for more info.
