import SwiftUI

struct Country: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var name: CountryName
    var capital: [String]?
    var flag: String
    var population: Int
    var translations: TranslationName
    var car: CarName
//    Didn't have time to resolve this so keeping them in comments
//    var demonyms: DemonymsName
}

struct CountryName: Codable {
    var common: String
    var official: String
}

struct TranslationName: Codable {
    var ara: Translation
}

struct Translation: Codable {
    var common: String
}

struct CarName: Codable {
    var side: String
}

//struct DemonymsName: Codable {
//    var eng: Demonyms
//}

//struct Demonyms: Codable {
//    var f: String
//    var m: String
//}

struct CountryDetailView: View {
    var country: Country
    
    var body: some View {
        Text("Country Flag: \(country.flag)")
            .padding()
        Text("Country Official Name: \(country.name.official)")
            .navigationTitle("Country Detail")
        Text("Country Common Name: \(country.name.common)")
            .padding()
        Text("Capital: \(country.capital?.first ?? "Unknown")")
            .padding()
        Text("Translations: \(country.translations.ara.common)")
            .padding()
        Text("Car-Side: \(country.car.side)")
//        Text("Demonyms: \(country.demonyms.eng.f)")
    }
}

struct CountriesView: View {
    @State var countries = [Country]()
    @State var searchText = ""
    
    func getAllCountries() async {
        do {
            let url = URL(string: "https://restcountries.com/v3.1/all")!
            let (data, _) = try await URLSession.shared.data(from: url)
            countries = try JSONDecoder().decode([Country].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a country...", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                
                List {
                    ForEach(countries.filter {
                        searchText.isEmpty || $0.name.common.lowercased().contains(searchText.lowercased())
                    }) { country in
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            VStack(alignment: .leading) {
                                Text("\(country.flag) • \(country.name.common)")
                            }
                        }
                    }
                }
                .task {
                    await getAllCountries()
                }
            }
            .navigationTitle("Countries")
        }
    }
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}

