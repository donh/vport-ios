//
//  IdentityInformationHeadView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/19.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "IdentityInformationHeadView.h"

@implementation IdentityInformationHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackgroundColor;

        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 5)];
        [self addSubview:self.backgroundImage];
        self.backgroundImage.contentMode = UIViewContentModeScaleToFill;

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.backgroundColor = [UIColor colorWithHexString:@"61b3ef" alpha:0.2];
        visualView.alpha = 0.8;
        visualView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 5);
        [self addSubview:visualView];
        
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 80 / 2, 55, 80, 80)];
        self.headImage.layer.cornerRadius = 80 / 2;
        self.headImage.layer.masksToBounds = YES;
        [self addSubview:self.headImage];
        
        self.nameLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(10, self.headImage.frame.origin.y + self.headImage.frame.size.height + 20, frame.size.width - 20, 16)];
        [self addSubview:self.nameLabel];
//        self.nameLabel.text = @"LONCIN";
        self.nameLabel.textColor = [UIColor colorWithHexString:@"f2f3f6" alpha:1];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.text = [UserDefaults objectForKey:@"nickName"];
        
//        self.headImage.image = [UIImage imageNamed:@"userHeadImage"];
//        self.backgroundImage.image = [self handleImage:[UIImage imageNamed:@"userHeadImage"]];
        
        NSString *headImageUrl = headImageUrl = [UserDefaults objectForKey:@"userImageUrl"];
        if (!headImageUrl) {
            headImageUrl = @"";
        }
        headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",headImageUrl];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"userHeadImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                image = [UIImage imageNamed:@"userHeadImage"];
            }
            self.backgroundImage.image = [self handleImage:image];
        }];

    }
    return self;
}

- (UIImage *)handleImage:(UIImage *)originalImage
{
    CGSize originalsize = [originalImage size];
    CGSize size = CGSizeMake(originalsize.width / 4 * 3, originalsize.width / 4 * 3 * 0.75);
    CGImageRef imageRef = nil;
    imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width / 8 * originalImage.scale, originalsize.height / 4 * originalImage.scale, originalsize.width / 4 * 3 * originalImage.scale, originalsize.width / 4 * 3 * originalImage.scale * 0.75));//获取图片整体部分

    UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(con, 0.0, size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
    UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//    NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    return standardImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
