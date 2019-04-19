//
//  CountryDetail.swift
//  WebService
//
//  Created by Gaurang.Lathiya on 19/04/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation

public struct CountryDetail: Codable {
    
    public struct Translation: Codable {
        let de: String
        let es: String
        let fr: String
        let it: String
        let ja: String
        
//        enum CodingKeys: String, CodingKey {
//            case de
//            case es
//            case fr
//            case it
//            case ja
//        }
//        
        public init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)

            self.de = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.de) ?? ""
            self.es = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.es) ?? ""
            self.fr = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.fr) ?? ""
            self.it = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.it) ?? ""
            self.ja = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.ja) ?? ""
        }
    }
    
//    let alpha2Code: String
//    let alpha3Code: String
//    let altSpellings: [String]?
//    let area: Double?
//    let borders: [String]?
//    let callingCodes: [String]?
//    let capital: String
//    let currencies: [String]
//    let demonym: String
//    let gini: Double?
//    let languages: [String]?
//    let latlng: [Double]?
//    let name: String
//    let nativeName: String
//    let numericCode: String?
//    let population: Int
//    let region: String
//    let relevance: String?
//    let subregion: String
//    let timezones: [String]
//    let topLevelDomain: [String]
//    let translations: Translation
    
    let alpha2Code: String
    let alpha3Code: String
    let altSpellings: [String]
    let area: Double
    let borders: [String]
    let callingCodes: [String]
    let capital: String
    let currencies: [String]
    let demonym: String
    let gini: Double
    let languages: [String]
    let latlng: [Double]
    let name: String
    let nativeName: String
    let numericCode: String
    let population: Int
    let region: String
    let relevance: String
    let subregion: String
    let timezones: [String]
    let topLevelDomain: [String]
    let translations: Translation
    
    public init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)

        self.alpha2Code = try valueContainer.decode(String.self, forKey: CodingKeys.alpha2Code)
        self.alpha3Code = try valueContainer.decode(String.self, forKey: CodingKeys.alpha3Code)

        self.altSpellings = try valueContainer.decodeIfPresent([String].self, forKey: CodingKeys.altSpellings) ?? []
        self.area = try valueContainer.decodeIfPresent(Double.self, forKey: CodingKeys.area) ?? 0.0
        self.borders = try valueContainer.decodeIfPresent([String].self, forKey: CodingKeys.borders) ?? []
        self.callingCodes = try valueContainer.decodeIfPresent([String].self, forKey: CodingKeys.callingCodes) ?? []

        self.capital = try valueContainer.decode(String.self, forKey: CodingKeys.capital)
        self.currencies = try valueContainer.decode([String].self, forKey: CodingKeys.currencies)
        self.demonym = try valueContainer.decode(String.self, forKey: CodingKeys.demonym)

        self.gini = try valueContainer.decodeIfPresent(Double.self, forKey: CodingKeys.gini) ?? 0.0
        self.languages = try valueContainer.decodeIfPresent([String].self, forKey: CodingKeys.languages) ?? []
        self.latlng = try valueContainer.decodeIfPresent([Double].self, forKey: CodingKeys.latlng) ?? []

        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.nativeName = try valueContainer.decode(String.self, forKey: CodingKeys.nativeName)

        self.numericCode = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.numericCode) ?? ""

        self.population = try valueContainer.decode(Int.self, forKey: CodingKeys.population)
        self.region = try valueContainer.decode(String.self, forKey: CodingKeys.region)

        self.relevance = try valueContainer.decodeIfPresent(String.self, forKey: CodingKeys.relevance) ?? ""

        self.subregion = try valueContainer.decode(String.self, forKey: CodingKeys.subregion)
        self.timezones = try valueContainer.decode([String].self, forKey: CodingKeys.timezones)
        self.topLevelDomain = try valueContainer.decode([String].self, forKey: CodingKeys.topLevelDomain)
        self.translations = try valueContainer.decode(CountryDetail.Translation.self, forKey: CodingKeys.translations)
    }
}

