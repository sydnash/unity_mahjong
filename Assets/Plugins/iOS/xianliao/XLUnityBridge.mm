#import "XLUnityBridge.h"
#import "SugramApiManager.h"

extern "C" {
    NSString* _CreateNSString (const char* string);
    
    void RegisterXL(const char* appid) {
        [SugramApiManager registerApp:_CreateNSString(appid)];
        [SugramApiManager getGameFromSugram:^(NSString *roomToken, NSString *roomId, NSNumber *openId) {
        }];
    }
    void ShareXLText(const char* content) {
        if([SugramApiManager isInstallSugram]) {
            SugramShareTextObject *textObject = [[SugramShareTextObject alloc] init];
            textObject.text = _CreateNSString(content);
            [SugramApiManager share:textObject fininshBlock:^(SugramShareCallBackType callBackType) {
                //NSLog(@"callBackType:%ld", (long)callBackType);
            }];
        }
    }
    void ShareXLImg(Byte* ptr, int size) {
        if([SugramApiManager isInstallSugram]) {
            NSData *data = [[NSData alloc] initWithBytes:ptr length:size];
            SugramShareImageObject *imageObject = [[SugramShareImageObject alloc] init];
            imageObject.imageData = data;
            [SugramApiManager share:imageObject fininshBlock:^(SugramShareCallBackType callBackType) {
                //NSLog(@"callBackType:%ld", (long)callBackType);
            }];
        }
    }
    void InviteXL(const char* token, const char* roomid, const char* title, const char* text, const char* imgUrl, Byte* ptr, int size, const char* androidUrl, const char* iosUrl) {
        if([SugramApiManager isInstallSugram]) {
            SugramShareGameObject *game = [[SugramShareGameObject alloc] init];
            game.roomToken = _CreateNSString(token);
            game.roomId = _CreateNSString(roomid);
            game.title = _CreateNSString(title);
            game.text = _CreateNSString(text);
            game.imageUrl = _CreateNSString(imgUrl);
            game.imageData = [[NSData alloc] initWithBytes:ptr length:size];
            game.androidDownloadUrl = _CreateNSString(androidUrl);
            game.iOSDownloadUrl = _CreateNSString(iosUrl);
            [SugramApiManager share:game fininshBlock:^(SugramShareCallBackType callBackType) {
                //NSLog(@"callBackType:%ld", (long)callBackType);
            }];
        }
    }
    void SetLoginState_XL(int state) {
        [XLUnityBridge shareHelper].loginState = state;
    }
    void ClearXLInviteParam() {
        [[XLUnityBridge shareHelper] clearInviteParam];
    }
    const char* GetXLInviteParam() {
        NSString* param = [[XLUnityBridge shareHelper] getInviteParam];
        
        return strdup([param UTF8String]);
    }
}


@interface XLUnityBridge ()
@end

@implementation XLUnityBridge

+(instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static XLUnityBridge *instance;
    dispatch_once(&onceToken, ^{
        instance = [[XLUnityBridge alloc] init];
    });
    return instance;
}

- (id) init {
    self = [super init];
    self.appid = @"MVGhscFdSy3OO7KG";
    self.roomId = @"";
    self.roomToken = @"";
    self.loginState = 0;
    return self;
}
        
- (void) registerXL {
    [SugramApiManager registerApp: self.appid];
    [SugramApiManager getGameFromSugram:^(NSString *roomToken, NSString *roomId, NSNumber *openId) {
        [self onXLInviteMsg:roomToken inviteRoomId:roomId invitePlayer:openId];
    }];
}

- (void) onXLInviteMsg:(NSString *)roomToken inviteRoomId:(NSString *)roomId invitePlayer:(NSNumber *)appid {
    self.roomId = roomId;
    self.roomToken = roomToken;
    if (self.loginState > 0) {
        NSString* param = [self getInviteParam];
        UnitySendMessage("IOSMessageHandler", "OnXLInviteMsg", [param UTF8String]);
    }
}

- (NSString*) getInviteParam {
    NSString* param = self.roomId;
    return param;
}

- (void) clearInviteParam {
    self.roomId = @"";
    self.roomToken = @"";
}

+ (BOOL) handlerOpenURL: (NSURL*) url{
    BOOL ret = [SugramApiManager handleOpenURL:url];
    if (ret) {
        return ret;
    }
    if ([url.scheme isEqualToString:@"yjmj"]) {
        NSString *query = url.query;
        NSArray *subArray = [query componentsSeparatedByString:@"&"];
        NSString *param1 = @"";
        NSString *param2 = @"";
        for (int i = 0; i < subArray.count; i++) {
            NSArray *dicarray = [subArray[i] componentsSeparatedByString:@"="];
            NSString *key = dicarray[0];
            if ([key isEqualToString:@"param1"]) {
                param1 = dicarray[1];
            } else if ([key isEqualToString:@"param2"]) {
                param2 = dicarray[1];
            }
            [[XLUnityBridge shareHelper] onXLInviteMsg:param1 inviteRoomId:param2 invitePlayer:0];
        }
        return true;
    }
    return false;
}

@end
