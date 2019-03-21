#import <CoreLocation/CoreLocation.h>

@interface ChuiNiuHelper : NSObject

@property(strong) id vc;

+ (instancetype) shareHelper;

+ (BOOL) isInstall;
+ (void) showDownload;
+ (BOOL) initPlugin: (NSDictionary*) param;
- (void) init: (id) viewControll;
+ (BOOL) handlerOpenURL: (NSURL*) url;
+ (void) shareImg: (NSDictionary*) param;
+ (void) shareURL: (NSDictionary*) param;

@end
