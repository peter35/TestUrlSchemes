//
//  AdjustableUILable.h
//  Mine
//
//  Created by Ling on 13-9-27.
//
//
#import  <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface AdjustableUILable : UILabel
{
    CGFloat charSpace_;
    CGFloat lineSpace_;
}
@property(nonatomic, assign) CGFloat charSpace;
@property(nonatomic, assign) CGFloat lineSpace;

+(float)caculateHeight:(NSString*)text  fontName:(NSString*)fontName fontSize:(float)fontSize lineSpaceing:(float)lineSpaceing width:(float)width;

@end