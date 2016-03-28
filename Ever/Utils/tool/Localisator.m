//
//  Localisator.m
//  Ever
//
//  Created by Mac on 15/6/7.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "Localisator.h"

@interface Localisator ()

@property NSDictionary * dicoLocalisation;
@property NSUserDefaults * defaults;

@end

@implementation Localisator


#pragma mark -Singleton Method

+(Localisator *)sharedInstance
{
    static Localisator *sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance=[[Localisator alloc]init];
        
    });
    
    return sharedInstance;
}

#pragma  mark init methods
- (id)init
{
    self=[super init];
    if (self) {
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        NSString *languageSaved=[defaults objectForKey:kSaveLanguageDefaultKey];
        if (languageSaved!=nil) {
            
            [self loadDictionaryForLanguage:languageSaved];
        
        }
        
    }
    
    return self;
        
}

-(BOOL)loadDictionaryForLanguage:(NSString *)newLanguage
{
    NSString *path=[[NSBundle mainBundle]pathForResource:newLanguage ofType:@"strings"];
    self.dicoLocalisation=[NSDictionary dictionaryWithContentsOfFile:path];
    
    return YES;
}


-(BOOL)setLanguage:(NSString *)newLanguage
{

    
    [self loadDictionaryForLanguage:newLanguage];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                        object:nil];
    
    return YES;
    


}

-(NSString *)localizedStringForKey:(NSString*)key
{
    if (self.dicoLocalisation == nil)
    {
        return NSLocalizedString(key, key);
    }
    else
    {
        NSString * localizedString = self.dicoLocalisation[key];
        if (localizedString == nil)
            localizedString = key;
        return localizedString;
    }
}




@end
