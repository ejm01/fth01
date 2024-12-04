import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        VStack {
            Text("Pull down to refresh")
            List(recipeViewModel.recipes) { recipe in
                RecipeRowView(recipe: recipe)
                    .task {
                        try? await recipeViewModel.downloadImage(recipe: recipe)
                    }
                    .environmentObject(recipeViewModel)
            }
            .task {
                try? await recipeViewModel.fetchRecipes()
            }
            .refreshable {
                try? await recipeViewModel.fetchRecipes()
            }
        }
    }
}
