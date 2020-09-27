//
//  MockURLSession.swift
//  PhotoLove
//
//  Created by Sharad on 27/09/20.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    
    var testDataTask = MockURLSessionDataTask()
    var testDataJSONFile: String?
    var testError: Error?
    var testMethod: String?
    
    private var testData: Data?
    private (set) var lastURL: URL?
    
    private var defaultTestBundle: Bundle? {
        return Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") }
    }
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func failureHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        testMethod = request.httpMethod
        do {
            guard let path = defaultTestBundle?.path(forResource: testDataJSONFile, ofType: "json") else {
                testError = PhotosErrors.invalidAPIResponse
                completionHandler(testData, failureHttpURLResponse(request: request), testError)
                return testDataTask
            }
            testData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {}
        completionHandler(testData, successHttpURLResponse(request: request), testError)
        return testDataTask
    }

    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
