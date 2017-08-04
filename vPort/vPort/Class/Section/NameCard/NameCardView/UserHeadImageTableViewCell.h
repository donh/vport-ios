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

#import <UIKit/UIKit.h>

@interface UserHeadImageTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseLabel *titleLabel;//标题
@property (nonatomic, strong) UIImageView *headImage;//头像图片
@property (nonatomic, strong) UIImageView *moreImage;//更多
@property (nonatomic, strong) UIView *line;//细线

@end
