//
//  RootViewController.m
//  TestUrlSchemes
//
//  Created by Peter on 13-9-30.
//  Copyright (c) 2013年 Peter. All rights reserved.
//

#import "RootViewController.h"
#import <CoreText/CoreText.h>

#define kRecord  @"kRecord"
@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.inputTextField setDelegate:self];
    [self.inputTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.inputTextField setPlaceholder:@"第三方app可打开测试"];
    [self.inputTextField setReturnKeyType:UIReturnKeyDone];
    
    [self.recordTextView setEditable:NO];
    [self.recordTextView setText:[self getRecord]];
    [self.recordTextView setBackgroundColor:[UIColor clearColor]];

    
    
    //6.0 以上版本有效
    
    NSString *textToAdd = @"提示：\"行为连接\"一般为app名字或app公司名字或公司名＋产品名，请在上面的输入框直接输入，进行\"行为连接\"可用性测试。注意前提是你的设备已下载你要测试的app。用iTools备份app,ipa格式改为zip格式，打开文件会看到里面plist格式文件，相关的url信息在里面。另分号后面是可不填的。示例：\r支付宝:alipay:\n淘宝:taobao://\n\"下载连接\"为appStore下载连接，可直接在iTunes搜到该app,拖动app的icon,实际上就是拖动其下载连接，比如拖动到浏览器地址栏。";
    
    
    NSLog(@"%@",textToAdd);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textToAdd];
    
    NSLog(@"%@",attrString);
    NSLog(@"%d",attrString.length);
    
    
    NSMutableParagraphStyle * mps =[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    mps.lineSpacing = 5.0;
    mps.paragraphSpacing = 10.0;
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:(NSParagraphStyle *)mps
                       range:NSMakeRange( 0, [attrString length])];//行间距
    
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange( 0, [attrString length])];//字号
    

    [attrString addAttribute:NSKernAttributeName
                                        value:[NSNumber numberWithFloat:2.0]
                                    range:NSMakeRange(0, attrString.length)];//字间距
    
    [attrString addAttribute:NSKernAttributeName
                       value:[NSNumber numberWithFloat:10.0]
                       range:NSMakeRange(attrString.length-20, 20)];
    
    // make red text
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(0, 3)];//红色
    
    // make blue text
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blueColor]
                       range:NSMakeRange(21, 4)];//蓝色
    
    [attrString addAttribute:NSUnderlineStyleAttributeName
                       value:[NSNumber numberWithInteger:1]
                       range:NSMakeRange(21, 4)];//下划线
    
    [self.tipsTextView setAttributedText:attrString];
    

    /*
    
    
    UILabel * label = [[UILabel alloc]init];
    [label setFrame:CGRectMake(0, 20, 160, 60)];
    [self.view addSubview:label];
    [label setNumberOfLines:0];
    NSString * textToAdd1 = @"test、哈哈zhe  ddniD";
    
    NSLog(@"%@",textToAdd1);
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:textToAdd1];

    
    NSLog(@"%d  %@",__LINE__,attrString1);


    
    NSMutableParagraphStyle * mps1 =[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    mps1.lineSpacing = 5.0;
    mps1.paragraphSpacing = 10.0;
    [attrString1 addAttribute:NSParagraphStyleAttributeName
                       value:(NSParagraphStyle *)mps1
                       range:NSMakeRange( 0, [attrString1 length])];//行间距
    
    [attrString1 addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange( 0, [attrString1 length])];//字号
    
    [attrString1 addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(0, 3)];//红色
    NSLog(@"%d  %@",__LINE__,attrString1);

    [label setAttributedText:attrString1];
     //*/
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.recordTextView setText:[self getRecord]];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)openTheApp:(id)sender {
    
    NSString * info = self.inputTextField.text;
    
    NSURL * url = [NSURL URLWithString:info];

    if (info.length == 0) {
        self.tipsLabel.text = @"空";
    }else{
        if(![[UIApplication sharedApplication] canOpenURL:url]){
            self.tipsLabel.text = @"不能打开";
        }else{
            self.tipsLabel.text= @"有效";
        }
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){

        [[UIApplication sharedApplication] openURL:url];
        
        [self saveRecordWithInput:self.inputTextField.text];
        [self.recordTextView setText:[self getRecord]];
        NSLog(@"%@",self.recordTextView.text);

    }


}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * info = self.inputTextField.text;
    NSURL * url = [NSURL URLWithString:info];

    if (info.length == 0) {
        self.tipsLabel.text = @"空";
    }else{
        if(![[UIApplication sharedApplication] canOpenURL:url]){
        self.tipsLabel.text = @"不能打开";
        }else{
            self.tipsLabel.text= @"有效";
        }
    }
        
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)saveRecordWithInput:(NSString *)str{
    NSLog(@"%@",str);
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString * curRecord = [ud objectForKey:kRecord];
    if ([curRecord isEqual:[NSNull null]] || curRecord == nil) {
        curRecord = @"历史纪录:\n";
    }
    NSLog(@"%@",curRecord);
    [ud setObject:[curRecord stringByAppendingFormat:@"%@\n",str] forKey:kRecord];
    [ud synchronize];
}

-(NSString *)getRecord{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[ud objectForKey:kRecord]);
    return [ud objectForKey:kRecord];
}

- (IBAction)help:(id)sender {
    
//    http://www.cnblogs.com/gushuo/archive/2011/05/04/2036447.html
    
    NSString * str = @"http://blog.csdn.net/yhawaii/article/details/7587355";
    NSURL * url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (IBAction)yuanli:(id)sender {
    NSString * str = @"http://developer.apple.com/library/ios/#documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/AdvancedAppTricks/AdvancedAppTricks.html";
    NSURL * url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (IBAction)wiki:(id)sender {
    NSString * str = @"http://wiki.akosma.com/IPhone_URL_Schemes";
    NSURL * url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}
@end
