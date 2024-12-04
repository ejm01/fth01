import SwiftUI

struct RecipeRowView: View {
    var recipe: Recipe
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        HStack {
            // if a cached dataUrl exists for this recipe, use the data url to asynchronously retrieve its corresponding image
            if let dataUrl = recipeViewModel.recipeDataUrls.first(where: { $0.key == recipe.uuid })?.value {
                AsyncImage(url: dataUrl) { result in
                    result.image?
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                // otherwise show progress view
            } else {
                ProgressView()
            }
            Text(recipe.name)
            Spacer()
            Text(recipe.cuisine).multilineTextAlignment(.trailing)
        }
    }
}
