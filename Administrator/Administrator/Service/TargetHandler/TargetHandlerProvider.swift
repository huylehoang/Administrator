import Foundation

/// Protocol defining a provider for a chain of responsibility handler.
/// This abstraction allows flexibility in providing the root handler (`handler`)
/// for processing `TargetType` requests.
protocol TargetHandlerProviderType {
    var handler: TargetHandlerType { get }
}

/// A concrete implementation of `TargetHandlerProviderType`
/// that manages a chain of `TargetHandlerType` objects.
/// - Allows dynamic updates to the handler chain.
/// - Ensures the chain starts with custom handlers and ends with a default fallback handler.
final class TargetHandlerProvider: TargetHandlerProviderType {
    /// The default fallback handler.
    /// - By default, returns a `StandardTargetHandler` for basic request processing.
    static var defaultHandler: TargetHandlerType {
        StandardTargetHandler()
    }

    /// The default list of handlers.
    /// - Defaults to an empty array, meaning no additional handlers are used initially beyond the
    ///  default handler.
    /// - The default handler can be any `TargetHandlerType` implementation, such as an
    ///  `UploadHandler` for file uploads or a `DownloadHandler` for handling large file downloads.
    static var defaultHandlers: [TargetHandlerType] {
        []
    }

    private var defaultHandler: TargetHandlerType
    private var handlers: [TargetHandlerType]
    private(set) var handler: TargetHandlerType

    init(
        defaultHandler: TargetHandlerType = TargetHandlerProvider.defaultHandler,
        handlers: [TargetHandlerType] = TargetHandlerProvider.defaultHandlers
    ) {
        self.defaultHandler = defaultHandler
        self.handlers = handlers.uniqueAndIngnore(defaultHandler)
        handler = defaultHandler
        updateHandler()
    }

    func updateHandlers(_ handlers: [TargetHandlerType]) {
        self.handlers = handlers.uniqueAndIngnore(defaultHandler)
        updateHandler()
    }

    func updateDefaultdHandler(_ handler: TargetHandlerType) {
        defaultHandler = handler
        handlers = handlers.ignore(handler)
        updateHandler()
    }

    func addHandler(_ handler: TargetHandlerType) {
        if handler !== defaultHandler {
            handlers.append(handler)
            updateHandler()
        }
    }
}

private extension TargetHandlerProvider {
    func updateHandler() {
        guard !handlers.isEmpty else {
            self.handler = defaultHandler
            return
        }
        // Start the chain with the first handler in the handlers array
        var currentHandler = handlers[0]
        // Link each handler in the array
        for handler in handlers.dropFirst() {
            currentHandler = currentHandler.setNext(handler)
        }
        // Set the standardHandler as the last handler
        currentHandler.setNext(defaultHandler)
        // The head of the chain is now the first handler in the handlers array
        self.handler = handlers[0]
    }
}

private extension [TargetHandlerType] {
    func ignore(_ handler: TargetHandlerType) -> [TargetHandlerType] {
        filter { $0 !== handler }
    }

    func uniqueAndIngnore(_ handler: TargetHandlerType) -> [TargetHandlerType] {
        var seen: [ObjectIdentifier: TargetHandlerType] = [:]
        return filter {
            let id = ObjectIdentifier($0)
            if seen[id] == nil && $0 !== handler {
                seen[id] = $0
                return true
            }
            return false
        }
    }
}
