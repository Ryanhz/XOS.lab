//
//  Test2AudioTools.h
//  library
//
//  Created by hzf on 2018/8/16.
//  Copyright © 2018年 hzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Text2AudioTools : NSObject

+ (Text2AudioTools* _Nonnull) shared;

- (void)configApiKey:(NSString * _Nonnull)apiKey secretKey:(NSString * _Nonnull)secretKey cuid:(NSString * _Nonnull)cuid;

- (void)play:(NSString * _Nonnull)speechText;

- (void)stop;

@end
