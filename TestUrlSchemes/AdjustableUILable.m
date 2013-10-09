//
//  AdjustableUILable.m
//  Mine
//
//  Created by Ling on 13-9-27.
//
//

#import "AdjustableUILable.h"
#import <CoreText/CoreText.h>
#import<Foundation/Foundation.h>

@implementation AdjustableUILable

@synthesize lineSpace = lineSpace_;
@synthesize charSpace = charSpace_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineSpace_ = 5.0;
        charSpace_ = 2.0;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    lineSpace_ = 5.0;
    charSpace_ = 2.0;
}

-(void)setCharSpace:(CGFloat)charSpace{
    charSpace_ = charSpace;
    [self setNeedsDisplay];
}
-(void)setLineSpace:(CGFloat)lineSpace{
    lineSpace_ = lineSpace;
    [self setNeedsDisplay];
}

-(void) drawTextInRect:(CGRect)requestedRect
{
    
    //创建AttributeString
    
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:self.text];
    
    //设置字体及大小
    
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
    
    [string addAttribute:(id)kCTFontAttributeName value:(id)helveticaBold range:NSMakeRange(0,[string length])];
    
    //设置字间距
    
    if(self.charSpace)
        
    {
        long number = self.charSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [string addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0,[string length])];
        CFRelease(num);
    }
    
    //设置字体颜色
    
    [string addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[string length])];
    
    //创建文本对齐方式
    
    CTTextAlignment alignment = kCTLeftTextAlignment;
    
    if(self.textAlignment == UITextAlignmentCenter)
        
    {
        alignment = kCTCenterTextAlignment;
        
    }
    
    if(self.textAlignment == UITextAlignmentRight)
        
    {
        
        alignment = kCTRightTextAlignment;
        
    }
    
    CTParagraphStyleSetting alignmentStyle;
    
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    alignmentStyle.valueSize = sizeof(alignment);
    
    alignmentStyle.value = &alignment;
    
    //设置文本行间距
    
    CGFloat lineSpace = self.lineSpace;
    
    CTParagraphStyleSetting lineSpaceStyle;
    
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    
    lineSpaceStyle.value =&lineSpace;
    
    //设置文本段间距
    
    CGFloat paragraphSpacing = 5.0;
    
    CTParagraphStyleSetting paragraphSpaceStyle;
    
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    
    paragraphSpaceStyle.value = &paragraphSpacing;
    
    
    
    //创建设置数组
    
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
    
    //给文本添加设置
    
    [string addAttribute:(id)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0 , [string length])];
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    CFRelease(helveticaBold);
    
    [string release];
    
    UIGraphicsPushContext(context);
}

+(float)caculateHeight:(NSString*)text  fontName:(NSString*)fontName fontSize:(float)fontSize lineSpaceing:(float)lineSpaceing width:(float)width
{
    float lineHeight = fontSize+lineSpaceing; //行高
    
    BOOL drawFlag = YES;//是否绘制
    
    int lineCount = 0;//行数
    
    CFIndex currentIndex = 0;//绘制计数
    
    NSMutableAttributedString* attrString = [AdjustableUILable getAttributedText:text fontName:fontName fontSize:fontSize lineSpaceing:lineSpaceing width:width];
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    while(drawFlag)
        
    {
        
        CFIndex lineLength = CTTypesetterSuggestLineBreak(typeSetter,currentIndex,width);
        
        CFRange lineRange = CFRangeMake(currentIndex,lineLength);
        
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        
        if(currentIndex + lineLength >= [attrString length]){
            
            drawFlag = NO;
            
        }
        
        CFRelease(line);
        
        lineCount++;
        
        currentIndex += lineLength;
        
    }
    Airsource_Log_Debug(@"lineHeight = %f",lineHeight);
    Airsource_Log_Debug(@"lineCount = %d",lineCount);
    CFRelease(typeSetter);
    return lineHeight * lineCount;
}
+(NSMutableAttributedString*)getAttributedText:(NSString*)text  fontName:(NSString*)fontName fontSize:(float)fontSize lineSpaceing:(float)lineSpaceing width:(float)width
{
    
    NSMutableAttributedString *tmpAttributedText = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    
    //    [tmpAttributedText addAttribute:(NSString*)(kCTForegroundColorAttributeName) value:(id)[[UIColor blueColor]CGColor] range:NSMakeRange(0,5)];
    //
    //    [tmpAttributedText addAttribute:(NSString*)(kCTForegroundColorAttributeName) value:(id)[[UIColor redColor]CGColor] range:NSMakeRange(6,5)];
    
    CTFontRef  font_hello = CTFontCreateWithName((CFStringRef)fontName, fontSize,NULL);
    
    //    CTFontRef  font_world = CTFontCreateWithName((CFStringRef)@"GillSans",20,NULL);
    
    [tmpAttributedText addAttribute: (NSString*)(kCTFontAttributeName) value:(id)font_hello range:NSMakeRange(0,[text length])];
    
    //    [tmpAttributedText addAttribute: (NSString*)(kCTFontAttributeName) value:(id)font_world range:NSMakeRange(6,5)];
    
    /*
     CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//换行模式
     
     CTTextAlignment alignment = kCTLeftTextAlignment;//对齐方式
     
     float lineSpacing =2.0;//行间距
     
     CTParagraphStyleSetting paraStyles[3] = {
     
     {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
     
     {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
     
     {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
     
     };
     
     CTParagraphStyleRef style = CTParagraphStyleCreate(paraStyles,3);
     
     [tmpAttributedText addAttribute:(NSString*)(kCTParagraphStyleAttributeName) value:(id)style range:NSMakeRange(0,[text length])];
     
     CFRelease(style);
     */
    
    CGFloat widthValue = -1.0;
    
    CFNumberRef strokeWidth = CFNumberCreate(NULL,kCFNumberFloatType,&widthValue);
    
    [tmpAttributedText addAttribute:(NSString*)(kCTStrokeWidthAttributeName) value:(id)strokeWidth range:NSMakeRange(0,[text length])];
    
    [tmpAttributedText addAttribute:(NSString*)(kCTStrokeColorAttributeName) value:(id)[[UIColor whiteColor]CGColor] range:NSMakeRange(0,[text length])];
    
    
    return tmpAttributedText;
}



@end