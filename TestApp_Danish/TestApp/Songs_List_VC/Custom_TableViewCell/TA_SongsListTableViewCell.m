//
//  TA_SongsListTableViewCell.m
//  TestApp
//
//  Created by Danish Ahmed Ansari on 21/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import "TA_SongsListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Song.h"

@interface TA_SongsListTableViewCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation TA_SongsListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 60.0f)];
        [self.contentView addSubview:_title];
        
        self.coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
        self.coverImgView.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.coverImgView];
    }
    return self;
}


- (void)layoutSubviews {
    CGRect titleFrame = _title.frame;
    titleFrame.origin.x = 80.0f;
    titleFrame.origin.y = 10.0f;
    _title.frame = titleFrame;
    _title.numberOfLines = 0;
    _title.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGRect imageFrame = _coverImgView.frame;
    imageFrame.origin.x = 10.0f;
    imageFrame.origin.y = 10.0f;
    _coverImgView.frame = imageFrame;
}

- (void)setupCellWithSong:(Song *)song {
    _title.text = song.title;
    
    //Reachability *reachability = [Reachability reachabilityForInternetConnection];
    //NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    // If the user is online via Wifi - Load High Quality Images - 170 x 170 px
    // else Load Medium Quality Images - 60 x 60 px
    //if (netStatus == 2 || netStatus == 1) {
        [_coverImgView setImageWithURL:[NSURL URLWithString:song.img_url_170] placeholderImage:nil];
    //}
    /*
    else if(netStatus == 1){
        [_coverImgView setImageWithURL:[NSURL URLWithString:song.img_url_60] placeholderImage:nil];
    }*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
