import Cocoa
import FlutterMacOS


class MainFlutterWindow: NSWindow {
    let screenshotChannelName = "samples.flutter.dev/screenshot";
    
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        let batteryChannel = FlutterMethodChannel(
            name: screenshotChannelName,
            binaryMessenger: flutterViewController.engine.binaryMessenger)
        batteryChannel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "captureScreen":
                self.captureEntireScreen(result: result)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        super.awakeFromNib()
    }
    
    private func captureEntireScreen(result: FlutterResult) {
        guard let screenshot = captureAppScreenshot(), let screenshotBase64String = screenshot.toBase64String(format: NSBitmapImageRep.FileType.png) else { return }
        print(screenshotBase64String)
        result(screenshotBase64String)
    }
    
    
    func captureAppScreenshot() -> NSImage? {
        // Get the window ID of the main application window
        guard let window = NSApplication.shared.mainWindow else {
            print("No main window found")
            return nil
        }
        
        let windowID = window.windowNumber
        let imageRef = CGWindowListCreateImage(CGRect.null,
                                               .optionIncludingWindow,
                                               CGWindowID(windowID),
                                               .bestResolution)

        // Convert the CGImage to an NSImage
        guard let cgImage = imageRef else {
            print("Failed to capture image")
            return nil
        }

        return NSImage(cgImage: cgImage, size: window.frame.size)
    }
}

extension NSImage {
    func toBase64String(format: NSBitmapImageRep.FileType) -> String? {
        guard let tiffData = self.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let imageData = bitmapRep.representation(using: format, properties: [:]) else {
            print("Failed to create image data")
            return nil
        }
        
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}
