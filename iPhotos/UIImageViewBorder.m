#import "UIImageViewBorder.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIImageView (ImageViewBorder)

-(void)configureImageViewBorder:(CGFloat)borderWidth{
    CALayer* layer = [self layer];
    [layer setBorderWidth:borderWidth];
    [self setContentMode:UIViewContentModeCenter];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
    [layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    [layer setShadowRadius:3.0];
    [layer setShadowOpacity:1.0];
}

-(UIImage*)rescaleImage:(UIImage*)image{
    UIImage* scaledImage = image;
    
    CALayer* layer = self.layer;
    CGFloat borderWidth = layer.borderWidth;
    
    //if border is defined 
    if (borderWidth > 0)
    {
        //rectangle in which we want to draw the image.
        CGRect imageRect = CGRectMake(0.0, 0.0, self.bounds.size.width - 2 * borderWidth,self.bounds.size.height - 2 * borderWidth);
        //Only draw image if its size is bigger than the image rect size.
        if (image.size.width > imageRect.size.width || image.size.height > imageRect.size.height)
        {
            UIGraphicsBeginImageContext(imageRect.size);
            [image drawInRect:imageRect];
            scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }        
    }
    return scaledImage;
}

-(void)setImage:(UIImage*)image withBorderWidth:(CGFloat)borderWidth{
    [self configureImageViewBorder:borderWidth];
    UIImage* scaledImage = [self rescaleImage:image];
    self.image = scaledImage;
}
@end


