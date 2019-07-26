//
//  Test2AudioTools.m
//  library
//
//  Created by hzf on 2018/8/16.
//  Copyright © 2018年 hzy. All rights reserved.
//

#import "Text2AudioTools.h"
#import <AVFoundation/AVFoundation.h>

#ifdef DEBUG

#define DLog(FORMAT, ...) fprintf(stderr, "%s: %s%zd\t%s\n\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String],__PRETTY_FUNCTION__,  __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define DLog(FORMAT, ...) nil

#endif


NSString * const kBaidu_Oauth_TokenURL = @"https://openapi.baidu.com/oauth/2.0/token";
NSString * const kBaidu_Oauth_text2audioURL = @"https://tsn.baidu.com/text2audio";



@interface BaiduAudioTokenModel: NSObject

@property(nonatomic, copy) NSString *access_token;
@property(nonatomic, copy) NSString *refresh_token;
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSString *session_key;
@property(nonatomic, copy) NSString *session_secret;
@property(nonatomic, assign) double expires_in;
@property(nonatomic, assign) double createDate;
@end

@implementation BaiduAudioTokenModel

+ (BaiduAudioTokenModel *)tokenModel:(NSDictionary *)dict {

    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *keys = dict.allKeys;
    
    NSArray *list = @[@"access_token", @"expires_in", @"refresh_token", @"scope", @"session_key", @"session_secret"];

    for (NSString * key in list) {
        if (![keys containsObject:key]) {
            return nil;
        }
    }
    
    /*
     "access_token": "1.a6b7dbd428f731035f771b8d********.86400.1292922000-2346678-124328",
     "expires_in": 86400,
     "refresh_token": "2.385d55f8615fdfd9edb7c4b********.604800.1293440400-2346678-124328",
     "scope": "public",
     "session_key": "ANXxSNjwQDugf8615Onqeik********CdlLxn",
     "session_secret": "248APxvxjCZ0VEC********aK4oZExMB",
     */

    NSMutableDictionary *mDict = dict.mutableCopy;
    NSNumber *nCreateDate = mDict[@"createDate"];
    if (!nCreateDate) {
      double currentDate = [[NSDate date] timeIntervalSince1970];
      mDict[@"createDate"] = @(currentDate);
    }
    BaiduAudioTokenModel* model = [[BaiduAudioTokenModel alloc]init];
    [model writeDict:mDict];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"forUndefinedKey:  %@=%@", key,value);
}

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"expires_in"]) {
        self.expires_in = [value doubleValue];
    } else {
        [super setValue:value forKey:key];
    }
}

+ (NSString *)tokenCachePath{
    
    
    NSString *cachePaths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

//    NSString *prefePath =[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    cachePaths = [cachePaths stringByAppendingString:@"/Token.plist"];
    return cachePaths;
}

- (void)writeDict:(NSDictionary *)dic {
   BOOL flg = [dic writeToFile:[BaiduAudioTokenModel tokenCachePath] atomically:true];
}

- (BOOL)valid {
    double currentDate = [[NSDate date] timeIntervalSince1970];
    if ((_createDate + _expires_in) > currentDate + 10) {
        return false;
    }
    return true;
}

@end

@interface Text2AudioTools()

@property(nonatomic, copy) NSString *apiKey;
@property(nonatomic, copy) NSString *secretKey;
@property (nonatomic,copy) NSString *cuid;
//@property(nonatomic, assign) long expires_in;

@property (nonatomic, strong) AVAudioPlayer* player;

@property(nonatomic, strong) BaiduAudioTokenModel *tokenModel;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation Text2AudioTools

+ (Text2AudioTools* _Nonnull) shared{
    static Text2AudioTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [Text2AudioTools new];
    });
    return tools;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _apiKey = @"o51GUxTkmNI9aYt3ycAYjaUX";
        _secretKey = @"uiGzMAqy5zs9yb59XMuBcXnNKjGx9vEn";
        _queue = dispatch_queue_create("com.Text2AudioTools.playerQueue", nil);
        _tokenModel = [BaiduAudioTokenModel tokenModel:[NSDictionary dictionaryWithContentsOfFile:[BaiduAudioTokenModel tokenCachePath]]];
    }
    return self;
}

- (void)configApiKey:(NSString *)apiKey secretKey:(NSString *)secretKey cuid:(NSString *)cuid {
    self.apiKey = apiKey ? apiKey : @"";
    self.secretKey = secretKey ? secretKey : @"";
    self.cuid = cuid ? cuid : @"";
}

- (void)stop {
    [self.player stop];
}

- (void)play:(NSString *)speechText {
    if (!speechText) {
        return;
    }
    dispatch_async(_queue, ^{
        NSData *data = [self text2AudioWith:speechText];
        if (data) {
            [self.player stop];
            NSError *error;
            self.player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
            if (error) {
                DLog(@"%@", error);
                return ;
            }
            [self.player play];
        }
    });
}

- (NSData *)text2AudioWith:(NSString *)speechText {
    NSString * token;
    @synchronized(self) {
        token = [self getToken];
    }
    if (!token) {
        DLog(@"access_token 获取失败");
        return nil;
    }
    return [self getAudioWith:speechText token:token cuid: self.cuid];
}

//获取token
- (NSString *)getToken {
    if (self.tokenModel && [self.tokenModel valid]) {
        return self.tokenModel.access_token;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?grant_type=client_credentials&client_id=%@&client_secret=%@",kBaidu_Oauth_TokenURL,self.apiKey,self.secretKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSString *token = nil;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        BaiduAudioTokenModel *tokenModel = [BaiduAudioTokenModel tokenModel:dict];
        if (tokenModel) {
            self.tokenModel = tokenModel;
            token = tokenModel.access_token;
        }
        DLog(@"%@", dict);
        dispatch_semaphore_signal(signal);
    }];
    [sessionDataTask resume];
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return token;
}

//获取文字转语音
- (NSData *)getAudioWith:(NSString *)text token:(NSString *)token cuid:(NSString *)cuid {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kBaidu_Oauth_text2audioURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *para = [NSString stringWithFormat:@"tex=%@&lan=zh&cuid=%@&ctp=1&aue=3&tok=%@", text, cuid, token];
    request.HTTPBody = [para dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSData *audioData = nil;
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        audioData = data;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        DLog(@"%@", dict);
        DLog(@"%@", error);
        if (dict && dict[@"err_no"] ) { //token验证失败
            int err_no  = [dict[@"err_no"] intValue];
            switch (err_no) {
                case 500:
                    DLog(@"不支持输入");
                    break;
                case 501:
                    DLog(@"输入参数不正确");
                    break;
                case 502:
                    DLog(@"token验证失败");
                    self.tokenModel = nil;
                    break;
                case 503:
                    DLog(@"合成后端错误");
                    break;
                    
                default:
                    break;
            }
        }
        dispatch_semaphore_signal(signal);
    }];
    [sessionDataTask resume];
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return audioData;
}

@end
