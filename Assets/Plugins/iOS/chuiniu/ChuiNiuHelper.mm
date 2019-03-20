#import "OCUriHelper.h"
#import "ChuiNiuHelper.h"
#import "CNManager.h"
#import "CNShareManager.h"
#import "CNImageObject.h"
#import "CNShareWebpageObject.h"
#import "OauthObj.h"

extern "C"
{
    NSString* _CreateNSString (const char* string);

    void cnchat_shareimg_ios(const char* _filePath) {
        if([ChuiNiuHelper isInstall]) {
            NSString* imagePath = _CreateNSString(_filePath);
            UIImage* img = [UIImage imageWithContentsOfFile:imagePath];
            CNShareMessageObject *messageObject = [CNShareMessageObject new];
            CNImageObject* shareObject = [CNImageObject initWithImage: img];
            messageObject.shareObject = shareObject;
            id vc = [ChuiNiuHelper shareHelper].vc;
            [CNShareManager.defaultManager shareWithMessageObject:messageObject currentViewController:vc completion:^(id result, CNShareErrCode error) {
            }];
        }
    }
    void cnchat_shareurl_ios(const char* url, const char* _title, const char* _desc, const char* _iconPath) {
        if ([ChuiNiuHelper isInstall]) {
            NSString *urlStr = _CreateNSString(url);
            NSString *title = _CreateNSString(_title);
            NSString *desc = _CreateNSString(_desc);
            NSString* iconPath = _CreateNSString(_iconPath);
            UIImage *img = [UIImage imageNamed:iconPath];
            CNShareMessageObject *sobj = [CNShareMessageObject new];
            CNShareWebpageObject *wobj = [CNShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:img];
            wobj.urlIntent = urlStr;
            sobj.shareObject = wobj;
            id vc = [ChuiNiuHelper shareHelper].vc;
            [CNShareManager.defaultManager shareWithMessageObject:sobj currentViewController:vc completion:^(id result, CNShareErrCode error) {
            }];
        }
    }
    void cnchat_showDownload() {
        [ChuiNiuHelper showDownload];
    }
    bool cnchat_isInstall() {
        return [ChuiNiuHelper isInstall];
    }
}

@interface ChuiNiuHelper ()<CNManagerDelegate>
@end

@implementation ChuiNiuHelper

+(instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static ChuiNiuHelper *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ChuiNiuHelper alloc] init];
    });
    return instance;
}

+ (BOOL) isInstall {
    return [CNManager isCNAppInstalled];
}

+ (void) showDownload {
    [CNManager showInstallCNChat];
}

+ (BOOL) initPlugin: (NSDictionary*) param {
    if(![ChuiNiuHelper isInstall]) {
        return false;
    }

    NSString* appid = (NSString*)[param objectForKey:@"appid"];
    NSString* secret = (NSString*)[param objectForKey:@"secret"];
    [CNManager registerAppWithAppid:appid appsecret:secret delegate:[ChuiNiuHelper shareHelper]];
    return true;
}

-(void)oauthBackWith:(OauthObj *)oauthObj errCode:(CNAuthErrCode)errCode{
    
}
-(void)inviteBackWith:(id)backInfo{
    
}
-(void)shareCompletion:(id)result error:(CNShareErrCode)error{
    
}

+ (BOOL) handlerOpenURL: (NSURL*) url {
    return [CNManager handleOpenURL:url];
}

- (void) init: (id) vc {
    self.vc = vc;
}

+ (void) shareImg: (NSDictionary*) param {
    if([ChuiNiuHelper isInstall]) {
        NSString* imagePath = (NSString*)[param objectForKey:@"imgpath"];
        UIImage* img = [UIImage imageWithContentsOfFile:imagePath];
        CNShareMessageObject *messageObject = [CNShareMessageObject new];
        CNImageObject* shareObject = [CNImageObject initWithImage: img];
        messageObject.shareObject = shareObject;
        id vc = [ChuiNiuHelper shareHelper].vc;
        [CNShareManager.defaultManager shareWithMessageObject:messageObject currentViewController:vc completion:^(id result, CNShareErrCode error) {
        }];
    }
}
+ (void) shareURL: (NSDictionary*) param {
    if ([ChuiNiuHelper isInstall]) {
        NSString *urlStr = (NSString*)[param objectForKey:@"url"];
        NSString *title = (NSString*)[param objectForKey:@"title"];
        NSString *desc = (NSString*)[param objectForKey:@"desc"];
        NSString* iconPath = (NSString*)[param objectForKey:@"iconpath"];
        UIImage *img = [UIImage imageNamed:iconPath];
        CNShareMessageObject *sobj = [CNShareMessageObject new];
        CNShareWebpageObject *wobj = [CNShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:img];
        wobj.urlIntent = urlStr;
        sobj.shareObject = wobj;
        id vc = [ChuiNiuHelper shareHelper].vc;
        [CNShareManager.defaultManager shareWithMessageObject:sobj currentViewController:vc completion:^(id result, CNShareErrCode error) {
        }];
    }
}

@end
