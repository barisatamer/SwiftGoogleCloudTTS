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
    
    enum AuthError: Error {
        case noTokenProvider
        case tokenProviderFailed
    }
    
    struct Constants {
        static let host: String = "texttospeech.googleapis.com"
        static let port: Int = 443
        static let scopes: [String] = ["https://www.googleapis.com/auth/cloud-platform"]
    }
    
    public var eventLoopGroup: EventLoopGroup
    
    // MARK: Public Initializer
    
    public init(
        eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    ) {
        self.eventLoopGroup = eventLoopGroup
    }
    
    // MARK: Public Methods
    
    /// Returns a list of Voice supported for synthesis.
    public func listVoices(
        request: Google_Cloud_Texttospeech_V1beta1_ListVoicesRequest
    ) -> EventLoopFuture<Google_Cloud_Texttospeech_V1beta1_ListVoicesResponse> {
        let client = makeServiceClient(
            host: Constants.host,
            port: Constants.port,
            eventLoopGroup: eventLoopGroup
        )
        return prepareCallOptions(eventLoopGroup: eventLoopGroup)
            .flatMap { callOptions -> EventLoopFuture<Google_Cloud_Texttospeech_V1beta1_ListVoicesResponse> in
                return client.listVoices(request, callOptions: callOptions).response
        }
    }
    
    /// Synthesizes speech synchronously: receive results after all text input
    /// has been processed.
    public func synthesizeSpeech(
        request: Google_Cloud_Texttospeech_V1beta1_SynthesizeSpeechRequest
    ) -> EventLoopFuture<Google_Cloud_Texttospeech_V1beta1_SynthesizeSpeechResponse> {
        let client = makeServiceClient(
            host: Constants.host,
            port: Constants.port,
            eventLoopGroup: eventLoopGroup
        )
        return prepareCallOptions(eventLoopGroup: eventLoopGroup)
            .flatMap { callOptions -> EventLoopFuture<Google_Cloud_Texttospeech_V1beta1_SynthesizeSpeechResponse> in
                return client.synthesizeSpeech(request, callOptions: callOptions).response
        }
    }
    
    public func shutDown() {
        try? eventLoopGroup.syncShutdownGracefully()
    }

    // MARK: Private Methods
    
    private func prepareCallOptions(eventLoopGroup: EventLoopGroup) -> EventLoopFuture<CallOptions> {
        return getAuthToken(
            scopes: Constants.scopes,
            eventLoop: eventLoopGroup.next()
        ).map { authToken -> (CallOptions) in
            // Use CallOptions to send the auth token (necessary) and set a custom timeout (optional).
            let headers: HPACKHeaders = ["authorization": "Bearer \(authToken)"]
            let callOptions = CallOptions(customMetadata: headers, timeout: .seconds(rounding: 30))
            debugPrint("CALL OPTIONS\n\(callOptions)\n")
            return callOptions
        }
    }
    
    /// Get an auth token and return a future to provide its value.
    private var token: Token?
    private func getAuthToken(
        scopes: [String],
        eventLoop: EventLoop
    ) -> EventLoopFuture<String> {
        let promise = eventLoop.makePromise(of: String.self)
        guard let provider = DefaultTokenProvider(scopes: scopes) else {
            promise.fail(AuthError.noTokenProvider)
            return promise.futureResult
        }
        
        if let token = self.token,
            let accessToken = token.AccessToken,
            let expiresIn = token.ExpiresIn,
            let creationTime = token.CreationTime,
            creationTime.addingTimeInterval(TimeInterval(expiresIn)) > Date() {
            // TODO: Use refresh token
            promise.succeed(accessToken)
        } else {
            do {
                try provider.withToken { (token, error) in
                    if var token = token, let accessToken = token.AccessToken {
                        if token.CreationTime == nil {
                            token.CreationTime = Date()
                        }
                        self.token = token
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
        }
        return promise.futureResult
    }

    /// Create a client and return a future to provide its value.
    private func makeServiceClient(
        host: String,
        port: Int,
        eventLoopGroup: EventLoopGroup
    ) -> Google_Cloud_Texttospeech_V1beta1_TextToSpeechClient {
        let configuration = ClientConnection.Configuration(
            target: .hostAndPort(host, port),
            eventLoopGroup: eventLoopGroup,
            tls: .init()
        )
        let connection = ClientConnection(configuration: configuration)
        return .init(channel: connection)
    }
}
