//
//  Localisator.h
//  Ever
//
//  Created by Mac on 15/6/7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCALIZATION(text) [[Localisator sharedInstance] localizedStringForKey:(text)]

//全局通知
static NSString *const kNotificationLanguageChanged=@"kNotificationLanguageChanged";


@interface Localisator : NSObject

@property (nonatomic , copy) NSString *currentLanguage;




+ (Localisator *)sharedInstance;

- (BOOL)setLanguage:(NSString *)newLanguage;

-(NSString *)localizedStringForKey:(NSString*)key;
@end
