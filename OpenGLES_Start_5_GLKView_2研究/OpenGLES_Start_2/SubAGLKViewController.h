//
//  SubAGLKViewController.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/27.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "AGLKViewController.h"
#import <GLKit/GLKit.h>

@interface SubAGLKViewController : AGLKViewController
{
    GLuint vertexBufferID; // 缓存id
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end
