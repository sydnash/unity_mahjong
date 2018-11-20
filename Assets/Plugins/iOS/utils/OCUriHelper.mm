#import "OCUriHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface UtilsHelper ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isUpdateOnce;
@end

@implementation UtilsHelper

+(instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static UtilsHelper *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UtilsHelper alloc] init];
    });
    return instance;
}

- (id) init {
    self = [super init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager requestWhenInUseAuthorization];
        self.isUpdateOnce = false;
        self.locationManager.distanceFilter = 1.0f;
    }
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coor = location.coordinate;
    float latitude = float(coor.latitude);
    float longitude = float(coor.longitude);
    
    NSString* param = [NSString stringWithFormat:@"{\"latitude\": %f, \"longitude\": %f, \"isOk\":true}", latitude, longitude];
    //[self callLuaFunctionWithString:self.locationHandler param:param];
    //cocos2d::LuaBridge::releaseLuaFunctionById(self.locationHandler);
    //send message for location callback
    UnitySendMessage("IOSMessageHandler", "OnLocationUpdate", [param UTF8String]);
    
    if (self.isUpdateOnce) {
        self.isUpdateOnce = false;
        [self stopLocationUpdate];
    }
}

- (void) startLocationOnce {
    [self startLocationUpdate];
    self.isUpdateOnce = true;
}

- (void) startLocationUpdate {
    self.isUpdateOnce = false;
    [self.locationManager startUpdatingHeading];
}

- (void) stopLocationUpdate {
    [self.locationManager stopUpdatingLocation];
}




@end
