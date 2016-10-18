//
//  AFSoundItem.h
//  AFSoundManager-Demo
//
//  Created by Alvaro Franco on 20/01/15.
//  Copyright (c) 2015 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AFSoundItem : NSObject

typedef NS_ENUM(NSInteger, AFSoundItemType) {
    
    AFSoundItemTypeLocal,
    AFSoundItemTypeStreaming
};

-(id)initWithLocalResource:(NSString *)name atPath:(NSString *)path;
-(id)initWithStreamingURL:(NSURL *)URL;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, strong) UIImage *artwork;

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic) NSInteger duration;
@property (nonatomic) NSInteger timePlayed;

-(void)setInfoFromItem:(AVPlayerItem *)item;

@end
