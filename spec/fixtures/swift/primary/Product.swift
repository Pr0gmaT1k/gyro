/* DO NOT EDIT | Generated by dbgenerator */

import RealmSwift

final class Product: Object {

    enum Attributes: String {
        case Brand = "brand"
        case Name = "name"
        case Price = "price"
    }

    dynamic var brand: String = ""
    dynamic var name: String = ""
    dynamic var price: Int32 = 0

    override static func primaryKey() -> String? {
        return "name"
    }

}