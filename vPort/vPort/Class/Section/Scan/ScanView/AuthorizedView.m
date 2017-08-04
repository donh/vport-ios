//
//  AuthorizedView.m
//  vPort
//
//  Created by MengFanJun on 2017/6/27.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "AuthorizedView.h"
#import "AuthorizedIdentityCardView.h"
#import "CharacterImage.h"
@interface AuthorizedView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *topCancelBtn;
@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *changeImage;
//@property (nonatomic, strong) UIImageView *targetLogoImage;
@property (nonatomic, strong) BaseLabel *contentLabel;
@property (nonatomic, strong) AuthorizedIdentityCardView *identityCardView;
@property (nonatomic, strong) UIButton *bottomCancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) CharacterImage *targetLogoImage;

@end

@implementation AuthorizedView


- (instancetype)initWithDelegate:(id)delegate
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.delegate = delegate;
        
        self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:self.blackView];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 64 + 5, WIDTH - 10, 400 * HEIGHT / 667)];
        [self addSubview:self.backgroundView];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.center = CGPointMake(WIDTH / 2, HEIGHT / 2);
        
        self.titleLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(10, 5, self.backgroundView.frame.size.width - 20, 48)];
        [self.backgroundView addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
//        self.titleLabel.text = @"授权";
        
        self.topCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.topCancelBtn];
        self.topCancelBtn.frame = CGRectMake(self.backgroundView.frame.size.width - 35 , 0, 20, 20);
        [self.topCancelBtn setImage:[UIImage imageNamed:@"cancelImage"] forState:UIControlStateNormal];
        self.topCancelBtn.center = CGPointMake(self.topCancelBtn.center.x, self.titleLabel.center.y);
        [self.topCancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(15, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 5, self.backgroundView.frame.size.width - 30, 0.5)];
        [self.backgroundView addSubview:self.line1];
        self.line1.backgroundColor = LINECOLOR;
        
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, self.line1.frame.size.height + self.line1.frame.origin.y + 40 * HEIGHT / 667, 80, 80)];
        [self.backgroundView addSubview:self.headImage];
        NSString *headImageUrl = headImageUrl = [UserDefaults objectForKey:@"userImageUrl"];
        if (!headImageUrl) {
            headImageUrl = @"";
        }
        headImageUrl = [NSString stringWithFormat:@"http://58.83.219.152:8080%@",headImageUrl];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"userHeadImage"]];
        self.headImage.layer.cornerRadius = 40;
        self.headImage.layer.masksToBounds = YES;
        
        self.changeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 10)];
        [self.backgroundView addSubview:self.changeImage];
        self.changeImage.image = [UIImage imageNamed:@"authorizedImage"];
        self.changeImage.center = CGPointMake(self.backgroundView.frame.size.width / 2, self.headImage.center.y);
        
        self.targetLogoImage = [[CharacterImage alloc] initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 40 - 80, self.headImage.frame.origin.y, 80, 80)];
        [self.backgroundView addSubview:self.targetLogoImage];
//        self.targetLogoImage.image = [UIImage imageNamed:@"targetLogoImage"];
        self.targetLogoImage.layer.cornerRadius = 40;
        self.targetLogoImage.layer.masksToBounds = YES;
        
        self.contentLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(10, self.targetLogoImage.frame.size.height + self.targetLogoImage.frame.origin.y + 40 * HEIGHT / 667, self.backgroundView.frame.size.width - 20, 14)];
        [self.backgroundView addSubview:self.contentLabel];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];
//        self.contentLabel.text = @"A应用    请求授权使用";
        
        self.identityCardView = [[AuthorizedIdentityCardView alloc] initWithFrame:CGRectMake(35 * WIDTH / 375, self.contentLabel.frame.size.height + self.contentLabel.frame.origin.y + 25 * HEIGHT / 667, self.backgroundView.frame.size.width - (35 * WIDTH / 375) * 2, 40)];
        [self.backgroundView addSubview:self.identityCardView];
        
        self.bottomCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.bottomCancelBtn];
        self.bottomCancelBtn.frame = CGRectMake(35 * WIDTH / 375, self.identityCardView.frame.origin.y + self.identityCardView.frame.size.height + (self.backgroundView.frame.size.height - self.identityCardView.frame.origin.y - self.identityCardView.frame.size.height) / 2 - 22 * HEIGHT / 667, 113 * WIDTH / 375, 44 * HEIGHT / 667);
        self.bottomCancelBtn.layer.cornerRadius = 4;
        self.bottomCancelBtn.layer.masksToBounds = YES;
        self.bottomCancelBtn.backgroundColor = [UIColor colorWithHexString:@"c2c2c2" alpha:1];
        self.bottomCancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.bottomCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.bottomCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bottomCancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.sureBtn];
        self.sureBtn.frame = CGRectMake(self.backgroundView.frame.size.width -  (35 + 113) * WIDTH / 375, self.bottomCancelBtn.frame.origin.y, 113 * WIDTH / 375, 44 * HEIGHT / 667);
        self.sureBtn.layer.cornerRadius = 4;
        self.sureBtn.layer.masksToBounds = YES;
        self.sureBtn.backgroundColor = BaseBlueCOLOR;
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.sureBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

//显示
- (void)show
{
    [UIView animateWithDuration:0.1 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.blackView.alpha = 0.5;
    }];
}

//隐藏
- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//取消
- (void)cancelBtnClicked
{
    [UIView animateWithDuration:0.1 animations:^{
        self.blackView.alpha = 0;
        if ([self.delegate respondsToSelector:@selector(authorizedView:clickedButtonAtIndex:)]) {
            [self.delegate authorizedView:self clickedButtonAtIndex:0];
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//登录
- (void)sureBtnClicked
{
    [UIView animateWithDuration:0.1 animations:^{
        self.blackView.alpha = 0;
        if ([self.delegate respondsToSelector:@selector(authorizedView:clickedButtonAtIndex:)]) {
            [self.delegate authorizedView:self clickedButtonAtIndex:1];
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setTypeStr:(NSString *)typeStr
{
    _typeStr = [typeStr copy];
    self.titleLabel.text = typeStr;
    [self.sureBtn setTitle:typeStr forState:UIControlStateNormal];
}

- (void)setWebNameStr:(NSString *)webNameStr
{
    _webNameStr = [webNameStr copy];
    self.contentLabel.text = webNameStr;
    
    if (webNameStr.length != 0 || ![webNameStr isEqualToString:@"(null)"]) {
        self.contentLabel.text = [NSString stringWithFormat:@"请确认是否%@：%@",self.typeStr,webNameStr];
        self.targetLogoImage.characterStr = webNameStr;
    }
    else
    {
        self.contentLabel.text = @"";
        self.targetLogoImage.characterStr = @"";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
