#import <CoreLocation/CoreLocation.h>


@interface UtilsHelper : NSObject<CLLocationManagerDelegate>

+ (instancetype) shareHelper;

- (void) startLocationOnce;
- (void) startLocationUpdate;
- (void) stopLocationUpdate;
+ (void) openThirdApp: (NSDictionary*) param;
@end
