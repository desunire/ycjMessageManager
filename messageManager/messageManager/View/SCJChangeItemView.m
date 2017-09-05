//
//  SCJChangeItemView.m
//  phoenix
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 desunire. All rights reserved.
//

#import "SCJChangeItemView.h"

@implementation SCJChangeItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame anditemArray:(NSArray *)itemArray{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=backColor;
        for (int i=0; i<itemArray.count; i++) {
            UIView *backView=[[UIView alloc]init];
            backView.userInteractionEnabled=YES;
            backView.tag=1000+i;
            backView.backgroundColor=backColor;
            backView.frame=CGRectMake(SCREEN_WIDTH/itemArray.count*i, 0, SCREEN_WIDTH/itemArray.count, frame.size.height);
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=backColor;
            [btn setTitleColor:defaultColor forState:UIControlStateNormal];
            [btn setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
            btn.tag=1000+i;
            btn.titleLabel.font=[UIFont systemFontOfSize:16.0];
            [btn addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(0, 0, SCREEN_WIDTH/itemArray.count, frame.size.height-2);
            UILabel *label=[[UILabel alloc]init];
            if (i==0) {
               label.backgroundColor=chooseColor;
            }
            else{
                label.backgroundColor=backColor;
            }
            label.frame=CGRectMake(20, frame.size.height-1, SCREEN_WIDTH/itemArray.count-40, 2);
            [self addSubview:backView];
            [backView addSubview:btn];
            [backView addSubview:label];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray{
    
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=backColor;
        for (int i=0; i<titleArray.count; i++) {
            UIView *backView=[[UIView alloc]init];
            backView.userInteractionEnabled=YES;
            backView.tag=1000+i;
            backView.backgroundColor=backColor;
            backView.frame=CGRectMake(SCREEN_WIDTH/titleArray.count*i, 0, SCREEN_WIDTH/titleArray.count, frame.size.height);
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=backColor;
            if (i==0) {
                [btn setTitleColor:UIColorFromRGB(0xff9000) forState:UIControlStateNormal];
            }
            else{
            [btn setTitleColor:chooseColor forState:UIControlStateNormal];
            }
            [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            btn.tag=1000+i;
            btn.titleLabel.font=[UIFont systemFontOfSize:14.0];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(0, 0, SCREEN_WIDTH/titleArray.count, frame.size.height-2);
            [self addSubview:backView];
            [backView addSubview:btn];
        }
    }
    return self;
    
}

-(void)btnClick:(UIButton*)sender{
    //改变UI
    for (UIView *backView in self.subviews) {
            for (UIView *btnView in backView.subviews) {
                    if ([btnView isKindOfClass:[UIButton class]]) {
                    UIButton *btn=(UIButton *)btnView;
                    [btn setTitleColor:chooseColor forState:UIControlStateNormal];
                }
            }
    }
    
    [sender setTitleColor:UIColorFromRGB(0xff9000) forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(changeChooseItemInView:andtitle:)]) {
        [self.delegate changeChooseItemInView:self andtitle:sender.tag-1000];
    }
}

-(void)viewClick:(UIButton *)sender{
    //改变UI
    for (UIView *backView in self.subviews) {
        for (UIView *subView in backView.subviews) {
            subView.backgroundColor=backColor;
            if ([subView isKindOfClass:[UIButton class]]){
                [(UIButton *)subView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    for (UIView *backView in self.subviews) {
        if (backView.tag==sender.tag) {
            for (UIView *subView in sender.superview.subviews) {
                if ([subView isKindOfClass:[UILabel class]]){
                    subView.backgroundColor=chooseColor;
                }
                if ([subView isKindOfClass:[UIButton class]]){
                    [(UIButton *)subView setTitleColor:chooseColor forState:UIControlStateNormal];
                }
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(changeChooseItemInView:andItem:)]) {
        [self.delegate changeChooseItemInView:self andItem:sender.tag-1000];
    }
}

-(void)changeStateWithTag:(NSInteger)tag{
    //改变UI
    for (UIView *backView in self.subviews) {
        for (UIView *subView in backView.subviews) {
            subView.backgroundColor=backColor;
            if ([subView isKindOfClass:[UIButton class]]){
                [(UIButton *)subView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    for (UIView *backView in self.subviews) {
        if (backView.tag==tag) {
            for (UIView *subView in backView.subviews) {
                if ([subView isKindOfClass:[UILabel class]]){
                    subView.backgroundColor=chooseColor;
                }
                if ([subView isKindOfClass:[UIButton class]]){
                    [(UIButton *)subView setTitleColor:chooseColor forState:UIControlStateNormal];
                }
            }
        }
    }
    
}
@end
