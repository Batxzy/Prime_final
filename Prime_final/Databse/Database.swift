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
            description: "When Puss in Boots discovers that his passion for adventure has taken its toll and he has burned through eight of his nine lives, he launches an epic journey to restore them by finding the mythical Last Wish.",
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
           description: "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island's animals and cares for an orphaned baby goose.",
            year: "2016",
            duration: "90 min",
            rating: 8.3,
            genres: ["Animation", "Adventure", "Family"],
            subgeneres: ["Fantasy", "Sci-Fi"]
        ),
        MovieData(
            id: 2,
            thumbnailHUrl: "evangelion1",
            thumbnailVUrl: "evangelion1_V",
            videoUrl: "",
            title: "EVANGELION: 1.11 YOU ARE (NOT) ALONE.",
            description: "Scarred by the Second Impact, the Fourth Angel attacks Tokyo III and humanity's fate is left in Special Government Agency NERV's hands. Young Shinji Ikari is forced to pilot EVA-01. He and EVA-00 pilot Rei Ayanami are tasked to fight, but EVA-01 is damaged by the Sixth Angel. Misato Katsuragi draws up a plan to focus all of Japan's electricity into EVA-01's positron cannon to defeat the Angel.",
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
            title: "EVANGELION: 2.22 YOU CAN (NOT) ADVANCE",
            description: "Mari Illustrious-Makinami pilots Provisional Unit-05 to defeat the excavated Third Angel. Asuka Langley-Shikinami and EVA-02 defeat the Seventh Angel. The Eighth Angel appears and attacks NERV HQ. EVA-03 is taken over by the Ninth Angel during testing and Shinji deploys to stop it, but learns Asuka is aboard. Gendoh switches EVA-01's controls over to the Dummy System and begins fighting EVA-03...",
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
            title: "EVANGELION: 3.33 YOU CAN (NOT) REDO.",
            description: "Shinji wakes after 14 years aboard the battleship AAA Wunder belonging to an anti-NERV organization founded by former NERV members. Shinji hears Rei's voice coming from EVA Mark.09, sent to rescue him, so he leaves Wunder and heads to NERV. Kaworu Nagisa shows Shinji the transformed land. He learns that saving Rei triggered the Near Third Impact that caused the catastrophic damage to Earth.",
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
            videoUrl: "evangelion4",
            title: "EVANGELION: 3.0+1.01 THRICE UPON A TIME",
            description: "The fourth and final installment of the Rebuild of Evangelion. Misato and her anti-Nerv group Wille arrive in Paris, a city now red from core-ization. Crew from the flagship Wunder land on a containment tower.",
            year: "2021",
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
            description: "Thirty years after the events of the first film, a new blade runner, LAPD Officer K (Ryan Gosling), unearths a long-buried secret that has the potential to plunge what's left of society into chaos. K's discovery leads him on a quest to find Rick Deckard (Harrison Ford), a former LAPD blade runner who has been missing for 30 years.",
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
            description: "Teenage Gru joins forces with Kevin, Stuart and Bob to defeat the Vicious 6 in an adventure featuring spectacular action and the franchise's signature subversive humor.",
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
            description: "A mean lord exiles fairytale creatures to the swamp of a grumpy ogre, who must go on a quest and rescue a princess for the lord in order to get his land back.",
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
            description: "The story of Jordan Belfort, from his rise to a wealthy stock-broker lifestyle to his demise involving crime, corruption and the federal government.",
            year: "2013",
            duration: "180 min",
            rating:8.2 ,
            genres: ["Biography", "Comedy", "Crime"],
            subgeneres: ["Drama"]
        ),
        MovieData(
            id: 10,
            thumbnailHUrl: "Scarface",
            thumbnailVUrl: "scarface_V",
            videoUrl: "",
            title: "Scarface",
            description: "Al Pacino gives an unforgettable performance as one of the most ruthless gangsters of all time. Directed by Brian De Palma, Scarface lays bare the sordid power of the American drug scene.",
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
            title: "Dr. Seuss' How the Grinch Stole Christmas",
            description: "Jim Carrey brings Dr. Seuss' holiday-hating heel to gloriously sinister life in this effects-filled adaptation of the classic story.",
            year: "2000",
            duration: "104 min",
            rating: 6.3,
            genres: ["Fantasy", "Comedy", "Family"],
            subgeneres: ["Holiday family"]
        ),
        MovieData(
            id: 12,
            thumbnailHUrl: "inception",
            thumbnailVUrl: "Inception_V",
            videoUrl: "",
            title: "Inception",
            description: "Dom Cobb (Leonardo DiCaprio) is a slick thief whose mastery makes him an invaluable asset in the practice of corporate espionage. To help pull one final job-an “inception” or meme-planting in a billionaire tycoon (Cillian Murphy)-Cobb adds young architect Ariadne (Elliot Page) to a team of tough-guy brainiacs.",
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
            description: "Filmmaker Christopher Nolan takes us on another epic science fiction journey. Matthew McConaughey and Anne Hathaway join an acclaimed crew as members of an interspace exploratory team that overcome the impossible.",
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
            description: "The Dark Knight reunites Christian Bale with director Christopher Nolan and takes Batman across the world in his quest to fight a growing criminal threat known as The Joker .",
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
            description: "Witness the untold origin story of Orion Pax (young Optimus Prime) and D-16 (young Megatron). Once brothers-in-arms, see how they turn into sworn enemies and forever change the fate of Cybertron.",
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
