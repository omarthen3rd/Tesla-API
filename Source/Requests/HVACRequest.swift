import Foundation

public struct HVACReqeust: RequestProtocol {
    public enum HVACState {
        case start
        case stop
    }
    typealias CompletionType = Bool
    var path: String {
        switch state {
        case .start:
            return "/api/1/vehicles/\(vehicleIdentifier)/command/auto_conditioning_start"
        case .stop:
            return "/api/1/vehicles/\(vehicleIdentifier)/command/auto_conditioning_stop"
            
        }
    }
    
    let method = WebRequest.RequestMethod.post
    let accessToken: String
    let vehicleIdentifier: String
    let state: HVACState
    
    public init(accessToken: String, vehicleIdentifier: String, state: HVACState) {
        self.accessToken = accessToken
        self.vehicleIdentifier = vehicleIdentifier
        self.state = state
    }
    
    public func execute(completion: @escaping (Result<Bool>) -> Void) {
        WebRequest.request(path: path, method: method, accessToken: accessToken) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                    
                }
            } else if let data = data {
                do {
                    let resultResponse = try JSONDecoder().decode(ResultResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(resultResponse.response.result))
                        
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                        
                    }
                }
            }
        }
    }
    
}

