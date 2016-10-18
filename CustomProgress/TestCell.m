//
//  TestCell.m
//  CustomProgress
//
//  Created by Admin on 2016/10/18.
//  Copyright © 2016年 杨文磊. All rights reserved.
//

#import "TestCell.h"

@interface TestCell()<CustomProgressDelegate>
{
    CustomProgress *custompro;
}

@end

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier])
    {
        
        custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(10, 10, 183, 50)];
        
        custompro.maxValue = 60;
        //设置背景色
        custompro.bgimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:120/255.0 blue:121/255.0 alpha:1];
        custompro.leftimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.35];
        
        custompro.presentlab.textColor = [UIColor whiteColor];
        
        custompro.delegate = self;
        
        [self.contentView addSubview:custompro];
        
    }
    return self;
}

-(void)setSdModel:(SoundModel *)sdModel
{
    _sdModel = sdModel;
    custompro.sdmodel = sdModel;
    
}

#pragma mark -- 实现代理方法..
-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString
{
    if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
        [self.delegate customProgressDidTapWithPlayState:state andWithUrl:urlString];
    }
}



@end
