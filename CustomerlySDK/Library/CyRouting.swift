//
//  CyRouting.swift
//  Customerly
//
//  Created by Paolo Musolino on 09/10/16.
//
//


enum CyRouting{
    
    case Event([String: Any]?)
    case Ping([String: Any]?)
    case MessageSend([String: Any]?)
    case ConversationRetrieve()
    
    var urlRequest: URLRequest{
        let touple : (path: String, parameters: [String: Any]?) = {
            switch self{
            case .Event(let params):
                return("/event/", params)
                
            case .Ping(let params):
                return("/ping/index/", params)
                
            case .MessageSend(let params):
                return("/message/send/", params)
                
            case .ConversationRetrieve():
                return("/conversation/retrieve/", nil)
            }
        }()
        
        let url:URL = URL(string: API_BASE_URL)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(touple.path))
        urlRequest.httpBody = createDataFromJSONDictionary(dataToSend: touple.parameters)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
    
    
    func createDataFromJSONDictionary(dataToSend: [String:Any]?) -> Data?{
        
        guard dataToSend != nil else{
            return nil
        }
        do{
            if JSONSerialization.isValidJSONObject(dataToSend! as NSDictionary){
                
                let json = try JSONSerialization.data(withJSONObject: dataToSend! as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let data_string = String(data: json, encoding: String.Encoding.utf8)
                
                return data_string?.data(using: String.Encoding.utf8)
            }
        }
        catch{
            cyPrint("Error! Could not create JSON for server payload.")
            return nil
        }
        
        return nil
    }
}


