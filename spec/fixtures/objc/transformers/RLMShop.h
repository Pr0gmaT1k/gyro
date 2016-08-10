// DO NOT EDIT | Generated by dbgenerator

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Imports

#import <Realm/Realm.h>

#pragma mark - Defines & Constants

extern const struct RLMShopAttributes {
    __unsafe_unretained NSString *attrDate;
    __unsafe_unretained NSString *attrDateCustom;
    __unsafe_unretained NSString *attrDecimal;
    __unsafe_unretained NSString *attrDouble;
    __unsafe_unretained NSString *attrFloat;
    __unsafe_unretained NSString *attrInteger16;
    __unsafe_unretained NSString *attrInteger32;
    __unsafe_unretained NSString *attrInteger64;
} RLMShopAttributes;

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Interface

@interface RLMShop : RLMObject

#pragma mark - Properties

@property NSDate *attrDate;
@property NSDate *attrDateCustom;
@property double attrDecimal;
@property double attrDouble;
@property float attrFloat;
@property int attrInteger16;
@property long attrInteger32;
@property long long attrInteger64;

@end