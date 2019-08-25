import Flutter
import UIKit
import MasterPassKit

public class SwiftMasterpassPlugin: NSObject, FlutterPlugin {
    /// Plugin registration
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "masterpass", binaryMessenger: registrar.messenger())
        let instance = SwiftMasterpassPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    /// Handle method calls from flutter. Currently only necessary to handle the checkout method call,
    /// which must pass string values for the "code", "system", and "key" keys in arguments. These values should
    /// represent:
    /// - "code": the transaction code
    /// - "system": "Live" or "Test"
    /// - "key": the masterpass api key
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "checkout" {
            let arguments = call.arguments as! NSDictionary
            let code = arguments["code"] as! String
            let system = arguments["system"] as! String
            let key = arguments["key"] as! String
            checkout(code: code, system: system, key: key, flutterResult: result)
        } else {
            result("Flutter method not implemented on iOS")
        }
    }
    
    /// Perform the masterpass checkout with the given transaction code, system , and api key.
    public func checkout(code: String, system: String, key: String, flutterResult: @escaping FlutterResult) {
        let masterpass = MPMasterPass();
        let masterpassDelegate = MasterpassDelegate(flutterResult: flutterResult);
        var masterpassSystem: MPSystem;
        system == "Live" ? (masterpassSystem = MPSystem.live) : (masterpassSystem = MPSystem.test);
        masterpass.checkout(withCode: code, apiKey: key, system: masterpassSystem, controller: UIApplication.shared.delegate?.window??.rootViewController, delegate: masterpassDelegate)
    }
}

/// Class to handle the result when masterpass payments are completed. In our case,
/// a string should always be returned to flutter using an instance of FlutterResult.
class MasterpassDelegate: UIViewController, MPMasterPassDelegate {
    /// the FlutterResult instance to use for returning results back to flutter.
    var flutterResult: FlutterResult
    
    /// Constructor used to initialize flutterResult.
    init(flutterResult: @escaping FlutterResult) {
        self.flutterResult = flutterResult
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Not supported but needs to be overridden when extending UIViewController.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    /// Return "PAYMENT_SUCCEEDED" when the payment completed successfully.
    func masterpassPaymentSucceeded(withTransactionReference transactionReference: String!) {
        let checkoutResult = CheckoutResult(code: "PAYMENT_SUCCEEDED", reference: transactionReference)
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
    
    /// Return "PAYMENT_FAILED" when the payment completed unsuccessfully.
    func masterpassPaymentFailed(withTransactionReference transactionReference: String!) {
        let checkoutResult = CheckoutResult(code: "PAYMENT_FAILED", reference: transactionReference)
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
    
    /// Return "USER_REGISTERED" if a user has been registered. User registraion is not currently used
    /// but this method must be overridden when extending MPMasterPassDelegate
    func masterpassUserRegistered() {
        let checkoutResult = CheckoutResult(code: "USER_REGISTERED", reference: "no ref. for this result")
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
    
    /// Return "INVALID_CODE" the transaction code was invalid.
    func masterpassInvalidCode() {
        let checkoutResult = CheckoutResult(code: "INVALID_CODE", reference: "no ref. for this result")
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
    
    /// Return "OUT_ERROR_CODE" when an error has occurred before the payment.
    func masterpassError(_ masterpassError: MPError) {
        let checkoutResult = CheckoutResult(code: "OUT_ERROR_CODE", reference: "no ref. for this result")
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
    
    /// Return "USER_CANCELLED" when the user cancelled the payment.
    func masterpassUserDidCancel() {
        let checkoutResult = CheckoutResult(code: "USER_CANCELLED", reference: "no ref. for this result")
        flutterResult(checkoutResult.dictionaryRepresentation)
    }
}

/// Used to model a result returned by masterpass. An instance of this class's dictionary representation
/// is returned to the flutter plugin.
class CheckoutResult {
    /// The result code for the masterpass transaction
    var code: String
    
    /// The reference for the result
    var reference: String
    
    /// Constructor
    init(code: String, reference: String) {
        self.code = code;
        self.reference = reference;
    }
    
    /// The dictionary representation of this class
    var dictionaryRepresentation : [String:String] {
        return ["code" : self.code,  "reference" : self.reference]
    }
}
