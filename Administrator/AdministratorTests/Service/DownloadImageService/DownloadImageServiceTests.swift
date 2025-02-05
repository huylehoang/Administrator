@testable import Administrator
import XCTest
import UIKit

final class DownloadImageServiceTests: XCTestCase {
    private var mockImageCache: DownloadImageService.ImageCache!
    private var mockSession: MockSession!
    private var mockSessionProvider: MockSessionProvider!
    private var sut: DownloadImageService!

    override func setUp() {
       super.setUp()
        mockImageCache = DownloadImageService.ImageCache()
        mockSession = MockSession()
        mockSessionProvider = MockSessionProvider(mockSession: mockSession)
        sut = DownloadImageService.shared
        sut.set(imageCache: mockImageCache)
        sut.set(sessionProvider: mockSessionProvider)
    }

    override func tearDown() {
        mockImageCache = nil
        mockSession = nil
        mockSessionProvider = nil
        sut = nil
        super.tearDown()
    }

    func testDownloadImage_CachedImage_ReturnsSuccess() async {
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage()
        mockImageCache.setObject(image, forKey: url.absoluteString)
        let result = await sut.downloadImage(from: url)
        switch result {
        case .success(let cachedImage):
            XCTAssertEqual(cachedImage, image)
        case .failure:
            XCTFail("Expected success but got failure.")
        }
    }

    func testDownloadImage_ValidResponse_ReturnsSuccess() async {
        let url = URL(string: "https://example.com/image.png")!
        let expectedData = UIImage(systemName: "star")!.pngData()!
        let expecedResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        mockSession.response = (expectedData, expecedResponse)
        let result = await sut.downloadImage(from: url)
        switch result {
        case .success(let image):
            XCTAssertNotNil(image)
        case .failure:
            XCTFail("Expected success but got failure.")
        }
    }

    func testDownloadImage_InvalidResponse_ReturnsFailure() async {
        let url = URL(string: "https://example.com/image.png")!
        let expectedData = UIImage(systemName: "star")!.pngData()!
        let expecedResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        mockSession.response = (expectedData, expecedResponse)
        let result = await sut.downloadImage(from: url)
        switch result {
        case .success:
            XCTFail("Expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error as? DownloadImageError, .downloadFailed)
        }
    }

    func testDownloadImage_NetworkError_ReturnsFailure() async {
        let url = URL(string: "https://example.com/image.png")!
        mockSession.error = DownloadImageError.downloadFailed
        let result = await sut.downloadImage(from: url)
        switch result {
        case .success:
            XCTFail("Expected failure but got success.")
        case .failure(let error):
            XCTAssertEqual(error as? DownloadImageError, .downloadFailed)
        }
    }

    func testClearCache() async {
        let url = URL(string: "https://example.com/image.png")!
        let mockImage = UIImage(systemName: "star")!
        mockImageCache.setObject(mockImage, forKey: url.absoluteString)
        sut.clearCache()
        XCTAssertNil(mockImageCache.object(forKey: url.absoluteString))
    }
}
