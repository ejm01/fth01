https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html
### Steps to Run the App
Set target simulator to an iPhone.
Run and Build

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I spent most of my time on image caching. I originally started by reading about the `AsyncImage` view and whether that caches by default using URLSession.
Opinions from the last year seemed split on the matter. There appeared to be excess network calls, I found using the network utility in Xcode.
Regardless, the take home prompt says not to rely on any URLSession configurations anyways.

I didn't spend too much on the UI or additional presentation because I wanted to be near the recommended time spent. 
Also the bare bones UI is in the spirit of shipping an MVP :)

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Towards the longer end of recommended time spent range. 90% of the code I wrote in an hour. The remainder was spent on tinkering with the caching, 
writing tests, and ironing out the bugs that testing surface.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I originally wanted my RecipeRow to be even shorter, so I could try to demonstrate an MVVM where the views were extremely bare bones.
I begrudgingly added an environment object passed to it and an if/else statement in the view builder to get the caching to work correctly.
If I wasn't time boxing this project then I would keep working on a better way.

### Weakest Part of the Project: What do you think is the weakest part of your project?
There were a couple quick workarounds I threw in that might raise an eyebrow, like how I needed to decode the top layer of the JSON responses.
I also set out to cache the images inside of the same recipe data structure that holds the other information, but due to the fetching loop, I needed to 
create a separate dictionary. I feel like there could've been a more centralized way to do that. I'm going with the current version because of time
considerations and it's a working MVP (as far as I can tell).


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

![til](./cache-example.gif)