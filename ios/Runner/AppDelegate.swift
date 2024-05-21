import UIKit
import Flutter

class SecureWindow: UIWindow {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if #available(iOS 13.0, *) {
            self.isSecure = true
        }
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override var window: UIWindow? {
      get {
          return super.window
      }
      set {
          let secureWindow = SecureWindow(frame: UIScreen.main.bounds)
          secureWindow.rootViewController = newValue?.rootViewController
          super.window = secureWindow
      }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
