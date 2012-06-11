//
//  ViewController.h
//  iPhotos
//
//  Created by Atit Patumvan on 6/5/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) UIScrollView *scrollView;
@property (readwrite, nonatomic) NSUInteger iconPerRow;
@property (readwrite, nonatomic) CGFloat iconWidth;
@property (readwrite, nonatomic) CGFloat iconHeight;

@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic,retain) NSMutableArray *images;


-(NSMutableArray *) loadAssets;
-(NSMutableArray *) loadImages: (NSMutableArray *) _assets; 
@end
