//
//  FavouritePlacesTests.swift
//  FavouritePlacesTests
//
//  Created by Sean Fowers on 26/4/2023.
//

import XCTest
@testable import FavouritePlaces

final class FavouritePlacesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLatStr() {
        let model = MapModel.shared
        model.latStr = "45"
        XCTAssert(model.latStr == "45.00000")
        model.latStr = "91"
        XCTAssert(model.latStr == "45.00000")
        model.latStr = "-12.123456"
        XCTAssert(model.latStr == "-12.12346")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
