//
//  TestCell.h
//  CustomProgress
//
//  Created by Admin on 2016/10/18.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgress.h"
#import "SoundModel.h"
#import "RecordPlayManager.h"

@interface TestCell : UITableViewCell

@property (nonatomic,strong) RecordPlayManager * rdmanager;
@property (nonatomic,strong) SoundModel * sdModel;

@property (nonatomic,weak) id<CustomProgressDelegate> delegate;


@end
