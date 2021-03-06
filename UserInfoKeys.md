
# User info keys documentation

Below are details about how to annotate your `.xcdatamodel` entities and attributes to be able to leverage each Realm features when generating your Realm models with Gyro.

---

### Summary :

- [Primary key](#primary-key)
- [Ignore attribute](#ignore-attribute)
- [Read only](#read-only)
- [Inverse Relationships](#inverse-relationships)
- [Optionnals fields and wrapper types](#optionnals-fields-and-wrapper-types)
- [Support Annotations](#support-annotations)
- [Handling enums](#handling-enums)
- [Add comments to the generated classes](#add-comments-to-the-generated-classes)
- [JSON Mapping](#json-mapping)
	- [Combine JSONKeyPath and enums](#combine-jsonkeypath-and-enums)
- [Custom ValueTransformers](#custom-valuetransformers)

---

<a name="primary-key"></a>
# Primary key

To tell which attribute will be used as a primary key, add the following 'user info' to **the entity**:

| Key | Value |
|-----|-------|
| `identityAttribute` | `name_of_the_attribute` |


__Example__: On the "FidelityCard" entity:

![Primary Key](documentation/primary_key.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {
	
	[...]
    @PrimaryKey
    private short identifier;
	[...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

```swift
/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class FidelityCard: Object {

  [...]
  dynamic var identifier: Int16 = 0
  
  override static func primaryKey() -> String? {
    return "identifier"
  }

}
```
</details>


---

<a name="ignore-attribute"></a>
# Ignore attribute

You can decide to ignore some attributes of the `.xcdatamodel` file. They will not be persisted to Realm. To do so, add the following 'user info' to **the attribute**:

| Key | Value |
|-----|-------|
| `realmIgnored` | `value` |


__Example__: on the attribute `ignored` of the entity `Shop`:

![Ignored Attribute](documentation/ignored.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.Ignore;

/* DO NOT EDIT | Generated by gyro */

public class Shop extends RealmObject {

	[...]
    @Ignore
    private String ignored;
    [...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

```swift
/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Shop: Object {

  dynamic var ignored: String = ""

  // Specify properties to ignore (Realm won't persist these)
  override static func ignoredProperties() -> [String] {
    return ["ignored"]
  }

}

```
</details>


---

<a name="read-only"></a>
# Read only (DEPRECATED)

<details>
<summary> Information about read only 'user info'</summary>
On iOS/macOS, you can define attributes which are not persisted and whose value is computed dynamically.
To do so, add the following 'user info' to **the attribute**

| Key | Value |
|-----|-------|
| `realmReadOnly` | `the_code_source_to_generate` |


__Example__: On the `readOnly`  attribute of the `Shop`  entity:

![Read Only](documentation/read_only.png)
</details>

<details>
<summary>📑 Sample of the generated code in Objective-C (iOS)</summary>

```objc
// DO NOT EDIT | Generated by gyro

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import "RLMShop.h"

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Implementation

@implementation RLMShop

#pragma mark - Superclass Overrides

- (NSString *)readOnly
{
    return self.name;
}

@end
```
</details>


---

<a name="inverse-relationships"></a>
# Inverse Relationships

In realm, when you have both A -> B and B -> A relationships, you have to choose one of those relationships to be the primary one (e.g. A -> B) — that will be stored in Realm — and the other inverse relationship will then be **computed** by code. [For more information, see the related RealmSwift documentation on Inverse Relationships](https://realm.io/docs/swift/latest/#inverse-relationships).

To mark a relationship as being an inverse relationship (the B -> A relationship and not the primary A -> B one), the convention in `gyro` is to **suffix the name of the relationship with an underscore `_`** .

This will then generate the following code in Swift for that inverse relationship:

```swift
LinkingObjects(fromType: A.self, property: "b")`
```

If your inverse relationship is defined to point to a unique object (inverse of a `1-*` relationship for exemple, and not a `*-*` one), the generated code will contain both the plural form of the computed variable and a singular form returning its first element, for convenience:

```swift
let owners = LinkingObjects(fromType: Person.self, property: "dogs")
var owner: Person? { return owners.first }
```


---

<a name="optionnals-fields-and-wrapper-types"></a>
# Optionnals fields and wrapper types

On Android, the `-p use_wrappers` flag allows you to use wrapper types (`Double`, `Short`, …) for optional fields instead of primitive types (`double`, `short`, …).

<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {
	
  @PrimaryKey
  private short identifier;   // "optional" checkbox not checked in the xcdatamodel
  private Integer points;     // "optional" checkbox checked in the xcdatamodel

}

```
</details>

---

<a name="support-annotations"></a>
# Support Annotations

On Android, the flag `-p support_annotations` allows you to annotate class attributes' getters & setters with `@Nullable` (if the attribute is optional) or `@NonNull` (if it isn't) attributes.  
This option can be combined with the `-p use_wrappers` wrapper flag to generate a safer and more secure code in Android Studio, generating proper warnings if misused.

<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    private short identifier;
    @android.support.annotation.IntRange(from=0,to=255)
    private Integer points;
    private User user;
	
	[...]
	
    @android.support.annotation.Nullable
    @android.support.annotation.IntRange(from=0,to=255)
    public Integer getPoints() {
        return points;
    }

    public void setPoints(@android.support.annotation.Nullable @android.support.annotation.IntRange(from=0,to=255) final Integer points) {
        this.points = points;
    }
    [...]
}

```
</details>

Furthermore, it's possible to add custom annotations to your fields.
To do that, simply add the key/value pair to the UserInfos of the attribute to annotate:

| Key | Value |
|-----|-------|
| `supportAnnotation` | `AnnotationToAdd` |


__Example__: If you wish to add the `IntRange(from=0,to=255)` annotation to an attribute, use the following:

![Support Annotation](documentation/support_annotation.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

```java
package com.gyro.tests;

import io.realm.RealmObject;

/* DO NOT EDIT | Generated by gyro */

public class FidelityCard extends RealmObject {

    public interface Attributes {
        String IDENTIFIER = "identifier";
        String POINTS = "points";
    }

    private short identifier;
    @android.support.annotation.IntRange(from=0,to=255)
    private int points;

    public short getIdentifier() {
        return identifier;
    }

    public void setIdentifier(final short identifier) {
        this.identifier = identifier;
    }

    @android.support.annotation.IntRange(from=0,to=255)
    public int getPoints() {
        return points;
    }

    public void setPoints(@android.support.annotation.IntRange(from=0,to=255) final int points) {
        this.points = points;
    }
}
```
</details>


---

<a name="handling-enums"></a>
# Handling enums

Sometimes, an `Int` attribute in the model actually represents an `enum` member in your model. To deal with this case, you can add the following two key/value pairs to this **attribute**:

| Key | Value |
|-----|-------|
| `enumType` | `my_type` |
| `enumValues` | `my_value_1, my_value_2, my_value_3` |

> _Note: If you also add the `JSONKeyPath` User Info key to your attribute in addition to enums, you'll have to add the `JSONValues` to also tell the mapping between the `enumValues` and the matching possible values found in the JSON. See the [JSON Mapping](#json-mapping) below for more details._

__Example__: On the attribute `type` of the `Shop` entity.

![enum](documentation/enum.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

`Shop.java`:

```java
package com.gyro.tests;

/* DO NOT EDIT | Generated by gyro */

import io.realm.RealmObject;

public class Shop extends RealmObject {
    private String name;
    private String type;
    
    public String getType() {
        return type;
    }
    
    public Type getTypeEnum() {
        return Type.get(getType());
    }

    public void setTypeEnum(final Type type) {
        this.type = type.getJsonValue();
    }
	[...]
}


```

`Type.java`:

```java
package com.gyro.tests;

/* DO NOT EDIT | Generated by gyro */

public enum Type {

    TYPE_ONE("TypeOne"),
    TYPE_TWO("TypeTwo"),
    TYPE_THREE("TypeThree");
    [...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

`Shop.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

import RealmSwift
import Foundation

final class Shop: Object {
  [...]
  dynamic var type: String = ""
  var typeEnum: Type? {
    get {
      guard let enumValue = Type(rawValue: type) else { return nil }
      return enumValue
    }
    set { type = newValue?.rawValue ?? "" }
  }
}
```

`Type.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

enum Type: String {
  case typeOne = "TypeOne"
  case typeTwo = "TypeTwo"
  case typeThree = "TypeThree"
}

```
</details>

> **Note**: For Android and Swift, each enum is created in a separate file.

---

<a name="add-comments-to-the-generated-classes"></a>
# Add comments to the generated classes

To make the generated code more readable, it's possible to add comments on an entity/attribute/relationship — e.g. to provide a short description of what this entity/attribute/relationship is supposed to represent.

To do so, simply add the following key/value pair to your **entity/attribute/relationship** in your `.xcdatamodel`:

| Key | Value |
|-----|-------|
| `comment` | `the_comment_text_here` |

A code comment will then be generated (`.swift` (Swift) or `.java` (Android)) just before the declaration, e.g. to help the developer understand what this class/attribute/relationship is for.


---

<a name="json-mapping"></a>
# JSON Mapping

You can also add the json mapping for each **attribute** or **relationship** with the following key/value pair:

| Key | Value |
|-----|-------|
| `JSONKeyPath` | `json_field_name` |

This key is only used when using the `ObjectMapper` or `Decodable` template.

Currently, this will then generate:

 * Code for `ObjectMapper` or `Decodable` on iOS (in the future we plan to generate `Sourcery` annotations instead so that people can choose whatever JSON library they prefer).
 * `GSON` annotations (`@SerializedName(…)`) for Android

__Example__: On the 'name' attribute of the 'Shop' entity:

![JSONKeyPath](documentation/json.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

Sur Android, nous utilisons la librairie GSON

```java
package com.gyro.tests;

/* DO NOT EDIT | Generated by gyro */

import com.google.gson.annotations.SerializedName;

import io.realm.RealmList;
import io.realm.RealmObject;

public class Shop extends RealmObject {

    @SerializedName("json_name")
    private String name;
    private RealmList<Product> products;
	[...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

On iOS, we support `Decodable` and `Object Mapper` templates for parsing/mapping.

`Shop+Decodable.swift`:

```swift 
/* DO NOT EDIT | Generated by gyro */

import protocol Decodable.Decodable
import Decodable

extension Shop: Decodable {

  static func decode(_ json: Any) throws -> Shop {
    let shop = Shop()
      shop.name = try json => "name"
      let productsSandbox: [Product] = try json => "products"
    shop.products.append(objectsIn: productsSandbox)
    return shop
  }
}

```

`ShopMapper.swift`:

```swift 
/* DO NOT EDIT | Generated by gyro */

import ObjectMapper

extension Shop: Mappable {

  // MARK: Initializers

  convenience init?(map: Map) {
    self.init()
  }

  // MARK: Mappable

  func mapping(map: Map) {

    // MARK: Attributes
    self.name <- map["name"]

    // MARK: Relationships
    self.products <- (map["products"], ListTransform<Product>())
  }
}
```

</details>

<a name="combine-jsonkeypath-and-enums"></a>
## Combine JSONKeyPath and enums

Note that you can **combine that `JSONKeyPath` key with enums** (see [Handling enums](#handling-enums) above). If you declared the User Info keys to make your attribute an enum (`enumType` + `enumValues`) in addition to `JSONKeyPath`, you'll have to also add the `JSONValues` key to list the corresponding values in the JSON for those `enumValues`. 

| Key | Value |
|-----|-------|
| `JSONValues` | `valeur_json_1,valeur_json_2,valeur_json_3` |

The number of items listed for that `JSONValues` key must be the same as the number of items listed for the `enumValues` keys, obviously.

__Example__:

![enum_json](documentation/enum_json.png)


<details>
<summary>📑 Sample of the generated code in Java (Android)</summary>

`Type.java`:

```java
package com.gyro.tests;

/* DO NOT EDIT | Generated by gyro */

public enum Type {

    TYPE_ONE("json_type_one"),
    TYPE_TWO("json_type_two"),
    TYPE_THREE("json_type_three");
	[...]
}
```
</details>

<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

`Type.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

enum Type: String {
  case typeOne = "json_type_one"
  case typeTwo = "json_type_two"
  case typeThree = "json_type_three"
}

```
</details>


--- 

<a name="custom-valuetransformers"></a>
# Custom ValueTransformers

Only available on iOS (as Android uses the GSON library), custom `ValueTransformers` allows you to e.g. convrt a `String` into an `Int` or a `Date` when parsing the JSON. They are only used when using `ObjectMapper` or `Decodable` template.

To create a specific `ValueTransformer` for a field:

* Create your `ValueTransformer` custom class inheriting `NSValueTransformer` and add it to your project
* Select the attribute that will need this transformer, and in the UserInfo field, add a pair for the **transformer** key whose value should be the name of the `ValueTransformer` class to use:

| Key | Value |
|-----|-------|
| `transformer` | `NameOfTheTransformerClass` |

__Example__:

![transformer](documentation/transformer.png)


<details>
<summary>📑 Sample of the generated code in Swift (iOS)</summary>

`gyro` will produce the following code. (In this example, attributes `attrDouble` and `attrInteger32` don't have a **transformer** key set in their UserInfo).

`Shop+Decodable.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

import protocol Decodable.Decodable
import Decodable

extension Shop: Decodable {

  static func decode(_ json: Any) throws -> Shop {
    let shop = Shop()
      shop.attrDate = try Date.decode(json => "attrDate")
      shop.attrDateCustom = try Date.decode(json => "attrDateCustom")
      shop.attrDouble = try json => "attrDouble"
      shop.attrInteger16 = try Int.decode(json => "attrInteger16")
      shop.attrInteger32 = try json => "attrInteger32"
      shop.attrInteger64 = try Int.decode(json => "attrInteger64")
    return shop
  }
}
```

`ShopMapper.swift`:

```swift
/* DO NOT EDIT | Generated by gyro */

import ObjectMapper

extension Shop: Mappable {

  // MARK: Initializers
  convenience init?(_ map: Map) {
    self.init()
  }

  // MARK: Mappable
  func mapping(map: Map) {
    // MARK: Attributes
    self.attrDate <- (map["attrDate"], ISO8601DateTransform())
    self.attrDateCustom <- (map["attrDateCustom"], CustomDateTransformer())
    self.attrDecimal <- (map["attrDecimal"], MPDecimalTransformer())
    self.attrDouble <- map["attrDouble"]
    self.attrFloat <- (map["attrFloat"], MPDecimalTransformer())
    self.attrInteger16 <- (map["attrInteger16"], MPIntegerTransformer())
    self.attrInteger32 <- map["attrInteger32"]
    self.attrInteger64 <- (map["attrInteger64"], MPIntegerTransformer())
  }
}

```
</details>

