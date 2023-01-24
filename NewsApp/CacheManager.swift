

import Foundation

class CacheManager {
    static var imageDictionary = [String : Data]()
    static func saveData(_ url: String, _ imageData: Data) {
        imageDictionary[url] = imageData
    }
    static func retrieveData(_ url: String) -> Data? {
        
        // Returns image data or nil if that url does not exist in the dictionary
        return imageDictionary[url]
        
    }
}
