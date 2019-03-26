//
//  ViewController.m
//  SlantLabel
//
//  Created by 王泽龙 on 2019/3/12.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) UILabel *tipsLabel1;
@property (strong, nonatomic) UILabel *aaL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 字符串正则匹配
    [self test];
    
    // label倾斜摆放
    [self test1];
    
    // attach
    [self test3];
}

#pragma mark -------------------- label attach -------------------------------
- (void)test3 {
    
    NSString *titleString = @"我是标题！我是标题！我是标！我是标题！";
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:titleString];
    //创建一个小标签的Label
    NSString *aa = @"我TM是个类似图片的标签";
    CGFloat aaW = 12*aa.length +6;
    UILabel *aaL = [UILabel new];
    aaL.frame = CGRectMake(0, 0, aaW*3, 16*3);
    aaL.text = aa;
    aaL.font = [UIFont boldSystemFontOfSize:12*3];
    aaL.textColor = [UIColor whiteColor];
    aaL.backgroundColor = [UIColor blueColor];
    aaL.textAlignment = NSTextAlignmentCenter;
    self.aaL = aaL;
    _aaL.layer.cornerRadius = 10;
    _aaL.layer.borderWidth = 2;
    _aaL.layer.borderColor = [UIColor redColor].CGColor;
    _aaL.layer.masksToBounds = YES;
    
    //调用方法，转化成Image
    UIImage *image = [self imageWithUIView:aaL];
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -10, aaW, 16); //这个-2.5是为了调整下标签跟文字的位置
    attach.image = image;
    //添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面

    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(60, 200, 250, 100);
    titleLabel.backgroundColor = [UIColor yellowColor];
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    titleLabel.attributedText = maTitleString;
    
}

//view转成image
- (UIImage*)imageWithUIView:(UIView*)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

#pragma mark -------------------- label倾斜摆放 -------------------------------
- (void)test1 {
    _backView.clipsToBounds = YES;
    _tipsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(-35, 10, 140, 30)];
    _tipsLabel1.font = [UIFont systemFontOfSize:20];
    _tipsLabel1.backgroundColor = [UIColor redColor];
    _tipsLabel1.textColor = [UIColor whiteColor];
    _tipsLabel1.text = @"新获得";
    [_backView addSubview:_tipsLabel1];
    _tipsLabel1.textAlignment = NSTextAlignmentCenter;
    _tipsLabel1.transform = CGAffineTransformMakeRotation(-M_PI_4);
    _tipsLabel1.adjustsFontSizeToFitWidth = YES;//文本自适应
    [_tipsLabel1 sizeToFit];
}

#pragma mark -------------------- 字符串正则匹配 -------------------------------
- (void)test {
    NSString *str0 = @"Y50";
    NSString *str1 = @"50个哈哈";
    NSString *str2 = @"50.1";
    NSString *str3 = @"50/2";
    NSString *str4 = @"50a3";
    NSString *str5 = @"50;4";
    NSString *str6 = @".504";
    NSString *str7 = @"aa504";
    NSString *str8 = @"cc50;aa50";
    NSString *str9 = @"50;4";
    NSString *str10 = @"8.5";
    NSString *str11 = @"8.";
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:str0];
    [arr addObject:str1];
    [arr addObject:str2];
    [arr addObject:str3];
    [arr addObject:str4];
    [arr addObject:str5];
    [arr addObject:str6];
    [arr addObject:str7];
    [arr addObject:str8];
    [arr addObject:str9];
    [arr addObject:str10];
    [arr addObject:str11];
    for (NSString *str  in arr) {
        //        NSArray *array = [self matchString:str toRegexString:@"[0-9]+\\.*[0-9]*"];
        NSArray *array = [self matchString:str toRegexString:@"[0-9]+([.]{1}[0-9]+){0,1}"];
        
        NSLog(@"%@", array);
    }
}

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分  这里会莫名其妙的遍历两次，导致输出两个
            if (i == 0) {
                NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
                [array addObject:component];
            }
        }
    }
    return array;
}

@end
