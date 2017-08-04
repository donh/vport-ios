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

#import "BaseVC.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RegsiterViewController.h"

@interface BaseVC () <UIGestureRecognizerDelegate>


@end

@implementation BaseVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //如果是根视图，关闭根视图侧滑返回功能，否则打开
    if ([self isKindOfClass:[HomeViewController class]] || [self isKindOfClass:[RegsiterViewController class]]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

/** 控制器销毁 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//获取用车时刻时间戳
- (NSString *)getTimer
{
    NSString *userCarDateStr;
    NSDate *nowDate = [NSDate date];
    userCarDateStr = [NSString stringWithFormat:@"%.0ld",(long)[nowDate timeIntervalSince1970]];
    return userCarDateStr;
}

#pragma  mark —— 修改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
//  return UIStatusBarStyleDefault;
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
