/* DO NOT EDIT | Generated by dbgenerator */

import RealmSwift

final class Product: Object {

    enum Attributes: String {
        case Brand = "brand"
        case Name = "name"
        case Price = "price"
    }

    dynamic var brand: String? = nil
    dynamic var name: String = ""
    let price = RealmOptional<Int32>()

}