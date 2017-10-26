import XCTest
@testable import TeslaAPI

extension TeslaAPITests {
    func testOpenChargePort() {
        let waitExpectation = expectation(description: "Open charge port")

        OpenChargePortRequest(
            accessToken: TeslaAPITests.accessToken,
            vehicleIdentifier: TeslaAPITests.vehicleIdentifier).execute { result in
                XCTAssert(Thread.isMainThread)
                switch result {
                case .success(_):
                    waitExpectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
}