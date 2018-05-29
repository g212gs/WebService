//
//  Translations.swift
//
//  Created by Gaurang Lathiya on 30/05/18
//  Copyright (c) Gaurang Lathiya. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Translations: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let es = "es"
    static let ja = "ja"
    static let de = "de"
    static let fr = "fr"
    static let it = "it"
  }

  // MARK: Properties
  public var es: String?
  public var ja: String?
  public var de: String?
  public var fr: String?
  public var it: String?

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
    es = json[SerializationKeys.es].string
    ja = json[SerializationKeys.ja].string
    de = json[SerializationKeys.de].string
    fr = json[SerializationKeys.fr].string
    it = json[SerializationKeys.it].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = es { dictionary[SerializationKeys.es] = value }
    if let value = ja { dictionary[SerializationKeys.ja] = value }
    if let value = de { dictionary[SerializationKeys.de] = value }
    if let value = fr { dictionary[SerializationKeys.fr] = value }
    if let value = it { dictionary[SerializationKeys.it] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.es = aDecoder.decodeObject(forKey: SerializationKeys.es) as? String
    self.ja = aDecoder.decodeObject(forKey: SerializationKeys.ja) as? String
    self.de = aDecoder.decodeObject(forKey: SerializationKeys.de) as? String
    self.fr = aDecoder.decodeObject(forKey: SerializationKeys.fr) as? String
    self.it = aDecoder.decodeObject(forKey: SerializationKeys.it) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(es, forKey: SerializationKeys.es)
    aCoder.encode(ja, forKey: SerializationKeys.ja)
    aCoder.encode(de, forKey: SerializationKeys.de)
    aCoder.encode(fr, forKey: SerializationKeys.fr)
    aCoder.encode(it, forKey: SerializationKeys.it)
  }

}
