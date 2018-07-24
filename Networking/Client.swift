// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import Foundation
import Alamofire
import RxSwift
import RxCocoa


protocol ClientProtocol {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

final class Client: ClientProtocol {
    private let manager: Alamofire.SessionManager
    private let baseURL = URL(string: "https://startpick.feizaotai.com")!
    private let queue = DispatchQueue(label: "SoapVideo_requestQueue")
    private let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("pig.png")
        
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }

    init(accessToken: String) {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Authorization"] = "Bearer \(accessToken)"

        let configuration = URLSessionConfiguration.default

        // Add `Auth` header to the default HTTP headers set by `Alamofire`
        configuration.httpAdditionalHeaders = defaultHeaders

        self.manager = Alamofire.SessionManager(configuration: configuration)
        self.manager.retrier = OAuth2Retrier()
    }

    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create { observer in
            let request = self.manager.request(
                self.url(path: endpoint.path),
                method: httpMethod(from: endpoint.method),
                parameters: endpoint.parameters
            )
            request
                .validate()
                .responseData(queue: self.queue) { [weak self] response in
                    guard let `self` = self else { return }
                    if response.response?.statusCode != 200 {
                        self.catchError(response: response)
                    }
                    let result = response.result.flatMap(endpoint.decode)
                    switch result {
                    case let .success(val): observer(.success(val))
                    case let .failure(err): observer(.error(err))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func download(_ url: URLConvertible, progressVariable: BehaviorRelay<Double>?) -> Single<Data> {
        return Single<Data>.create { observer in
            let download = self.manager.download(url, to: self.destination)
            download
                .validate()
                .downloadProgress(closure: { (progress) in
                    if let progressVariable = progressVariable {
                        progressVariable.accept(progress.fractionCompleted)
                    }
                })
                .responseData(queue: DispatchQueue.main) { (downloadResponse) in
                    if downloadResponse.response?.statusCode != 200 {
                        debugPrint(downloadResponse.debugDescription)
                    }
                    let result = downloadResponse.result
                    switch result {
                    case let .success(val): observer(.success(val))
                    case let .failure(err): observer(.error(err))
                    }
                }
            return Disposables.create {
                download.cancel()
            }
        }
    }
    
    func upload<Response>(_ endpoint: Endpoint<Response>, progressVariable: BehaviorRelay<Double>?) -> Single<Response> {
        return Single<Response>.create { observer in
            var uploadRequest: UploadRequest?
            self.manager
                .upload(multipartFormData: { (multipartFormData) in
                    if let parameters = endpoint.parameters {
                        for (key, val) in parameters {
                            guard val is Data else { continue }
                            multipartFormData.append(val as! Data, withName: key)
                        }
                    }
                },
                to: self.url(path: endpoint.path),
                encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .success(let request, _, _):
                        uploadRequest = request
                            .uploadProgress(closure: { (progress) in
                                if let progressVariable = progressVariable {
                                    progressVariable.accept(progress.fractionCompleted)
                                }
                            })
                            .responseData(queue: self.queue, completionHandler: { [weak self] (response) in
                                guard let `self` = self else { return }
                                if response.response?.statusCode != 200 {
                                    self.catchError(response: response)
                                }
                                
                                let result = response.result.flatMap(endpoint.decode)
                                switch result {
                                case let .success(val): observer(.success(val))
                                case let .failure(err): observer(.error(err))
                                }
                            })
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                })
            
            return Disposables.create {
                uploadRequest?.cancel()
            }
        }
    }
    
    private func catchError(response: DataResponse<Data>) {
        debugPrint(response.debugDescription)
    }

    private func url(path: Path) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}

private func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
    switch method {
    case .get: return .get
    case .post: return .post
    case .put: return .put
    case .patch: return .patch
    case .delete: return .delete
    }
}


private class OAuth2Retrier: Alamofire.RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if (error as? AFError)?.responseCode == 401 {
            // TODO: implement your Auth2 refresh flow
            // See https://github.com/Alamofire/Alamofire#adapting-and-retrying-requests
        }
        completion(false, 0)
    }
}
