import Foundation

struct Constants {
    static let url: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
}

@MainActor class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    // cached dataURLs which will be used to retrieve cuisine images
    @Published var recipeDataUrls: [String: URL] = [:]
    
    func decodeRecipes(data: Data) throws -> [Recipe] {
        // See Recipe.swift for why recipePayload exists
        let recipePayload = try JSONDecoder().decode(RecipePayload.self, from: data)
        let recipes = recipePayload.recipes
        // Left this print statement so the reviewer can see when requests are made
        print("DECODE done")
        return recipes
    }
    
    func fetchRecipes() async throws {
        guard let url = URL(string: Constants.url) else {
            return
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        recipes = try decodeRecipes(data: data)
        // Left this print statement so the reviewer can see when requests are made
        print("FETCH done")
    }
    
    func downloadImage(recipe: Recipe) async throws {
        
        guard self.recipeDataUrls.first(where: {$0.key == recipe.uuid}) == nil else {
            print("image cached for \(recipe.name), no download occured")
            return
        }
        
        // Download image
        let (data, _) = try await URLSession.shared.data(from: URL(string: recipe.photoUrlSmall!)!)
        // Cache image data url
        self.recipeDataUrls[recipe.uuid] = URL(string: "data:image/png;base64," + data.base64EncodedString())
        print("downloaded an image for \(recipe.name)")
    }
}
