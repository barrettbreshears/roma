import Foundation
import ReactiveSwift

public struct ReactiveSSE {
    public let producer: SignalProducer<SSEvent, SSError>

    public init(urlRequest req: URLRequest, maxBuffer: Int? = nil) {
        self.producer = .init { observer, lifetime in
            var req = req
            req.cachePolicy = .reloadIgnoringCacheData
            req.timeoutInterval = 365 * 24 * 60 * 60

            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60
            configuration.timeoutIntervalForResource = 60 * 60
            if #available(iOS 11.0, OSX 10.13, *) {
                configuration.waitsForConnectivity = true
            }

            let queue = OperationQueue()
            var underlyingQueue: DispatchQueue? = DispatchQueue(label: "ReactiveSSE", qos: .utility)
            queue.underlyingQueue = underlyingQueue
            lifetime.observeEnded {underlyingQueue = nil}

            // use session delegate to process data stream
            let delegate = SessionDataPipe()
            lifetime += delegate.pipe.output
                .serverSentEvents()
                .observe(observer.send)

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: queue)

            let task = session.dataTask(with: req)
            lifetime.observeEnded(session.invalidateAndCancel)
            task.resume()
        }
    }
}




