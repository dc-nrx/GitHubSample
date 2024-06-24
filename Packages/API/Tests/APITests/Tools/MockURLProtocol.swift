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

    /// Handler to test the request and return mock response.
    ///
    /// While using `static` is not the best way to go,
    /// it still is a reasonable tradeoff in the current case.
    static var requestHandler: RequestHandler?

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable")
        }
        guard let client else { return }
        
        do {
            
            let (response, data) = try handler.process(request)
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
              client.urlProtocol(self, didLoad: data)
            }
            
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
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
