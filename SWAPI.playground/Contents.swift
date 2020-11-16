import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Films: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static let peopleComponent = "people"
    static let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent(peopleComponent).appendingPathComponent("\(id)")
        print("final ------>" ,finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _ , error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
                
            }
            guard let returnData = data else { return completion(nil) }
            print(returnData)
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: returnData)
                return completion(person)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Films?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil) }
            
            do {
                let film = try JSONDecoder().decode(Films.self, from: data)
                return completion(film)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        } .resume()
    }
    
    func fetchFilm(url: URL) {
        SwapiService.fetchFilm(url: url) { film in
            if let film = film {
                print(film)
                print("url =========================>", url)
            }
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
      print(person)
    for film in person.films {
        SwapiService.fetchFilm(url: film) { film in
           if let film = film {
                print(film)
            }
        }
    }
  }
}

