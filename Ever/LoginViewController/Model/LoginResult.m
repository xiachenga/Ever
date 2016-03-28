//
//  LoginResult.m
//  Ever
//
//  Created by Mac on 15-4-10.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "LoginResult.h"
#import "AppBeanResultBase.h"
@implementation LoginResult
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.rong_token=[coder decodeObjectForKey:@"rong_token"];
        self.uuid=[coder decodeObjectForKey:@"uuid"];
        self.if_has_reg=[[coder decodeObjectForKey:@"if_has_reg"]boolValue];
        self.password=[coder decodeObjectForKey:@"password"];
        self.email=[coder decodeObjectForKey:@"email"];
        self.telephone=[coder decodeObjectForKey:@"telephone"];
        self.sex=[[coder decodeObjectForKey:@"sex"]intValue];
        
        self.meili_num=[[coder decodeObjectForKey:@"meili_num"]intValue];;
        self.money=[[coder decodeObjectForKey:@"money"]doubleValue];
        self.description_content=[coder decodeObjectForKey:@"description_content"];
        self.real_name=[coder decodeObjectForKey:@"real_name"];
        self.detail_address=[coder decodeObjectForKey:@"detail_address"];
        self.city=[coder decodeObjectForKey:@"city"];
        self.birthday_time_stamp=(long)[[coder decodeObjectForKey:@"birthday_time_stamp"]longLongValue];
        self.can_see_center=[[coder decodeObjectForKey:@"can_see_center"]boolValue];
        self.can_search=[[coder decodeObjectForKey:@"can_search"]boolValue];
        self.business_type=[[coder decodeObjectForKey:@"business_type"]intValue];
        self.uid=[coder decodeObjectForKey:@"uid"];
        self.loginType=[[coder decodeObjectForKey:@"loginType"]intValue];
        self.user_head_image_url=[coder decodeObjectForKey:@"user_head_image_url"];
        self.user_id=(long)[[coder decodeObjectForKey:@"user_id"]longLongValue];
        self.user_nickname=[coder decodeObjectForKey:@"user_nickname"];
        self.prompt=[coder decodeObjectForKey:@"prompt"];
        self.if_success=[[coder decodeObjectForKey:@"if_success"]boolValue];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.rong_token forKey:@"rong_token"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.if_has_reg] forKey:@"if_has_reg"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.sex] forKey:@"sex"];
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.meili_num] forKey:@"meili_num"];
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%f",self.money] forKey:@"money"];
    
    [aCoder encodeObject:self.description_content forKey:@"description_content"];
    [aCoder encodeObject:self.real_name forKey:@"real_name"];
    [aCoder encodeObject:self.detail_address forKey:@"detail_address"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.birthday_time_stamp] forKey:@"birthday_time_stamp"];
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.can_see_center] forKey:@"can_see_center"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.can_search] forKey:@"can_search"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.business_type]forKey:@"business_type"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.loginType] forKey:@"loginType"];
    [aCoder encodeObject:self.user_head_image_url forKey:@"user_head_image_url"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.user_id] forKey:@"user_id"];
    [aCoder encodeObject:self.user_nickname forKey:@"user_nickname"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.if_success] forKey:@"if_success"];
    [aCoder encodeObject:self.prompt forKey:@"prompt"];
    
    
}

@end
