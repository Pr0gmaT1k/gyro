/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class FidelityCard: Object {

  enum Attributes: String {
    case identifier = "identifier"
    case points = "points"
  }

  enum Relationships: String {
    case user = "user"
  }

  @objc dynamic var identifier: Int16 = 0
  @objc dynamic var points: Int32 = 0
  @objc dynamic var user: User?

  override static func primaryKey() -> String? {
    return "identifier"
  }

}
