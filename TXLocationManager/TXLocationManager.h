//
//  TXLocationManager.m
//  TXLocationManagerDemo
//
//  Created by 王庭协 on 2017/1/6.
//  Copyright © 2017年 ApeStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define  TXLastPlacmark @"UD_TXLastPlacmarks"

@class TXPlacemark;

typedef void(^TXPlacemarkBlock)(TXPlacemark *placmark);
typedef void (^TXLocationErrorBlock) (NSError *error);

@interface TXLocationManager : NSObject

@property (nonatomic,strong,readonly) TXPlacemark *placmark;

+ (TXLocationManager *)shareLocation;

/**
 *  开始定位
 */
- (void) startLocate;

/**
 *  获取定位信息和定位失败
 *
 *  @param placemarkBlock  TXPlacemark description
 *  @param errorBlock errorBlock description
 */
- (void) locatePlacemark:(TXPlacemarkBlock)placemarkBlock error:(TXLocationErrorBlock) errorBlock;

@end


@interface TXPlacemark : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;//坐标
@property (nonatomic, strong) NSDictionary * addressDictionary;//地址相关信息
@property (nonatomic, copy)NSString * country;//国家信息
@property (nonatomic, copy)NSString * countryCode;//国家代号
@property (nonatomic, copy)NSString * province;//省份
@property (nonatomic, copy)NSString * city; //城市
@property (nonatomic, copy)NSString * district; //地区
@property (nonatomic, copy) NSString * street; //街道
@property (nonatomic, copy) NSString * subStreet; //街道级别信息
@property (nonatomic, copy) NSString * addressDescription;//地区详情
@property (nonatomic, copy) NSString * postalCode;//邮政编号

- (void)updatePlacemark:(CLPlacemark *)placemark;

@end
