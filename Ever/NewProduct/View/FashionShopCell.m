//
//  FashionShopCell.m
//  Ever
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 wolf_silence. All rights reserved.
//

#import "FashionShopCell.h"


@interface FashionShopCell ()

@property (nonatomic,weak)UITapImageView *shopLogoView,*oneGoodsView,*twoGoodsView;



@end

@implementation FashionShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //商家logo
        
        UITapImageView *shopLogoView=[[UITapImageView alloc]init];
        self.shopLogoView=shopLogoView;
        [self.contentView addSubview:shopLogoView];
        
        //第一张图片
        UITapImageView *oneGoodsView=[[UITapImageView alloc]init];
        self.oneGoodsView=oneGoodsView;
        [self.contentView addSubview:oneGoodsView];
        
        //第二张图片
        UITapImageView *twoGoodsView=[[UITapImageView alloc]init];
        self.twoGoodsView=twoGoodsView;
        [self.contentView addSubview:twoGoodsView];
        
    
    }
    
    return self;
    
}

- (void)setFashionCase:(ShowcaseIndexResult *)fashionCase{
    
    _fashionCase=fashionCase;
    
    [self.shopLogoView setImageWithUrl:[NSURL URLWithString:fashionCase.banner_image_url] placeholderImage:nil tapBlock:^(id obj) {
        
        CLog(@"点击商家了");
        
        if (_shopLogoviewClicked) {
            
            _shopLogoviewClicked(nil);
        }
        
        
        
    }];
    
    [self.oneGoodsView setImageWithUrl:[NSURL URLWithString:fashionCase.goods_image_one_url] placeholderImage:nil tapBlock:^(id obj) {
        
        CLog(@"点击第一张商品");
        
    }];
    
    [self.twoGoodsView setImageWithUrl:[NSURL URLWithString:fashionCase.goods_image_two_url] placeholderImage:nil tapBlock:^(id obj) {
        
        CLog(@"点击第二张商品");
    }];

}
- (void)layoutSubviews{
    
    [self.shopLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).offset(10);
        
        make.left.mas_equalTo(self.mas_left).offset(10);
        
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-2*10, 160));
        
    }];
    
    
    [self.oneGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.shopLogoView.mas_bottom);
        
        make.left.mas_equalTo(self.mas_left).offset(10);
        
        make.size.mas_equalTo(CGSizeMake((kScreen_Width-2*10)*0.5, 140));
    }];
    
    [self.twoGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.shopLogoView.mas_bottom);
        
        make.left.mas_equalTo(self.oneGoodsView.mas_right);
        
        make.size.mas_equalTo(CGSizeMake((kScreen_Width-2*10)*0.5, 140));
    }];
    
}
@end
