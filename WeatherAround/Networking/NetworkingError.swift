//
//  NetworkingError.swift
//  WeatherAround
//
//  Created by Миша Перевозчиков on 15.10.2022.
//

import Foundation

enum NetworkingError: Int, Error, LocalizedError {
    // 100 Informational
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    case earlyHints = 103
        
    // 300 Redirection Messages
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case permanentRedirect = 308

    // 400 Client Error Responses
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misDirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case tooEarly = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    
    // 500 Server Error Responses
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    
    // Generic errors
    case unknownError
    case badURLResponse
    case timeout
    
    var errorDescription: String? {
        "Networking Error: \(self), Status Code: \(self.rawValue)"
    }
    
    static func error(_ statusCode: Int) -> Self {
        guard let networkError = NetworkingError(rawValue: statusCode) else {
            return NetworkingError.unknownError
        }
        return networkError
    }
}
