//
//  SwiftUIView.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI  // Import SwiftUI

public struct MovieData: Identifiable {  // Fix: Added colon after MovieData
    public let id: Int
    public let thumbnailHUrl: String
    public let thumbnailVUrl: String
    public let videoUrl: String
    
    public let title: String
    public let description: String
    public let year: String
    public let duration: String
    public let rating: Double
    public let genres: [String]
    public let subgeneres: [String]
}

public class MovieDatabase: ObservableObject {  // Make the class public
    @Published public var movies: [MovieData] = [
        MovieData(
            id: 0,
            thumbnailHUrl: "puss",
            thumbnailVUrl: "Puss_V",
            videoUrl: "",
            title: "Puss in Boots",
            description: "When Puss in Boots discovers that his passion for adventure has taken its toll and he has burned through eight of his nine lives, he launches an epic journey to restore them...",
            year: "2022",
            duration: "102 min",
            rating: 7.8,
            genres: ["Animation", "Adventure", "Comedy"],
            subgeneres: ["Family", "Fantasy", "Action"]
        ),
        MovieData(
            id: 1,
            thumbnailHUrl: "wild",
            thumbnailVUrl: "wild_V",
            videoUrl: "",
            title: "Wild Robot",
            description: "A story about a robot who finds herself on an island and learns to live among the animals...",
            year: "2016",
            duration: "90 min",
            rating: 8.3,
            genres: ["Animation", "Adventure", "Family"],
            subgeneres: ["Fantasy", "Sci-Fi"]
        ),
        MovieData(
            id: 2,
            thumbnailHUrl: "evangelion1",
            thumbnailVUrl: "evangelion2_V",
            videoUrl: "",
            title: "Evangelion 1.0",
            description: "The first rebuild of the classic anime series Neon Genesis Evangelion...",
            year: "2007",
            duration: "98 min",
            rating: 7.5,
            genres: ["Animation", "Action", "Drama"],
            subgeneres: ["Mecha", "Sci-Fi"]
        ),
        MovieData(
            id: 3,
            thumbnailHUrl: "evangelion2",
            thumbnailVUrl: "evangelion2_V",
            videoUrl: "",
            title: "Evangelion 2.0",
            description: "The second rebuild of the classic anime series Neon Genesis Evangelion...",
            year: "2009",
            duration: "112 min",
            rating: 7.9,
            genres: ["Animation", "Action", "Drama"],
            subgeneres: ["Mecha", "Sci-Fi"]
        ),
        MovieData(
            id: 4,
            thumbnailHUrl: "evangelion3",
            thumbnailVUrl: "evangelion3_V",
            videoUrl: "",
            title: "Evangelion 3.0",
            description: "The third rebuild of the classic anime series Neon Genesis Evangelion...",
            year: "2012",
            duration: "96 min",
            rating: 6.9,
            genres: ["Animation", "Action", "Drama"],
            subgeneres: ["Mecha", "Sci-Fi"]
        ),
        MovieData(
            id: 5,
            thumbnailHUrl: "evangelion4",
            thumbnailVUrl: "evangelion4_V",
            videoUrl: "",
            title: "The End of Evangelion",
            description: "The conclusion of the original Neon Genesis Evangelion series...",
            year: "1997",
            duration: "87 min",
            rating: 8.0,
            genres: ["Animation", "Action", "Drama"],
            subgeneres: ["Mecha", "Sci-Fi"]
        ),
        MovieData(
            id: 6,
            thumbnailHUrl: "blade_runner",
            thumbnailVUrl: "blade_runner_V",
            videoUrl: "",
            title: "Blade Runner 2049",
            description: "A new blade runner unearths a long-buried secret that has the potential to plunge what's left of society into chaos...",
            year: "2017",
            duration: "163 min",
            rating: 8.0,
            genres: ["Sci-Fi", "Thriller"],
            subgeneres: ["Action", "Drama"]
        ),
        MovieData(
            id: 7,
            thumbnailHUrl: "minions",
            thumbnailVUrl: "minions_V",
            videoUrl: "",
            title: "Minions: The Rise of Gru",
            description: "The untold story of one twelve-year-old's dream to become the world's greatest supervillain...",
            year: "2022",
            duration: "87 min",
            rating: 6.5,
            genres: ["Animation", "Comedy", "Family"],
            subgeneres: ["Adventure", "Fantasy"]
        ),
        MovieData(
            id: 8,
            thumbnailHUrl: "shrek",
            thumbnailVUrl: "shrek_V",
            videoUrl: "",
            title: "Shrek",
            description: "An ogre's life is turned upside down when he embarks on a journey to rescue a princess...",
            year: "2001",
            duration: "90 min",
            rating: 7.9,
            genres: ["Animation", "Adventure", "Comedy"],
            subgeneres: ["Fantasy", "Family"]
        ),
        MovieData(
            id: 9,
            thumbnailHUrl: "wolf_of_wallstreet",
            thumbnailVUrl: "wolf_of_wallstreet_V",
            videoUrl: "",
            title: "The Wolf of Wall Street",
            description: "The story of a New York stockbroker who runs a firm that engages in securities fraud and corruption...",
            year: "2013",
            duration: "180 min",
            rating:8.2 ,
            genres: ["Biography", "Comedy", "Crime"],
            subgeneres: ["Drama"]
        ),
        MovieData(
            id: 10,
            thumbnailHUrl: "scarface",
            thumbnailVUrl: "scarface_V",
            videoUrl: "",
            title: "Scarface",
            description: "In 1980 Miami, a determined Cuban immigrant takes over a drug cartel and succumbs to greed...",
            year: "1983",
            duration: "170 min",
            rating: 8.3,
            genres: ["Crime", "Drama"],
            subgeneres: ["Thriller"]
        ),
        MovieData(
            id: 11,
            thumbnailHUrl: "grinch",
            thumbnailVUrl: "grinch_V",
            videoUrl: "",
            title: "The Grinch",
            description: "A grumpy Grinch plots to ruin Christmas for the residents of Whoville...",
            year: "2000",
            duration: "104 min",
            rating: 6.3,
            genres: ["Animation", "Comedy", "Family"],
            subgeneres: ["Fantasy"]
        ),
        MovieData(
            id: 12,
            thumbnailHUrl: "inception",
            thumbnailVUrl: "Inception_V",
            videoUrl: "",
            title: "Inception",
            description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
            year: "2010",
            duration: "148 min",
            rating: 8.8,
            genres: ["Action", "Adventure", "Sci-Fi"],
            subgeneres: ["Thriller", "Mystery"]
        ),
        MovieData(
            id: 13,
            thumbnailHUrl: "interstellar",
            thumbnailVUrl: "Interstellar_V",
            videoUrl: "",
            title: "Interstellar",
            description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
            year: "2014",
            duration: "169 min",
            rating: 8.7,
            genres: ["Adventure", "Drama", "Sci-Fi"],
            subgeneres: ["Thriller", "Mystery"]
        ),
        MovieData(
            id: 14,
            thumbnailHUrl: "dark_Knight",
            thumbnailVUrl: "dark_Knight_V",
            videoUrl: "",
            title: "The Dark Knight",
            description: "When a menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman, James Gordon and Harvey Dent must work together to put an end to the madness.",
            year: "2008",
            duration: "162 min",
            rating: 9.0,
            genres: ["Action", "Drama", "Superhero"],
            subgeneres: ["Thriller", "Crime"]
        ),
        MovieData(
            id: 15,
            thumbnailHUrl: "transformers",
            thumbnailVUrl: "Transformers_V",
            videoUrl: "",
            title: "Transformers One",
            description: "The untold origin story of Optimus Prime and Megatron, better known as sworn enemies, but who once were friends bonded like brothers who changed the fate of Cybertron forever.",
            year: "2024",
            duration: "90",
            rating: 7.7,
            genres: ["Animation", "Action", "Adventure"],
            subgeneres: ["Sci-Fi", "Fantasy"]
        )
    ]
    
    // Singleton instance to access the data globally
    public static let shared = MovieDatabase()
}
