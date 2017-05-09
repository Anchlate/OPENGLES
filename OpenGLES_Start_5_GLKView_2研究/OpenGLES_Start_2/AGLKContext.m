
//
//  AGLKContext.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/19.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext



#pragma mark -Private
- (void)clear:(GLbitfield)mask {
    
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    
    glClear(mask);
    
}


#pragma mark -Setter
- (void)setClearColor:(GLKVector4)clearColorRGBA {
    
    clearColor = clearColorRGBA;
    
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);
    
}

#pragma mark -Getter
- (GLKVector4)clearColor {
    
    return clearColor;
}

@end