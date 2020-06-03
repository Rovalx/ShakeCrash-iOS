import Foundation

internal extension URLRequest {
    private func formHeader(_ name: String, crlf: String, fileName: String? = nil, mimeType: String? = nil) -> String {
        var str = "\(crlf)Content-Disposition: form-data; name=\"\(name)\""
        guard fileName != nil || mimeType != nil else { return str + crlf + crlf }
        
        if let name = fileName {
            str += "; filename=\"\(name)\""
        }
        str += crlf
        if let type = mimeType {
            str += "Content-Type: \(type)\(crlf)"
        }
        return str + crlf
    }
    
    mutating func setPost(body parameters: [[String: Any]]) {
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--\(boundary)".data(using: .utf8)!)
        
        let crlf = "\r\n"
        for parameter in parameters {
            guard let paramName = parameter["name"] as? String else { continue }
            
            if let value = parameter["value"] {
                let header = formHeader(paramName, crlf: crlf)
                data.append("\(header)\(value)".data(using: .utf8)!)
            } else if let fileData = parameter["file"] as? Data {
                let header = formHeader(paramName, crlf: crlf, fileName: "image.jpg", mimeType: "image/jpeg")
                data.append(header.data(using: .utf8)!)
                data.append(fileData)
            } else {
                print("\(paramName): empty or invalid value")
                continue
            }
            data.append("\(crlf)--\(boundary)".data(using: .utf8)!)
        }
        data.append("--\(crlf)".data(using: .utf8)!)
        self.httpBody = data
    }
}
