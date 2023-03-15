import SwiftUI
import PocketCastsServer

class SearchResultsModel: ObservableObject {
    private let podcastSearch = PodcastSearchTask()
    private let episodeSearch = EpisodeSearchTask()

    @Published var isSearchingForPodcasts = false
    @Published var isSearchingForEpisodes = false

    @Published var podcasts: [PodcastSearchResult] = []
    @Published var episodes: [EpisodeSearchResult] = []

    func clearSearch() {
        podcasts = []
        episodes = []
    }

    @MainActor
    func search(term: String) {
        clearSearch()

        Task {
            isSearchingForPodcasts = true
            let results = try? await podcastSearch.search(term: term)
            isSearchingForPodcasts = false
            podcasts = results ?? []
        }

        Task {
            isSearchingForEpisodes = true
            let results = try? await episodeSearch.search(term: term)
            isSearchingForEpisodes = false
            episodes = results ?? []
        }
    }
}