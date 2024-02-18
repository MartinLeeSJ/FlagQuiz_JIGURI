//
//  FQCountryDetailTest.swift
//  FlagQuizSwiftUITests
//
//  Created by Martin on 2/12/24.
//

import XCTest
@testable import FlagQuizSwiftUI

final class FQCountryDetailTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test국가디테일좌표정보가예상한대로나오는지() throws {
//    coordinates: [100.333333, 33.3333333],
        let coordinateString: String = CountryDetailInfo.informativeText(.coordinates)(from: .mock)
        XCTAssertNotEqual("100.333333, 33.3333333", coordinateString)
        XCTAssertEqual("100.33, 33.33", coordinateString)
    }


}
