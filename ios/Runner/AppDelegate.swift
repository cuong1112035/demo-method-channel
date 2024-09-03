import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    let screenshotChannelName = "samples.flutter.dev/screenshot";
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let flutterViewController = window?.rootViewController as! FlutterViewController
        let screenshotChannel = FlutterMethodChannel(name: screenshotChannelName, binaryMessenger: flutterViewController.binaryMessenger)
        screenshotChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard let self = self else { return }
            switch call.method {
            case "captureScreen":
                self.captureEntireScreen(result: result)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func captureEntireScreen(result: FlutterResult) {
        guard let view = UIApplication.shared.windows.first?.rootViewController?.view else {
            return
        }
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let screenshotImage = renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        guard let imageBase64String = screenshotImage.pngData()?.base64EncodedString() else {
            return;
        }
        result(imageBase64String)
    }
}
