//
//  DFPopMenu.m
//  DFPopupMenu
//
//  Created by Davon_Feng on 15/12/13.
//  Copyright © 2015年 Davon_Feng. All rights reserved.
//

#import "DFPopMenu.h"

static DFPopMenu *popMenu;

@implementation DFPopMenu {
    DFPopMenuView *_popMenuView;
}
+ (instancetype)shareDFPopMenu {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popMenu = [[DFPopMenu alloc] init];
    });
    return popMenu;
}

- (void)showDFMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(DFPopMenuDidSelectedBlock)block {
    if (_popMenuView) {
        [_popMenuView dismissDFMenu:NO];
        _popMenuView = nil;
    }
    _popMenuView = [[DFPopMenuView alloc] init];
    [_popMenuView showDFMenuWithTargetFrame:targetFrame WithItemNameArray:itemNameArray withSelectedBlock:block];
}

- (void)dismissDFMenu:(BOOL)animated {
    [_popMenuView dismissDFMenu:animated];
}
@end

@interface DFPopMenuView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *menuContainerView;
@property(nonatomic, strong) UITableView *menuTableView;
@property(nonatomic, assign) CGRect targetFrame;
@end

static const int DFMenuItemsHeight = 35;
static const int DFMenuItemsWidth = 50;
static const int DFMenuTableViewHSpace = 5;
static const int DFMenuTableViewVSpace = 5;
static const int arrowHeight = 5;

@implementation DFPopMenuView {
    NSMutableArray *_menuItems;
    UIView *_superView;
    CGFloat menuTableViewHeight;
}

- (id)init {
    if (self = [super init]) {
        _superView = [[UIApplication sharedApplication] keyWindow];
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {
        menuTableViewHeight = DFMenuItemsHeight * _menuItems.count + DFMenuTableViewVSpace;

        CGFloat x = CGRectGetMidX(_targetFrame) - 30;
        CGFloat y = CGRectGetMinY(_targetFrame) - menuTableViewHeight - arrowHeight;
        CGFloat width = DFMenuItemsWidth + DFMenuTableViewHSpace * 2;
        CGFloat height = menuTableViewHeight + arrowHeight;

        _menuContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];

        _menuContainerView.image = [[UIImage imageNamed:@"publicSessionMenu.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5) resizingMode:UIImageResizingModeStretch];
        _menuContainerView.userInteractionEnabled = YES;
        _menuContainerView.layer.cornerRadius = 5.0f;
        _menuContainerView.clipsToBounds = YES;

        [_menuContainerView addSubview:self.menuTableView];
    }
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_menuContainerView.frame), menuTableViewHeight) style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.rowHeight = DFMenuItemsHeight;
        _menuTableView.dataSource = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.scrollEnabled = NO;
    }
    return _menuTableView;
}

- (void)showDFMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(DFPopMenuDidSelectedBlock)block {
    _menuItems = itemNameArray.mutableCopy;
    _targetFrame = targetFrame;
    _popMenuDidSelectedBlock = block;
    [self addSubview:self.menuContainerView];
    _menuContainerView.alpha = 0;

    CGRect toFrame = _menuContainerView.frame;
    _menuContainerView.frame = CGRectMake(CGRectGetMinX(_menuContainerView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerView.frame), 1);
    [_superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _menuContainerView.alpha = 1;
        _menuContainerView.frame = toFrame;
    }];
}

- (void)dismissDFMenu:(BOOL)animated {
    if (_superView) {
        if (animated) {
            CGRect toFrame = CGRectMake(CGRectGetMinX(_menuContainerView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerView.frame), 1);
            [UIView animateWithDuration:0.3 animations:^{
                _menuContainerView.alpha = 0;
                _menuContainerView.frame = toFrame;
            }                completion:^(BOOL finish) {
                [self removeFromSuperview];
            }];
        } else {
            [self removeFromSuperview];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dismissDFMenu:YES];
    }
}

#pragma mark tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFPopMenuTableCell *cell = (DFPopMenuTableCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) cell = [[DFPopMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    cell.dFTextLabel.font = [UIFont systemFontOfSize:12];
    cell.dFTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.dFTextLabel.text = _menuItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _popMenuDidSelectedBlock(indexPath.row, _menuItems[indexPath.row]);
}
@end


@implementation DFPopMenuTableCell {

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //60-tableviewwidth 35-tableviewCell height
        self.dFTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DFMenuItemsWidth + DFMenuTableViewHSpace * 2, DFMenuItemsHeight)];
        [self addSubview:_dFTextLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
}


@end