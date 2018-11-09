#import <CoreLocation/CoreLocation.h>

@interface XLUnityBridge : NSObject

@property(nonatomic, assign) int loginState;
@property(nonatomic, copy) NSString *appid;
@property(nonatomic, copy) NSString *roomToken;
@property(nonatomic, copy) NSString *roomId;

+ (instancetype) shareHelper;

- (void) registerXL;

- (void) onXLInviteMsg:(NSString*)roomToken inviteRoomId:(NSString*)roomId invitePlayer:(NSNumber*)appid;
- (void) clearInviteParam;

- (NSString*) getInviteParam;

+ (BOOL) handlerOpenURL: (NSURL*) url;

@end
