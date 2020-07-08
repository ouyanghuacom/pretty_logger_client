import Flutter
import UIKit

public class SwiftMdnsServicePlugin: NSObject, FlutterPlugin, NetServiceDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pretty_logger_client/mdns_service", binaryMessenger: registrar.messenger())
        let instance = SwiftMdnsServicePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            let map = call.arguments as! [String: Any]
            let domain = map["domain"] as! String
            let type = map["type"] as! String
            var name = map["name"] as! String
            name = name == "" ? UIDevice.current.name : name;
            let port = map["port"] as! Int32
            start(domain: domain, type: type, name: name, port: port) { error in
                result(error)
            }
        case "setTxtRecord":
            let map = call.arguments as! [String:Data]
            result(setTxtRecord(txtRecord: map) ? nil : "fail to set txt record")
        case "stop":
            stop { error in
                result(error)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func start(domain: String, type: String, name: String, port: Int32, completion: ((String?)->Void)?) {
        didStart = {[weak self] error in
            self?.didStart = nil
            if nil != error {
                self?._service = nil
            }
            completion?(error)
        }
        guard _service == nil else {
            didStart?("service is already started: \(_service!)")
            return
        }
        _service = NetService(domain: domain, type: type, name: name, port: port)
        _service?.delegate = self
        _service?.publish()
    }
    
    public func setTxtRecord(txtRecord: [String: Data]) -> Bool{
        return _service?.setTXTRecord(NetService.data(fromTXTRecord: txtRecord)) ?? false;
    }
    
    public func stop(completion: ((String?)->Void)?){
        didStop = {[weak self] error in
            self?.didStop = nil
            self?._service = nil
            completion?(error)
        }
        
        guard _service != nil else{
            didStop?("service is already stoped");
            return
        }
        _service?.remove(from: RunLoop.main, forMode: .default)
        _service?.stop()
    }
    
    public func netServiceDidStop(_ sender: NetService) {
        NSLog("netServiceDidStop: \(sender)")
        didStop?(nil)
    }
    
    public func netServiceWillPublish(_ sender: NetService) {
        NSLog("netServiceWillPublish: \(sender)")
    }
    
    public func netServiceDidPublish(_ sender: NetService) {
        NSLog("netServiceDidPublish: \(sender)")
        didStart?(nil)
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        NSLog("didNotPublish: \(sender) \(errorDict)")
        didStart?(String.init(data: try! JSONSerialization.data(withJSONObject: errorDict, options: .fragmentsAllowed), encoding: .utf8))
    }
    
    private var _service: NetService?
    
    private var didStart: ((String?)->Void)?
    
    private var didStop: ((String?)->Void)?
}
