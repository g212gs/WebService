//
//  CountryInfo.swift
//
//  Created by Gaurang Lathiya on 30/05/18
//  Copyright (c) Gaurang Lathiya. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CountryInfo: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let alpha2Code = "alpha2Code"
    static let name = "name"
    static let numericCode = "numericCode"
    static let callingCodes = "callingCodes"
    static let subregion = "subregion"
    static let translations = "translations"
    static let gini = "gini"
    static let nativeName = "nativeName"
    static let languages = "languages"
    static let demonym = "demonym"
    static let altSpellings = "altSpellings"
    static let latlng = "latlng"
    static let alpha3Code = "alpha3Code"
    static let topLevelDomain = "topLevelDomain"
    static let region = "region"
    static let relevance = "relevance"
    static let borders = "borders"
    static let timezones = "timezones"
    static let currencies = "currencies"
    static let population = "population"
    static let area = "area"
    static let capital = "capital"
  }

  // MARK: Properties
  public var alpha2Code: String?
  public var name: String?
  public var numericCode: String?
  public var callingCodes: [String]?
  public var subregion: String?
  public var translations: Translations?
  public var gini: Float?
  public var nativeName: String?
  public var languages: [String]?
  public var demonym: String?
  public var altSpellings: [String]?
  public var latlng: [Int]?
  public var alpha3Code: String?
  public var topLevelDomain: [String]?
  public var region: String?
  public var relevance: String?
  public var borders: [String]?
  public var timezones: [String]?
  public var currencies: [String]?
  public var population: Int?
  public var area: Int?
  public var capital: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    alpha2Code = json[SerializationKeys.alpha2Code].string
    name = json[SerializationKeys.name].string
    numericCode = json[SerializationKeys.numericCode].string
    if let items = json[SerializationKeys.callingCodes].array { callingCodes = items.map { $0.stringValue } }
    subregion = json[SerializationKeys.subregion].string
    translations = Translations(json: json[SerializationKeys.translations])
    gini = json[SerializationKeys.gini].float
    nativeName = json[SerializationKeys.nativeName].string
    if let items = json[SerializationKeys.languages].array { languages = items.map { $0.stringValue } }
    demonym = json[SerializationKeys.demonym].string
    if let items = json[SerializationKeys.altSpellings].array { altSpellings = items.map { $0.stringValue } }
    if let items = json[SerializationKeys.latlng].array { latlng = items.map { $0.intValue } }
    alpha3Code = json[SerializationKeys.alpha3Code].string
    if let items = json[SerializationKeys.topLevelDomain].array { topLevelDomain = items.map { $0.stringValue } }
    region = json[SerializationKeys.region].string
    relevance = json[SerializationKeys.relevance].string
    if let items = json[SerializationKeys.borders].array { borders = items.map { $0.stringValue } }
    if let items = json[SerializationKeys.timezones].array { timezones = items.map { $0.stringValue } }
    if let items = json[SerializationKeys.currencies].array { currencies = items.map { $0.stringValue } }
    population = json[SerializationKeys.population].int
    area = json[SerializationKeys.area].int
    capital = json[SerializationKeys.capital].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = alpha2Code { dictionary[SerializationKeys.alpha2Code] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = numericCode { dictionary[SerializationKeys.numericCode] = value }
    if let value = callingCodes { dictionary[SerializationKeys.callingCodes] = value }
    if let value = subregion { dictionary[SerializationKeys.subregion] = value }
    if let value = translations { dictionary[SerializationKeys.translations] = value.dictionaryRepresentation() }
    if let value = gini { dictionary[SerializationKeys.gini] = value }
    if let value = nativeName { dictionary[SerializationKeys.nativeName] = value }
    if let value = languages { dictionary[SerializationKeys.languages] = value }
    if let value = demonym { dictionary[SerializationKeys.demonym] = value }
    if let value = altSpellings { dictionary[SerializationKeys.altSpellings] = value }
    if let value = latlng { dictionary[SerializationKeys.latlng] = value }
    if let value = alpha3Code { dictionary[SerializationKeys.alpha3Code] = value }
    if let value = topLevelDomain { dictionary[SerializationKeys.topLevelDomain] = value }
    if let value = region { dictionary[SerializationKeys.region] = value }
    if let value = relevance { dictionary[SerializationKeys.relevance] = value }
    if let value = borders { dictionary[SerializationKeys.borders] = value }
    if let value = timezones { dictionary[SerializationKeys.timezones] = value }
    if let value = currencies { dictionary[SerializationKeys.currencies] = value }
    if let value = population { dictionary[SerializationKeys.population] = value }
    if let value = area { dictionary[SerializationKeys.area] = value }
    if let value = capital { dictionary[SerializationKeys.capital] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.alpha2Code = aDecoder.decodeObject(forKey: SerializationKeys.alpha2Code) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.numericCode = aDecoder.decodeObject(forKey: SerializationKeys.numericCode) as? String
    self.callingCodes = aDecoder.decodeObject(forKey: SerializationKeys.callingCodes) as? [String]
    self.subregion = aDecoder.decodeObject(forKey: SerializationKeys.subregion) as? String
    self.translations = aDecoder.decodeObject(forKey: SerializationKeys.translations) as? Translations
    self.gini = aDecoder.decodeObject(forKey: SerializationKeys.gini) as? Float
    self.nativeName = aDecoder.decodeObject(forKey: SerializationKeys.nativeName) as? String
    self.languages = aDecoder.decodeObject(forKey: SerializationKeys.languages) as? [String]
    self.demonym = aDecoder.decodeObject(forKey: SerializationKeys.demonym) as? String
    self.altSpellings = aDecoder.decodeObject(forKey: SerializationKeys.altSpellings) as? [String]
    self.latlng = aDecoder.decodeObject(forKey: SerializationKeys.latlng) as? [Int]
    self.alpha3Code = aDecoder.decodeObject(forKey: SerializationKeys.alpha3Code) as? String
    self.topLevelDomain = aDecoder.decodeObject(forKey: SerializationKeys.topLevelDomain) as? [String]
    self.region = aDecoder.decodeObject(forKey: SerializationKeys.region) as? String
    self.relevance = aDecoder.decodeObject(forKey: SerializationKeys.relevance) as? String
    self.borders = aDecoder.decodeObject(forKey: SerializationKeys.borders) as? [String]
    self.timezones = aDecoder.decodeObject(forKey: SerializationKeys.timezones) as? [String]
    self.currencies = aDecoder.decodeObject(forKey: SerializationKeys.currencies) as? [String]
    self.population = aDecoder.decodeObject(forKey: SerializationKeys.population) as? Int
    self.area = aDecoder.decodeObject(forKey: SerializationKeys.area) as? Int
    self.capital = aDecoder.decodeObject(forKey: SerializationKeys.capital) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(alpha2Code, forKey: SerializationKeys.alpha2Code)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(numericCode, forKey: SerializationKeys.numericCode)
    aCoder.encode(callingCodes, forKey: SerializationKeys.callingCodes)
    aCoder.encode(subregion, forKey: SerializationKeys.subregion)
    aCoder.encode(translations, forKey: SerializationKeys.translations)
    aCoder.encode(gini, forKey: SerializationKeys.gini)
    aCoder.encode(nativeName, forKey: SerializationKeys.nativeName)
    aCoder.encode(languages, forKey: SerializationKeys.languages)
    aCoder.encode(demonym, forKey: SerializationKeys.demonym)
    aCoder.encode(altSpellings, forKey: SerializationKeys.altSpellings)
    aCoder.encode(latlng, forKey: SerializationKeys.latlng)
    aCoder.encode(alpha3Code, forKey: SerializationKeys.alpha3Code)
    aCoder.encode(topLevelDomain, forKey: SerializationKeys.topLevelDomain)
    aCoder.encode(region, forKey: SerializationKeys.region)
    aCoder.encode(relevance, forKey: SerializationKeys.relevance)
    aCoder.encode(borders, forKey: SerializationKeys.borders)
    aCoder.encode(timezones, forKey: SerializationKeys.timezones)
    aCoder.encode(currencies, forKey: SerializationKeys.currencies)
    aCoder.encode(population, forKey: SerializationKeys.population)
    aCoder.encode(area, forKey: SerializationKeys.area)
    aCoder.encode(capital, forKey: SerializationKeys.capital)
  }

}
