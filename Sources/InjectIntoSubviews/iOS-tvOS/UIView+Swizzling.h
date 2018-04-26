//
//  UIView+Swizzling.h
//  DITranquillity-iOS
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINSResolver.h"

@interface UIView (Swizzling)

- (void)passResolver:(_DINSResolver*)resolver;

@end
