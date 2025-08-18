import UIKit
import Flutter
import FirebaseCore
import Firebase
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    // Add this property declaration
    private var blurEffectView: UIVisualEffectView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        /*
        GMSServices.provideAPIKey("AIzaSyDxV49qBfzHOacA1gdXJGLWt5BFlmV-l2I")
        */
        GMSServices.provideAPIKey("AIzaSyBgxbAZamRlb_7KLfeAVUzeeFoSlaaLZ1Y")

        GeneratedPluginRegistrant.register(with: self)

        let controller: UIViewController = window?.rootViewController as! UIViewController

        // Add observer to detect app going to background
        NotificationCenter.default.addObserver(self,
                                           selector: #selector(secureScreen),
                                           name: UIApplication.willResignActiveNotification,
                                           object: nil)

        // Remove blur effect when app becomes active
        NotificationCenter.default.addObserver(self,
                                           selector: #selector(removeBlurEffect),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @objc func secureScreen() {
        if blurEffectView == nil {
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.frame = window?.frame ?? CGRect.zero
            blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            window?.addSubview(blurEffectView!)
        }
    }

    @objc func removeBlurEffect() {
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
}