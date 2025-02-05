import Foundation

final class LoggerInterceptor: InterceptorType {
    typealias LogClosure = (String) -> Void
    private let logClosure: LogClosure
    private let dateProvider: DateProviderType

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "SGT")
        return formatter
    }()

    init(
        logClosure: @escaping LogClosure = { print($0) },
        dateProvider: DateProviderType = DateProvider()
    ) {
        self.logClosure = logClosure
        self.dateProvider = dateProvider
    }

    func intercept<T: TargetType>(target: T) async throws -> T {
        logClosure(buildTargetLogMessage(for: target))
        return target
    }

    func intercept<T: TargetType>(
        response: TargetResponse<T.DataType>,
        target: T
    ) async throws -> TargetResponse<T.DataType> {
        logClosure(buildResponseLogMessage(for: response, target: target))
        return response
    }

    func intercept<T: TargetType>(
        result: Result<T.DataType, Error>,
        target: T,
        retryClosure: (() async throws -> Result<T.DataType, Error>)?
    ) async -> Result<T.DataType, Error> {
        logClosure(buildResultLogMessage(for: result, target: target))
        return result
    }
}

private extension LoggerInterceptor {
    func getTargetName(from target: any TargetType) -> String {
        let date = dateFormatter.string(from: dateProvider.currentDate())
        let target = String(describing: type(of: target))
        return "- [DEBUG] [\(date)] [\(target)]:"
    }

    func buildTargetLogMessage<T: TargetType>(for target: T) -> String {
        var description = """
        \(getTargetName(from: target)) --- Target Debug ---
        --------> Method: \(target.method.rawValue.uppercased())
        """
        if let parameters = target.parameters {
            description += "\n--------> Parameters: \(parameters)"
        } else {
            description += "\n--------> Parameters: None"
        }
        if let request = try? target.createRequest() {
            description += "\n--------> Request: \(request)"
            if let headerFields = request.allHTTPHeaderFields {
                description += "\n--------> Headers: \(headerFields)"
            }
            if let data = request.httpBody,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                description += "\n--------> Body: \(json)"
            } else {
                description += "\n--------> Body: None"
            }
        }
        description += "\n---------------------------------------------------------------"
        return description
    }

    func buildResponseLogMessage<T: TargetType>(
        for response: TargetResponse<T.DataType>,
        target: T
    ) -> String {
        var message = """
        \(getTargetName(from: target)) --- Response Debug ---
        --------> StatusCode: \(response.statusCode)
        """
        if let data = response.data {
            message += "\n--------> Data: \(data)"
        } else {
            message += "\n--------> Data: None"
        }
        if let response = response.response {
            message += "\n--------> Response: \(response)"
        } else {
            message += "\n--------> Response: None"
        }
        message += "\n---------------------------------------------------------------"
        return message
    }

    func buildResultLogMessage<T: TargetType>(
        for result: Result<T.DataType, Error>,
        target: T
    ) -> String {
        var message = getTargetName(from: target)
        switch result {
        case .success:
            message += """
             --- Result Success Debug ---
            --------> Success
            ---------------------------------------------------------------
            """
        case .failure(let error):
            message += """
             --- Result Error Debug ---
            --------> Error: \(error.localizedDescription)
            ---------------------------------------------------------------
            """
        }
        return message
    }
}
