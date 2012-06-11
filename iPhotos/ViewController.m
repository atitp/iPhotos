//
//  ViewController.m
//  iPhotos
//
//  Created by Atit Patumvan on 6/5/55 BE.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UIImageViewBorder.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize scrollView;

@synthesize iconPerRow;
@synthesize iconHeight;
@synthesize iconWidth;
@synthesize assets;
@synthesize images;

const CGFloat kScrollObjHeight	= 100.0;
const CGFloat kScrollObjWidth	= 100.0;


- (void)layoutScrollImages:(UIScrollView *) view
{
    
    CGFloat viewWidth =  [view bounds].size.width;
    CGFloat viewHeight = [view bounds].size.height;
    
    iconWidth =  100;
    iconHeight = 100;
	
    UIImageView *tempView = nil;
	NSArray *subviews = [view subviews];
    
    
    NSUInteger counter = 0;
    
	// reposition all image subviews in a horizontal serial fashion
	NSUInteger column = 0;
    NSUInteger row = 0;
	for (tempView in subviews)
	{
		if ([tempView isKindOfClass:[UIImageView class]] && tempView.tag > 0)
		{

            column = counter % iconPerRow;
            row = counter/iconPerRow;
            NSLog(@"%u, %u, %u", counter, column, row);
			CGRect frame = tempView.frame;
			//frame.origin = CGPointMake(curXLoc, curYLoc);
			frame.origin = CGPointMake(20+((iconWidth+15)*column), 20+((iconHeight+15)*row));
            tempView.frame = frame;
            counter++;
		}
	}
	
	// set the content size so it can be scrollable
    [view setContentSize:CGSizeMake(viewWidth, 2000)];
}

-(NSMutableArray *) loadAssets{
    NSMutableArray * _assets = [[NSMutableArray alloc] init]; //จองเมโมรี่ให้ตัวแปร assets
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init]; //สร้างตัวแปร library (ALAssetsLibrary)
    
    //สั่งให้ตัวแปร library ให้ดึงข้อมูลด้วย block assetGroupEnumerator โดยดึง asset ทั้งหมดในเครื่อง (ALAssetsGroupAll) 

    //block groupAssetEnumerationBlock เหมือน anonymous class ในภาษาอื่นเช่น java
    //วนดึงข้อมูลรูปและvdoในcamera roll
    void (^groupAssetEnumerationBlock)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        NSLog(@"index %i", index);
        
        //ถ้าได้ข้อมูล Asset หรือรูปภาพ vdo ในเครื่อง
        if (result != NULL) {
            
            //กำหนดประเภทของ asset ที่ต้องการ เป็นรูปภาพ
            NSString *assetType = [result valueForProperty:ALAssetPropertyType];//ALAssetTypePhoto //ALAssetPropertyType
            
            //เช็คว่าเป็นรูปภาพ เอาเฉพาะรูปภาพเท่านั้น
            if ([assetType isEqualToString:ALAssetTypePhoto] == YES){
                NSLog(@"index photo %i", index);
                //เก็บข้อมูล asset ที่เป็นรูปภาพลงในตัวแปร assets (mutable array)
                [_assets addObject:result];
                
                /*
                 //กำหนดจำนวนที่จะโหลดที่ 30, 30 แล้ว stop
                 if ([assets count] >= 30) {
                 
                 *stop = YES;
                 return;
                 }
                 */
                
            }
        }
    };
    
    //block assetGroupEnumerator เหมือน anonymous class ในภาษาอื่นเช่น java
    //สั่งให้ไปดึงข้อมูลรูปภาพในเครื่อง
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            //สั่งให้ block groupAssetEnumerationBlock ทำงาน
            [group enumerateAssetsUsingBlock:groupAssetEnumerationBlock];
        }
        
        //ดึงข้อมูลรูปในเครื่องเสร็จแล้วให้เมธอด loadImages ทำงานต่อ
        //[self loadImages];
       self.images = [self loadImages:_assets];
    };
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) { 
        NSLog(@"failed"); //ถ้า error ให้ log ว่า failed
    }];
    
    return _assets;
}

-(NSMutableArray *) loadImages:(NSMutableArray *)_assets {
    NSLog(@"%s",__func__);
    
    NSMutableArray * _images  = [[NSMutableArray alloc] init]; //สร้างตัวแปร จองเมโมรี่
    
    for (int i = 0; i < [_assets count]; i++) { // วนดึงรูปภาพจากข้อมูลในตัวแปร assets
        
        ALAsset *asset = [_assets objectAtIndex:i]; // asset ที่ 0,1,2,3,... 
        [_images addObject:[UIImage imageWithCGImage:[asset thumbnail]]];// ดึงรูป thumbnail มาใส่ในตัวแปร images
        NSLog(@"load image #%u",i);
        
    }
    
    NSUInteger i;
    NSLog(@"viewDidload");
    NSUInteger kNumImages = [_images count];
	for (i = 1; i <= kNumImages; i++)
	{  
        // NSString *imageName = [NSString stringWithFormat:@"img%d.jpg", i];
        //UIImage * image = [UIImage imageNamed:imageName];
        UIImage * image = [images objectAtIndex:(i-1)];
        UIImageView * imageView = [[UIImageView alloc] init];
        
        [imageView setFrame:CGRectMake(20,20+((i-1)*120) , image.size.width, image.size.height )];
        
        [imageView setImage:image withBorderWidth:2.0];
        [imageView setTag:i];    
        [self.scrollView addSubview:imageView];
        [imageView release];
        
	}
    [self layoutScrollImages:self.scrollView];
    return _images;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    [self setIconPerRow:2];
     assets = self.loadAssets;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.BackgroundColor = [UIColor blackColor];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 650)];
    [scrollView setContentSize:CGSizeMake(250, 1300)];
    [self.view addSubview:scrollView];
    scrollView.BackgroundColor = [UIColor brownColor];
    [scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.pagingEnabled = NO;
  	
    
    
   

}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {

    [super dealloc];
}
@end
