//
//  TXLocationManager.h
//  TXLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define  TXLastLongitude @"TXLastLongitude"
#define  TXLastLatitude  @"TXLastLatitude"
#define  TXLastCity      @"TXLastCity"
#define  TXLastAddress   @"TXLastAddress"

typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);
typedef void(^CLPlacemarkBlock)(CLPlacemark *placmark);

@interface TXLocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic,readonly) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong,readonly)NSString *lastCity;
@property (nonatomic,strong,readonly) NSString *lastAddress;

+ (TXLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock ;

/**
 *  获取坐标和地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取定位信息和定位失败
 *
 *  @param placemarkBlock  cityBlock description
 *  @output    placmark.addressDictionary 地址包括以下内容
 *             :addressDictionary  地址信息的dictionary
 *             :thoroughfare  指定街道级别信息
 *             :subThoroughfare  指定街道级别的附加信息
 *             :locality  指定城市信息(城市)
 *             :administrativeArea  行政区域(省份)
 *             :subAdministrativeArea  行政区域附加信息
 *             :country  国家信息
 *             :countryCode  国家代号
 *             :postalCode  邮政编码
 *  @param errorBlock errorBlock description
 */
- (void) getPlacemark:(CLPlacemarkBlock)placemarkBlock error:(LocationErrorBlock) errorBlock;


@end
