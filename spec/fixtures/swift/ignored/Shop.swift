/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Shop: Object {

  enum Attributes: String {
    static let ignored = "ignored"
    static let ignored2 = "ignored2"
    static let name = "name"
  }

  enum Relationships: String {
    static let owner = "owner"
    static let products = "products"
  }

  @objc dynamic var ignored: String = ""
  @objc dynamic var ignored2: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var owner: Owner?
  let products = List<Product>()

  // Specify properties to ignore (Realm won't persist these)
  override static func ignoredProperties() -> [String] {
    return ["ignored","ignored2"]
  }

}
