//
//  TA_SongDetailViewController.m
//  TestApp
//
//  Created by Danish Ahmed Ansari on 22/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import "TA_SongDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Song.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface TA_SongDetailViewController ()

@property (nonatomic, strong) UIImageView *coverArtImgView;

@end

@implementation TA_SongDetailViewController


- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _song.title;
    
    
    _coverArtImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
    CGRect imgViewFrame = _coverArtImgView.frame;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_0) {
        imgViewFrame.origin.x = self.view.center.x - 85;
        imgViewFrame.origin.y = self.view.center.y - 135;
        _coverArtImgView.frame = imgViewFrame;
    }
    else {
        imgViewFrame.origin.x = self.view.center.x - 85;
        imgViewFrame.origin.y = self.view.center.y - 85;
        _coverArtImgView.frame = imgViewFrame;
    }
    _coverArtImgView.backgroundColor = [UIColor lightGrayColor];
    [_coverArtImgView setImageWithURL:[NSURL URLWithString:_song.img_url_170] placeholderImage:nil];
    
    UITapGestureRecognizer *open_iTunesApp_Tap_Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(open_iTunesApp:)];
    open_iTunesApp_Tap_Gesture.numberOfTapsRequired = 2;
    _coverArtImgView.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:open_iTunesApp_Tap_Gesture];
    
    UIPinchGestureRecognizer *zoom_in_out_Gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:zoom_in_out_Gesture];
    
    [self.view addSubview:_coverArtImgView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD showImage:nil status:@"Pinch to Zoom In/Zoom Out,\nDouble Tap to buy this song on iTunes"];
    [self performSelector:@selector(dismissProgressView) withObject:nil afterDelay:1.0];
}

- (void)dismissProgressView {
    [SVProgressHUD dismiss];
}

#pragma mark - Gesture Recognizers
- (void)open_iTunesApp:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSURL *appStoreUrl = [NSURL URLWithString:_song.song_url];
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded
        || recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = _coverArtImgView.frame.size.width / _coverArtImgView.bounds.size.width;
        CGFloat newScale = currentScale * recognizer.scale;
        
        if (newScale < 0.3f) {
            newScale = 1.0f;
        }
        if (newScale > 9.5f) {
            newScale = 1.0f;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        _coverArtImgView.transform = transform;
        recognizer.scale = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil) {
        _song = nil;
        _coverArtImgView = nil;
    }
}

@end
