import XCTest
@testable import FetchTakeHome

final class FetchTakeHomeTests: XCTestCase {
    private var recipeViewModel: RecipeViewModel!

    @MainActor override func setUpWithError() throws {
        recipeViewModel = RecipeViewModel()
    }

    override func tearDownWithError() throws {
        recipeViewModel = nil
    }
    
    func testDecode() async throws {
        let json =
        """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                        ]
        }
        """
        let data = Data(json.utf8)
        
        do {
            let decoded = try await self.recipeViewModel.decodeRecipes(data: data)
            XCTAssertEqual(decoded[0].cuisine, "Malaysian")
            XCTAssertEqual(decoded[0].name, "Apam Balik")
            XCTAssertEqual(decoded[0].photoUrlSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodeFails() async throws {
        let jsonShouldFail =
        """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                },
                        ]
        }
        """
        let data = Data(jsonShouldFail.utf8)
        
        let ex = expectation(description: "throws an error")
        do {
            _ = try await self.recipeViewModel.decodeRecipes(data: data)
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
            ex.fulfill()
        }
        await fulfillment(of: [ex], timeout: 1)
    }
    
    // !!!: Probably shouldn't make network requests in a unit test.
    // It would be better to spoof it, but this is a small take home.
    func testFetchRecipes() async throws {
        let bool = await self.recipeViewModel.recipes.isEmpty
        XCTAssert(bool)
        try await recipeViewModel.fetchRecipes()
        let recipes = await self.recipeViewModel.recipes
        XCTAssertNotNil(recipes)
    }
    
    func testCache() async throws {
        try await self.recipeViewModel.fetchRecipes()
        let recipe = await recipeViewModel.recipes.first!
        XCTAssert(recipe.name == "Apam Balik")
        let bool = await self.recipeViewModel.recipeDataUrls.isEmpty
        // assert nothing cached
        XCTAssert(bool)
        
        try await recipeViewModel.downloadImage(recipe: recipe)
        let dataUrl = await self.recipeViewModel.recipeDataUrls.first!.value
        XCTAssertNotNil(dataUrl)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
