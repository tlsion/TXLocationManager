//
//  TXLocationManager.m
//  TXLocationManagerDemo
//
//  Created by 王庭协 on 2017/1/6.
//  Copyright © 2017年 ApeStar. All rights reserved.
//

#import "TXLocationManager.h"

@interface TXLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,assign) BOOL isLocating;

@property (nonatomic, strong) TXLocationErrorBlock errorBlock;
@property (nonatomic, strong) TXPlacemarkBlock placemarkBlock;

@property (nonatomic,strong,readwrite) TXPlacemark *placmark;

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
        
        self.placmark = [[TXPlacemark alloc] init];
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [standard objectForKey:TXLastPlacmark];
        CLPlacemark * placmark = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        [self.placmark updatePlacemark:placmark];
        
    }
    return self;
}

- (void)startLocate
{
    self.isLocating = YES;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog(@"定位服务已开启");
        }
        [weakSelf.locationManager startUpdatingLocation];
    });
}

- (void)stopLocate
{
    self.isLocating = NO;
    [self.locationManager stopUpdatingLocation];
}

- (void) locatePlacemark:(TXPlacemarkBlock)placemarkBlock error:(TXLocationErrorBlock) errorBlock;{
    self.placemarkBlock = [placemarkBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocate];
}

#pragma mark- CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!self.isLocating || newLocation.coordinate.latitude == 0 || newLocation.coordinate.longitude == 0 ) {
        return;
    }
    [self stopLocate];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        if (error) {
            if (_errorBlock) {
                _placemarkBlock = nil;
                _errorBlock(error);
            }
            return;
        }
        
        CLPlacemark *placeMark = [placemarks firstObject];
        
        [self.placmark updatePlacemark:placeMark];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:placeMark];
            [standard setValue:encodedObject forKey:TXLastPlacmark];
        });
        
        if (_placemarkBlock) {
            _placemarkBlock(self.placmark);
            _placemarkBlock = nil;
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

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocate];
    if (_errorBlock) {
        _placemarkBlock = nil;
        _errorBlock(error);
    }
}

@end


@implementation TXPlacemark

- (void)updatePlacemark:(CLPlacemark *)placemark{
    self.coordinate = placemark.location.coordinate;
    
    NSDictionary *addressDic = placemark.addressDictionary;
    self.addressDictionary = addressDic;
    
    self.country = placemark.country;
    self.province = placemark.administrativeArea;
    self.city =  placemark.locality;
    self.district = placemark.subLocality;
    self.street = placemark.thoroughfare;
    self.subStreet = placemark.subThoroughfare;
    self.postalCode = placemark.postalCode;
    self.countryCode = placemark.ISOcountryCode;
    NSArray * formattedAddressLines = placemark.addressDictionary[@"FormattedAddressLines"];
    NSString * addressDescription = [formattedAddressLines firstObject];
    self.addressDescription = [addressDescription stringByReplacingOccurrencesOfString:self.country withString:@""];
}

@end
