import Flutter
import UIKit
import Foundation

public class SwiftFlutterVestiSharePlugin: NSObject, FlutterPlugin {
    
    @available(iOS 9.0, *)
    private static let excludedActivityTypesForImage: [UIActivity.ActivityType] = [.openInIBooks,
                                                                                   .postToFlickr,
                                                                                   .addToReadingList,
                                                                                   .postToTencentWeibo,
                                                                                   .print,
                                                                                   .assignToContact,
                                                                                   .postToVimeo,
                                                                                   .postToTencentWeibo]
    
    private static let whatsAppUrl: String = "https://api.whatsapp.com/send"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_vesti_share", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterVestiSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "Bad Args", message: nil, details: nil))
            return
        }
        
        let imageURLs = args["paths"] as? [String]
        let phone = args["phone"] as? String
        let message = args["msg"] as? String
        let business = args["business"] as? Bool
        let useCallShareCenter = args["useCallShareCenter"] as? Bool
        
        switch call.method {
        case "whatsAppImageList":
            self.whatsAppImageList(with: imageURLs, result: result)
        case "whatsAppText":
            self.whatsAppText(with: message, phone: phone, business: business,useCallShareCenter: useCallShareCenter, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func whatsAppImageList(with imageList: [String]?, result: @escaping FlutterResult) {
        guard let imageList = imageList else {
            result(FlutterError.init(code: "Cannot find imageList", message: nil, details: nil))
            return
        }
        let imageArray = imageList.map { filePath -> UIImage? in
            return retrieveImages(filePath)
        }
        self.callShareCenter(data: imageArray as [Any], result: result)
    }
    private func whatsAppText(with text: String?, phone: String?, business: Bool?, useCallShareCenter: Bool?,result: @escaping FlutterResult) {
        let text = text ?? String()
        guard let useCallShareCenter = useCallShareCenter, !useCallShareCenter else {
            self.callShareCenter(data: [text], result: result)
            return
        }
        guard let phone = phone, let business = business else {
            self.callShareCenter(data: [text], result: result)
            return
        }
        let urlString = business ? "whatsapp://send?phone=\(phone)&text=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) :
        "\(SwiftFlutterVestiSharePlugin.whatsAppUrl)?phone=\(phone)&text=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlString = urlString, let finalUrl: URL = URL(string: urlString) else {
            self.callShareCenter(data: [text], result: result)
            return
        }
        
        guard UIApplication.shared.canOpenURL(finalUrl) else {
            result(FlutterError.init(code: "Unable to open whatsapp", message: nil, details: nil))
            return
        }
        
        guard #available(iOS 10.0, *) else {
            result(FlutterError.init(code: "Share not available", message: nil, details: nil))
            return
        }
        UIApplication.shared.open(finalUrl, options: [:], completionHandler: nil)
        result("success")
    }
    
    
    private func callShareCenter(data: [Any], result: @escaping FlutterResult) {
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let controller : FlutterViewController = window.rootViewController as! FlutterViewController
        var dataToShare: [Any] = []
        dataToShare.append(contentsOf: data)
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.view
        if #available(iOS 9.0, *) {
            activityViewController.excludedActivityTypes = SwiftFlutterVestiSharePlugin.excludedActivityTypesForImage
        }
        controller.present(activityViewController, animated: true, completion: nil)
        result("success")
    }
    
    private func retrieveImages(_ filePath: String) -> UIImage? {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
