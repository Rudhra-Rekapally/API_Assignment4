

import SwiftUI

struct Country: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var name: CountryName
    var capital: [String]?
    var flag: String
    var population: Int
    

}


struct CountryName: Codable {
    var common: String
    var official: String
}

// This is the variable for country detailed view
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
        
        
    }
}

struct CountriesView: View {
    @State var countries =  [Country]()
    
    func getAllCountries() async -> () {
        do {
            let url = URL(string: "https://restcountries.com/v3.1/all")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            countries = try JSONDecoder().decode([Country].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                NavigationLink(destination: CountryDetailView(country: country)) { // use navigation link
                    VStack(alignment: .leading) {
                        Text("\(country.flag) • \(country.name.common)")
                      
                        
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

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}

