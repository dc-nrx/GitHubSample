//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//
import Foundation

enum RequestHandler {
    case error(Error)
    case closure((URLRequest) -> (URLResponse, Data?))
    case stub(URLResponse, Data?)
    case statusCode(Int, Data?)
    
    func process(_ request: URLRequest) throws -> (URLResponse, Data?) {
        switch self {
        case .error(let error):
            throw error
        case .closure(let f):
            return f(request)
        case .stub(let response, let data):
            return (response, data)
        case .statusCode(let code, let data):
            let response = HTTPURLResponse(
                url: URL(string: "http://sample")!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
    }
}

class MockURLProtocol: URLProtocol {

    // 1. Handler to test the request and return mock response.
    static var requestHandler: RequestHandler?

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable")
        }
        
        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler.process(request)

            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
              // 4. Send received data to the client.
              client?.urlProtocol(self, didLoad: data)
            }

            // 5. Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func stopLoading() { }
}
