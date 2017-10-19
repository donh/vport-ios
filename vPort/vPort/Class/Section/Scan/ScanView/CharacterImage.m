//
//  CharacterImage.m
//  vPort
//
//  Created by MengFanJun on 2017/7/5.
//  Copyright © 2017年 MengFanJun. All rights reserved.
//

#import "CharacterImage.h"

@implementation CharacterImage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor R:253 G:194 B:68];

        self.characterLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.characterLabel.textAlignment = NSTextAlignmentCenter;
        self.characterLabel.font = [UIFont systemFontOfSize:30];
        self.characterLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.characterLabel];
    }
    return self;
}

- (void)setCharacterStr:(NSString *)characterStr
{
    _characterStr = [characterStr copy];
    if (characterStr.length > 0) {
        self.characterLabel.text = [characterStr substringToIndex:1];
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
