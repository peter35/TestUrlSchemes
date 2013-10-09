//
//  RootViewController.h
//  TestUrlSchemes
//
//  Created by Peter on 13-9-30.
//  Copyright (c) 2013年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UITextView *tipsTextView;
- (IBAction)openTheApp:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *recordTextView;
- (IBAction)help:(id)sender;
- (IBAction)yuanli:(id)sender;
- (IBAction)wiki:(id)sender;

@end
