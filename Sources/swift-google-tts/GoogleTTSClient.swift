//
//  GoogleTTSClient.swift
//  AuthPackageDescription
//
//  Created by Baris Atamer on 1/16/20.
//

import Foundation
import NIO
import OAuth2
import NIOHPACK
import GRPC

public class GoogleTTSClient {
    public static let shared = GoogleTTSClient()
    private init() {}
    
    enum AuthError: Error {
        case noTokenProvider
        case tokenProviderFailed
    }
    
    struct Constants {
        static let host: String = "texttospeech.googleapis.com"
        static let port: Int = 443
        static let scopes: [String] = ["https://www.googleapis.com/auth/cloud-platform"]
    }
    
    public typealias Result<T> = Swift.Result<T, Error>
    public typealias ResultCompletion<T> = (_ result: Result<T>) -> ()
    
    // MARK: Public Methods
    
    /// Returns a list of Voice supported for synthesis.
    public func listVoices(
        request: Google_Cloud_Texttospeech_V1_ListVoicesRequest,
        completion: @escaping ResultCompletion<Google_Cloud_Texttospeech_V1_ListVoicesResponse>
    ) throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = makeServiceClient(
            host: Constants.host,
            port: Constants.port,
            eventLoopGroup: eventLoopGroup
        )
        
        let callOptions = try prepareCallOptions(eventLoopGroup: eventLoopGroup)
        let call = client.listVoices(request, callOptions: callOptions)
        call.response.whenComplete { result in
            completion(result)
        }
        
        if Thread.isMainThread {
            print("✅ Main Thread")
        } else {
            print("❌ Not Main Thread")
        }
        
//        _ = try call.response.wait()
//        try eventLoopGroup.syncShutdownGracefully()
//        eventLoopGroup.shutdownGracefully { (error) in
//            if let error = error {
//                print("Shut down \(error)")
//            } else {
//                print("no error, shut down gracefully")
//            }
//        }
    }
    
    /// Synthesizes speech synchronously: receive results after all text input
    /// has been processed.
    public func synthesizeSpeech(
        request: Google_Cloud_Texttospeech_V1_SynthesizeSpeechRequest,
        completion: @escaping ResultCompletion<Google_Cloud_Texttospeech_V1_SynthesizeSpeechResponse>
    ) throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = makeServiceClient(
            host: Constants.host,
            port: Constants.port,
            eventLoopGroup: eventLoopGroup
        )
        let callOptions = try prepareCallOptions(eventLoopGroup: eventLoopGroup)
        let call = client.synthesizeSpeech(request, callOptions: callOptions)
        call.response.whenComplete { result in
            completion(result)
        }
    }

    // MARK: Private Methods
    
    private func prepareCallOptions(eventLoopGroup: EventLoopGroup) throws -> CallOptions {
        // Get an auth token.
        let authToken = try getAuthToken(
            scopes: Constants.scopes,
            eventLoop: eventLoopGroup.next()
        ).wait()
        
        // Use CallOptions to send the auth token (necessary) and set a custom timeout (optional).
        let headers: HPACKHeaders = ["authorization": "Bearer \(authToken)"]
        let callOptions = CallOptions(customMetadata: headers, timeout: .seconds(rounding: 30))
        debugPrint("CALL OPTIONS\n\(callOptions)\n")
        return callOptions
    }
    
    /// Get an auth token and return a future to provide its value.
    private func getAuthToken(
        scopes: [String],
        eventLoop: EventLoop
    ) -> EventLoopFuture<String> {
        let promise = eventLoop.makePromise(of: String.self)
        guard let provider = DefaultTokenProvider(scopes: scopes) else {
            promise.fail(AuthError.noTokenProvider)
            return promise.futureResult
        }
        do {
            try provider.withToken { (token, error) in
                if let token = token,
                    let accessToken = token.AccessToken {
                    promise.succeed(accessToken)
                } else if let error = error {
                    promise.fail(error)
                } else {
                    promise.fail(AuthError.tokenProviderFailed)
                }
            }
        } catch {
            promise.fail(error)
        }
        return promise.futureResult
    }

    /// Create a client and return a future to provide its value.
    private func makeServiceClient(
        host: String,
        port: Int,
        eventLoopGroup: MultiThreadedEventLoopGroup
    ) -> Google_Cloud_Texttospeech_V1_TextToSpeechServiceClient {
        let configuration = ClientConnection.Configuration(
            target: .hostAndPort(host, port),
            eventLoopGroup: eventLoopGroup,
            tls: .init()
        )
        let connection = ClientConnection(configuration: configuration)
        return Google_Cloud_Texttospeech_V1_TextToSpeechServiceClient(connection: connection)
    }
}
