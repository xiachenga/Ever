//
//  ContactViewController.m
//  Ever
//
//  Created by Mac on 15-4-16.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "ContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SearchUserViewController.h"
#import "ContactUser.h"

@interface ContactViewController ()

@property (nonatomic,strong)NSMutableArray  *array;

@property (nonatomic,copy)NSString *name;

@end

@implementation ContactViewController

//懒加载
-(NSMutableArray *)array
{
    if (_array==nil) {
        _array=[NSMutableArray array];
    }
    return _array;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
        self.title=self.title=LOCALIZATION(@"Contacts");
    
    }
    return self;
}

- (void)viewDidLoad
{
    
    //注册通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:kNotificationLanguageChanged object:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tongxunlu_sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(sesarchFriend)];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);

    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    
    
    
    
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        ContactUser *user=[[ContactUser alloc]init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        user.name=nameString;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        user.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        user.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [self.array addObject:user];
        
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:id];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
    }
    
    cell.backgroundColor=[UIColor colorWithHexString:@"f5f6f0"];
    ContactUser *user=self.array[indexPath.row];
    cell.textLabel.text=user.name;
    [cell addLineUp:NO andDown:YES];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.size=CGSizeMake(30, 30);
    addButton.tag=indexPath.row;
    [addButton setBackgroundImage:[UIImage imageNamed:@"tongxunlu_tianjia"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView=addButton;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)sesarchFriend{
    

    SearchUserViewController *searchUserVC=[[SearchUserViewController alloc]init];
    [self.navigationController pushViewController:searchUserVC animated:YES];
}

-(void)buttonClicked:(UIButton *)button{
    
    
    ContactUser *user=self.array[button.tag];
    NSString *string=[kSeverPrefix stringByAppendingString:@"app/invite/"];
    NSString *urlString=[string stringByAppendingString:user.tel];
    
    [HttpTool get:urlString params:nil success:^(id responseobj) {
        
        CLog(@"%@",responseobj);
        
        NormalResult *result=[NormalResult objectWithKeyValues:responseobj];
        
        [MBProgressHUD showError:result.prompt];
        
        
    } failure:^(NSError *erronr) {
        
    }];
    
    [button setBackgroundImage:[UIImage imageNamed:@"tongxunlu_yitianjia"] forState:UIControlStateNormal];
}


- (void)languageChange
{
    
    self.title=self.title=LOCALIZATION(@"Contacts");
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}
@end
