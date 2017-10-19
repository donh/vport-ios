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

#import "BaseView.h"

@implementation BaseView

//如何在子视图中获取父视图的ViewController
- (UIViewController *)viewController{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)widthForStr:(NSString *)string height:(CGFloat)height font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}


- (CGFloat)heightForStr:(NSString *)string width:(CGFloat)width font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
}

- (void)addTarget:(id)target selector:(SEL)selector
{
    self.target = target;
    self.action = selector;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
