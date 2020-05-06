# Gedatsu
Gedatsu provide readable foramt about AutoLayout error console log

## Abstract
In runtime Gedatsu hooking console log and format it to human readable about AutoLayout ambigious constraints.

| Original |  Gedatsu  |
| ---- | ---- |
|  <img width="100%" src="https://github.com/bannzai/Gedatsu/blob/master/docs/autolayout.png" />  |  <img width="100%" src="https://github.com/bannzai/Gedatsu/blob/master/docs/gedatsu.png" />  |

## Install
### Cocoapods
Add the line below to Podfile and to exec `$ pod install`.
```ruby
pod 'Gedatsu' configuration: %w(Debug)
```

### Swift Package Manager
Gedatsu supported to install via Swift Package Manager.
You can add Gedatsu on Xcode GUI. See [document](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app). 

## Usage
Gedatsu will start when after call `Gedatsu.open`.
As an good example, call `Gedatsu.open` when `AppDelegate.application:didFinishLaunchingWithOptions:`.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Gedatsu.open()
    return true
}
```

## LICENSE
Gedatsu is released under the MIT license. See LICENSE for details.
