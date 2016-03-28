//
//  HttpTool.m
//  Ever
//
//  Created by Mac on 15-4-5.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "LoginResult.h"
@implementation HttpTool



+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    LoginResult *account=[AccountTool account];
    long userid;
    if (account.user_id==0) {
        userid=-1;
    }else{
        
        userid=account.user_id;
    }
    
    CLog(@"%ld",userid);
    
    
    NSString *user_id=[NSString stringWithFormat:@"%ld",userid];
    
    NSString *pwd=[NSString string];
    if (account.password==nil) {
        pwd=0;
    }else{
        pwd=account.password;
    }
    

    //获得请求管理者
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"accept-charset"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [manager.requestSerializer setValue:@"zh-CN" forHTTPHeaderField:@"accept-language"];
    [manager.requestSerializer setValue:@"TestClient" forHTTPHeaderField:@"User-Agent"];
    //测试密码 b7992fdaef6ff9fbb77469f863a02304
    [manager.requestSerializer setValue:@"9977c943c05810d4dbe5babc3f45b55a" forHTTPHeaderField:@"ever-pwd"];
    [manager.requestSerializer setValue:@"ever" forHTTPHeaderField:@"ever-header"];
    [manager.requestSerializer setValue:user_id forHTTPHeaderField:@"user-id"];
    
    [manager.requestSerializer setValue:pwd forHTTPHeaderField:@"user-password"];
    
    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    manager.securityPolicy=securityPolicy;
    
    NSLog(@"获取短信url：%@",url);

    
    //发送get请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
        NSLog(@"短信发送成功");
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            NSLog(@"短信发送失败");

            failure(error);
        }
        
        
    }];
    
    
}



+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    LoginResult *account=[AccountTool account];
    long userid;
    if (account.user_id==0) {
        userid=-1;
    }else{
        userid=account.user_id;
    }
    NSString *user_id=[NSString stringWithFormat:@"%ld",userid];
    
    NSString *pwd=[NSString string];
    if (account.password==nil) {
        pwd=0;
    }else{
        pwd=account.password;
    }
    //获得请求管理者
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"accept-charset"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [manager.requestSerializer setValue:@"zh-CN" forHTTPHeaderField:@"accept-language"];
    [manager.requestSerializer setValue:@"TestClient" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"9977c943c05810d4dbe5babc3f45b55a" forHTTPHeaderField:@"ever-pwd"];
    [manager.requestSerializer setValue:@"ever" forHTTPHeaderField:@"ever-header"];
    [manager.requestSerializer setValue:user_id forHTTPHeaderField:@"user-id"];
    
    [manager.requestSerializer setValue:pwd forHTTPHeaderField:@"user-password"];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",nil];
    

//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    manager.securityPolicy=securityPolicy;
    
    //发送post请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+(void)send:(NSString *)urlstring params:(NSDictionary *)params success:(void(^)(id responseobj))success
{
    LoginResult *account=[AccountTool account];
    long userid;
    if (account.user_id==0) {
        userid=-1;
    }else{
        userid=account.user_id;
    }
    NSString *user_id=[NSString stringWithFormat:@"%ld",userid];
    
    NSString *pwd=[NSString string];
    if (account.password==nil) {
        pwd=0;
    }else{
        pwd=account.password;
    }
    
    NSURL *url=[NSURL URLWithString:urlstring];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    [request setValue:@"application/json"  forHTTPHeaderField:@"content-type"];
    [request setValue:@"zh-CN"  forHTTPHeaderField:@"accept-language"];
    [request setValue:@"close"  forHTTPHeaderField:@"connection"];
    
    [request setValue:@"ever"   forHTTPHeaderField:@"ever-header"];
    
    [request setValue:@"9977c943c05810d4dbe5babc3f45b55a"  forHTTPHeaderField:@"ever-pwd"];
    
    [request setValue:@"IOS 8.1"  forHTTPHeaderField:@"user-agent"];
    
    [request setValue:user_id forHTTPHeaderField:@"user-id"];
    
    [request setValue:pwd forHTTPHeaderField:@"user-password"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    request.HTTPBody=data;
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
       if (success) {
           
           CLog(@"%@",response);
//            NSLog(@"短信发送成功");
            success(data);
        }else
        {
//            NSLog(@"短信发送失败");
            CLog(@"%@",response);
        }
        
}];
    
}


@end
