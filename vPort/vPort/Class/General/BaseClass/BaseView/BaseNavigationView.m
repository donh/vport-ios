/*
 * Copyright (C) 2016-2016, The Little-Sparkle Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS-IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "BaseNavigationView.h"

@implementation BaseNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [self addSubview:self.statusView];
        self.statusView.backgroundColor = BaseBlueCOLOR;
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusView.frame.size.height + self.statusView.frame.origin.y, frame.size.width, frame.size.height - (self.statusView.frame.size.height + self.statusView.frame.origin.y))];
        [self addSubview:self.backgroundView];
        self.backgroundView.backgroundColor = BaseBlueCOLOR;
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.leftBtn];
        [self.leftBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
        self.leftBtn.frame = CGRectMake(2, 0, 30, 30);
        self.leftBtn.center = CGPointMake(self.leftBtn.center.x, self.backgroundView.frame.size.height / 2);
        
        self.titleLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(self.leftBtn.frame.size.width + self.leftBtn.frame.origin.x + 5, 0, frame.size.width - (self.leftBtn.frame.size.width + self.leftBtn.frame.origin.x + 5) * 2, 30)];
        [self.backgroundView addSubview:self.titleLabel];
        self.titleLabel.font = TitleFont;
        self.titleLabel.textColor = TitleColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.backgroundView.frame.size.height / 2);
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundView addSubview:self.rightBtn];
        self.rightBtn.frame = CGRectMake(frame.size.width - 30 - 5, 0, 30, 30);
        self.rightBtn.center = CGPointMake(self.rightBtn.center.x, self.backgroundView.frame.size.height / 2);
        self.rightBtn.hidden = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
