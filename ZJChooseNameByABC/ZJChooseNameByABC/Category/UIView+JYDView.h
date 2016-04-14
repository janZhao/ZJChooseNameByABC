
#import <UIKit/UIKit.h>

@interface UIView (JYDView)

@property (nonatomic, assign) CGPoint originCustom;
@property (nonatomic, readonly) CGFloat originX;
@property (nonatomic, readonly) CGFloat originY;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@property(nonatomic, readonly) CGFloat left;
@property(nonatomic, readonly) CGFloat top;
@property(nonatomic, readonly) CGFloat right;
@property(nonatomic, readonly) CGFloat bottom;

@property(nonatomic, readonly) CGFloat centerX;
@property(nonatomic, readonly) CGFloat centerY;

@property(nonatomic, readonly) CGSize size;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end
