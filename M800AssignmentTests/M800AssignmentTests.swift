//
//  M800AssignmentTests.swift
//  M800AssignmentTests
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import XCTest
@testable import M800Assignment

class M800AssignmentTests: XCTestCase {

    let termString = "張雨生 我的未來不是夢"
    
    fileprivate func doTest(_ valueOfResultsItem: [[String : AnyObject]]) {
        XCTAssertTrue(valueOfResultsItem.count == 1)
        
        for aSong in valueOfResultsItem {
            XCTAssertEqual(aSong["artistName"] as! String, "張雨生")
            XCTAssertEqual(aSong["trackName"] as! String, "我的未來不是夢")
        }
    }
    
    func testSearchAPI() {
        do {
            let responseData = try Data(contentsOf: ITunesSearchAPIHelper.url(queryItems: ITunesSearchAPIHelper.queryItems(term: termString)))
            let responseJSONObject = try JSONSerialization.jsonObject(
                with: responseData,
                options: .allowFragments) as! Dictionary<String, AnyObject>
            for item in responseJSONObject {
                if item.key == "results" {
                    let valueOfResultsItem = item.value as! Array<Dictionary<String, AnyObject>>
                    doTest(valueOfResultsItem)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}
