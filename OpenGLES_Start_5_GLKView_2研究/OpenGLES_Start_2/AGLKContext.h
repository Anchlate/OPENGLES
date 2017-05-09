//
//  AGLKContext.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/19.
//  Copyright © 2016年 qianrun. All rights reserved.
//

//#import <OpenGLES/OpenGLES.h>
#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext
{
    GLKVector4 clearColor;
}
@property (nonatomic, assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;

@end