/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Shop: Object {

  enum Attributes: String {
    static let name = "name"
  }

  enum Relationships: String {
    static let products = "products"
  }

  @objc dynamic var name: String = ""
  let products = List<Product>()

}
