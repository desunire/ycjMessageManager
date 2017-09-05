//
//  SCJToolManager.m
//  messageManager
//
//  Created by desunire on 2017/9/4.
//  Copyright © 2017年 desunire. All rights reserved.
//

#import "SCJToolManager.h"

@implementation SCJToolManager

__strong static SCJToolManager * scjInstance = nil;


+(instancetype)setInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scjInstance = [[SCJToolManager alloc] init];
    });
    return scjInstance;
}


#pragma mark -- 计算宽窄的函数
-(float)autoCalculateWidthOrHeight:(float)height
                             width:(float)width
                          fontsize:(float)fontsize
                           content:(NSString*)content
{
    
    /**
     111:options：这个参数比较重要
     1.NSStringDrawingUsesLineFragmentOrigin：
     
     绘制文本时使用 line fragement origin 而不是 baseline origin。
     
     2.NSStringDrawingUsesFontLeading：
     
     计算行高时使用行距。（字体大小+行间距=行距）
     
     3.NSStringDrawingTruncatesLastVisibleLine：
     
     如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果没有指定NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
     
     4.计算布局时使用图元字形（而不是印刷字体）。
     
     Use the image glyph bounds (instead of the typographic bounds) when computing layout.
     
     222: attributes:文本属性，一个字典，里面包含了文字的各种属性，这里没细看，仅供参考
     
     1.NSKernAttributeName: @10 调整字句 kerning 字句调整
     2.NSFontAttributeName : [UIFont systemFontOfSize:_fontSize] 设置字体
     3.NSForegroundColorAttributeName :[UIColor redColor] 设置文字颜色
     4.NSParagraphStyleAttributeName : paragraph 设置段落样式
     
     5.NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
     paragraph.alignment = NSTextAlignmentCenter;
     6.NSBackgroundColorAttributeName: [UIColor blackColor] 设置背景颜色
     
     7.NSStrokeColorAttributeName设置文字描边颜色，需要和NSStrokeWidthAttributeName设置描边宽度，这样就能使文字空心.
     
     333:context：上下文。包括一些信息，例如如何调整字间距以及缩放。最终，该对象包含的信息将用于文本绘制。该参数可为 nil 。
     
     */
    
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    
    //判断计算的是宽还是高
    if (height == MAXFLOAT) {
        return rect.size.height;
    }
    else
        return rect.size.width;
}


//页面提示
-(void)showMessage:(NSString *)title{
    [SVProgressHUD showWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
