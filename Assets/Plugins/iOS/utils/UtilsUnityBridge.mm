#include <string>
#include <vector>
#include "OpenUDID.h"
#import <CoreLocation/CoreLocation.h>
#import "OCUriHelper.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#import <UIKit/UIkit.h>
#endif

extern "C"
{
    const char* getDeviceId()
    {
        NSString *id = [OpenUDID value];
        const char* cstr = [id UTF8String];
        return cstr;
    }
    
    void startInsall(const char* url)
    {
    }
    void openExplore(const char* path)
    {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        NSString *url = [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
#endif
    }
    void vibrate(long* patten, int size, int repeat)
    {
        
    }
    const char* getExternalStorageDir()
    {
        return "";
    }
    bool isExternalStorageDirAccessable()
    {
        return false;
    }
	
	void setToClipboard(const char *text)
	{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		UIPasteboard *pb = [UIPasteboard generalPasteboard];
		[pb setString:[NSString stringWithUTF8String:text]];
#endif
	}
	
	const char* getFromClipboard()
	{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		UIPasteboard *pb = [UIPasteboard generalPasteboard];
		NSString *str =  [pb string];
        const char* cstr = [str UTF8String];
        return cstr;
#else
        return "";
#endif
	}
    float getDistance(float latitude1, float longitude1, float latitude2, float longitude2) {
        CLLocation *c = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
        CLLocation *a = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
        float dis = float([c distanceFromLocation:a]);
        return dis;
    }
    void startLocationOnce() {
        [[UtilsHelper shareHelper] startLocationOnce];
    }
    void startLocationUpdate() {
        [[UtilsHelper shareHelper] startLocationUpdate];
    }
    void stopLocationUpdate() {
        [[UtilsHelper shareHelper] stopLocationUpdate];
    }
}


