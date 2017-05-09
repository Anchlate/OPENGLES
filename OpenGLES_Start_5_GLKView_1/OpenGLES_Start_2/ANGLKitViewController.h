//
//  ANGLKitViewController.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/6/27.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ANGLKitViewController : GLKViewController
{
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end