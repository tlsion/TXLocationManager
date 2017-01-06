//
//  TXLocationManager.m
//  TXLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "TXLocationManager.h"

@interface TXLocationManager ()

@property (nonatomic,strong) CLLocationManager* locationManager;

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic, strong) CLPlacemarkBlock placemarkBlock;

@property (nonatomic,readwrite) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong,readwrite)NSString *lastCity;
@property (nonatomic,strong,readwrite) NSString *lastAddress;

@end

@implementation TXLocationManager

+ (TXLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:TXLastLongitude];
        float latitude = [standard floatForKey:TXLastLatitude];
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:TXLastCity];
        self.lastAddress=[standard objectForKey:TXLastAddress];
    }
    return self;
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

/**
 *  获取定位信息和定位失败
 *
 *  @param placemarkBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getPlacemark:(CLPlacemarkBlock)placemarkBlock error:(LocationErrorBlock) errorBlock{
    self.placemarkBlock = [placemarkBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

#pragma mark- CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.lastCoordinate = oldLocation.coordinate;
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    [standard setObject:@(self.lastCoordinate.longitude) forKey:TXLastLongitude];
    [standard setObject:@(self.lastCoordinate.latitude) forKey:TXLastLatitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        CLPlacemark *placeMark = [placemarks firstObject];
        NSDictionary *addressDic=placeMark.addressDictionary;
        
        NSString *state=[addressDic objectForKey:@"State"];
        NSString *city=[addressDic objectForKey:@"City"];
        NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
        NSString *street=[addressDic objectForKey:@"Street"];
        
        self.lastCity = city;
        self.lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
        
        [standard setObject:self.lastCity forKey:TXLastCity];
        [standard setObject:self.lastAddress forKey:TXLastAddress];
        [standard synchronize];
    
        [self stopLocation];
        
        if (_placemarkBlock) {
            _placemarkBlock(placeMark);
            _placemarkBlock = nil;
        }
        
        if (_cityBlock) {
            _cityBlock(_lastCity);
            _cityBlock = nil;
        }
        
        if (_locationBlock) {
            _locationBlock(_lastCoordinate);
            _locationBlock = nil;
        }
        
        if (_addressBlock) {
            _addressBlock(_lastAddress);
            _addressBlock = nil;
        }
    };
    
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];
            }
            
            break;
            
        default:
            
            break;
    }
    
}

-(void)startLocation
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog(@"定位服务已开启");
        }
        [weakSelf.locationManager startUpdatingLocation];
    });
}

-(void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

@end
