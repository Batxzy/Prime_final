import SwiftUI

struct ProfilePictureCategory identifiable {
    let id = UUID()
    let name: String
    let images: [String]
}

let profilePictureCategories = [
    ProfilePictureCategory(name: "Furry", images: ["furry1", "furry2", "furry3"]),
    ProfilePictureCategory(name: "Fallout", images: ["fallout1", "fallout2", "fallout3"]),
    ProfilePictureCategory(name: "Anime", images: ["anime1", "anime2", "anime3"])
]