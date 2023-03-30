//
//  ContentProvider.swift
//  TopShelfExtension
//
//  Created by Fran Dioniz on 30/3/23.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        DispatchQueue.global().async {
            do {

                // Create a JSON decoder.
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .secondsSince1970

                // Load a simulated network response.
                guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
                    fatalError("Unable to load movies.json file.")
                }
                let data = try Data(contentsOf: url, options: [.alwaysMapped, .uncached])
                let response = try decoder.decode(MoviesResponse.self, from: data)

                let items = response.movies.map { $0.buildCarouselItem() }
                let content = TVTopShelfCarouselContent(style: .details, items: items)
                completionHandler(content)

            } catch {

                // Call the completion handler with `nil` if content cannot be loaded at this time.
                completionHandler(nil)
            }
        }
    }

}

extension Movie {

    func buildCarouselItem() -> TVTopShelfCarouselItem {
        let item = TVTopShelfCarouselItem(identifier: identifier)

        item.title = self.title
        item.summary = self.summary
        item.previewVideoURL = self.previewVideoURL
        item.setImageURL(self.imageURL(withScale: 1), for: .screenScale1x)
        item.setImageURL(self.imageURL(withScale: 2), for: .screenScale2x)

        item.playAction = .init(url: URL(string: "full-screen-top-shelf://movie/\(identifier)/play")!)
        item.displayAction = .init(url: URL(string: "full-screen-top-shelf://movie/\(identifier)")!)

        return item
    }
}

