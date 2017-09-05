//
//  SCJChangeItemView.h
//  phoenix
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 desunire. All rights reserved.
//

#import <UIKit/UIKit.h>


//选中的颜色，没有选中的颜色，背景色的配置
#define chooseColor [UIColor colorWithRed:0.1803 green:0.2509 blue:0.6117 alpha:1]
#define defaultColor [UIColor grayColor]
#define backColor [UIColor whiteColor]

@class SCJChangeItemView;

@protocol SCJChangeItemViewDelegate <NSObject>

@optional

-(void)changeChooseItemInView:(SCJChangeItemView *)view andItem:(NSInteger)itemTag;

-(void)changeChooseItemInView:(SCJChangeItemView *)view andtitle:(NSInteger)titleTag;

@end

@interface SCJChangeItemView : UIView

@property(weak,nonatomic)id<SCJChangeItemViewDelegate>delegate;


/**
 快速创建对象
 @param itemArray item数组
 */
-(instancetype)initWithFrame:(CGRect)frame anditemArray:(NSArray *)itemArray;

-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;


//改变状态
-(void)changeStateWithTag:(NSInteger)tag;


@end
