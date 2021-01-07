//
//  HMShareView.m
//  Molester
//
//  Created by 高欣 on 2018/8/16.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "HMShareView.h"

#define BottomBtnHeight 44
#define ShareViewHeight 100

static NSString * const HMShareCellIdentifi  = @"HMShareCellIdentifi";

@protocol HMShareCollectionViewCellDelegate <NSObject>

- (void)itemBtnClick:(UIButton *)sender;

@end


@interface HMShareCollectionViewCell :UICollectionViewCell

@property (nonatomic,strong) UIButton *itemBtn;

@property (nonatomic,weak) id<HMShareCollectionViewCellDelegate> delegate;


@end

@implementation HMShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.itemBtn];
        [self.itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageW = self.itemBtn.imageView.frame.size.width;
    CGFloat imageH = self.itemBtn.imageView.frame.size.height;
    
    CGFloat titleW = self.itemBtn.titleLabel.frame.size.width;
    CGFloat titleH = self.itemBtn.titleLabel.frame.size.height;
    
    //图片上文字下
    [self.itemBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
    [self.itemBtn setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 0.f, 0.f,-titleW)];
    
}

- (void)itemBtnClick:(UIButton *)sender
{
    [self.delegate itemBtnClick:sender];
}

- (UIButton *)itemBtn
{
    if (_itemBtn == nil) {
        _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [_itemBtn setTitleColor:[UIColor colorWithRed:51.0026/255.0 green:51.0026/255.0 blue:51.0026/255.0 alpha:1] forState:UIControlStateNormal];
        [_itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemBtn;
}

@end



@interface HMShareView()<UICollectionViewDelegate,UICollectionViewDataSource,HMShareCollectionViewCellDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UICollectionView *shareView;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) NSArray *shareArr;

@end


@implementation HMShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareinfo" ofType:@"plist"]];
        self.bounds = CGRectMake(0, 0,kScreenWidth , kScreenHeight);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgClick)]];
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];

    //取消按钮
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.shareView];
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:237.996/255.0 green:237.996/255.0 blue:237.996/255.0 alpha:1];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cancelBtn);
        make.height.mas_equalTo(1);
    }];
    
    
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, BottomBtnHeight + ShareViewHeight);
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.cancelBtn.mas_top);
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(44);
        make.left.right.equalTo(self.contentView);
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shareArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMShareCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HMShareCellIdentifi forIndexPath:indexPath ];
    cell.itemBtn.tag = [self.shareArr[indexPath.item][@"ID"] integerValue];
    [cell.itemBtn setTitle:self.shareArr[indexPath.item][@"title"] forState:UIControlStateNormal];
    [cell.itemBtn setImage:[UIImage imageNamed:self.shareArr[indexPath.item][@"img"]] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (void)itemBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:
            NSLog(@"微信");
            break;
        case 1002:
            NSLog(@"朋友圈");
            break;
        case 1003:
            NSLog(@"店铺二维码");
            break;
        default:
            break;
    }
}

/**
 取消按钮的点击事件
 */
- (void)cancelAction
{
    [self bgClick];
}



/**
 背景消除方法
 */
- (void)bgClick
{
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.contentView.frame = CGRectMake(self.contentView.mj_x, self.mj_h, self.contentView.mj_w, self.contentView.mj_h);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        @strongify(self);
//        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}


- (void)show
{
    self.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        self.contentView.frame = CGRectMake(self.contentView.mj_x, self.mj_h - self.contentView.mj_h - SafeAreaBarIncreaseHeight, self.contentView.mj_w, self.contentView.mj_h);
    }];
}

- (UICollectionView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _shareView.delegate = self;
        _shareView.dataSource = self;
        _shareView.userInteractionEnabled = YES;
        _shareView.backgroundColor = [UIColor whiteColor];
        [_shareView registerClass:[HMShareCollectionViewCell class] forCellWithReuseIdentifier:HMShareCellIdentifi];
    }
    return _shareView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(kScreenWidth/3, ShareViewHeight);
    }
    return _layout;
}

- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:51.0026/255.0 green:51.0026/255.0 blue:51.0026/255.0 alpha:1]forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
