import Foundation
import SwiftUI

// This is codable so that we can serialize the JSON into this type easily.
// Recipe is Identifiable so that it can be displayed in the ViewBuilder struct.
struct Recipe: Codable, Identifiable {
    // This id exists to comply with "Identifiable" protocol
    var id = UUID()
    
    var cuisine: String
    var name: String
    var photoUrlLarge: String? = nil
    var photoUrlSmall: String? = nil
    var uuid: String
    var sourceUrl: String? = nil
    var youtubeURL: String? = nil
    // Used to cache image data
    var dataImageURL: URL? = nil
    
    private enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeURL = "youtube_url"
    }
}

// This struct exists because the server response is a dictionary with one key called 'recipes'.
// The values is an array of Recipes.
// The one key needs to be coded so there isn't a type mismatch.
struct RecipePayload: Codable {
    var recipes: [Recipe]
}
