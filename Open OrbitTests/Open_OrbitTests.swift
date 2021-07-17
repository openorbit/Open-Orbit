//
//  Open_OrbitTests.swift
//  Open OrbitTests
//
//  Created by Mattias Holm on 17/07/2021.
//

import XCTest
@testable import Open_Orbit

class Open_OrbitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testObjectLookup() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sim = Simulator()
        sim.addObject(name: "foo", object: SimObject(withName: "foo", andSimulator: sim))
        sim.addObject(name: "bar", object: SimObject(withName: "bar", andSimulator: sim))
        sim.addObject(name: "baz", object: SimObject(withName: "baz", andSimulator: sim))
        
        XCTAssertNotNil(sim.getObject("/foo"), "foo is a valid root object")
        XCTAssertNotNil(sim.getObject("/bar"), "foo is a valid root object")
        XCTAssertNotNil(sim.getObject("/baz"), "foo is a valid root object")
        XCTAssertNil(sim.getObject("/fooo"), "no object with that name")
        XCTAssertNil(sim.getObject("foo"), "non-absoulte path")
        
        let foo = sim.getObject("/foo")!
        let objA = SimObject(withName: "boo", andSimulator: sim)
        foo.addObject(objA)

        let objB = SimObject(withName: "baa", andSimulator: sim)
        objA.addObject(objB)
        
        XCTAssertNotNil(sim.getObject("/foo/boo"))
        XCTAssertNil(sim.getObject("/foo/booo"))
        
        XCTAssertTrue(objA === sim.getObject("/foo/boo"))
        
        XCTAssertNotNil(sim.getObject("/foo/boo/baa"))
        XCTAssertNil(sim.getObject("/foo/boo/baaa"))
        
        XCTAssertTrue(objB === sim.getObject("/foo/boo/baa"))
    }

//    func testPerformanceExample() throws {
        // This is an example of a performance test case.
//        self.measure {
            // Put the code you want to measure the time of here.
//        }
//    }
    func testInfo() throws {
        // This is an example of a performance test case.

        let sim = Simulator()
        
        let obj = SimObject(withName: "foo", andSimulator: sim)
        sim.addObject(name: "foo", object:obj)
        
        obj.info()
    }

}
