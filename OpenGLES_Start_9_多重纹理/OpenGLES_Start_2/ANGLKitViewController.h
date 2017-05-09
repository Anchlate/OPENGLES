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


// 创建一个GLKBaseEffect实例，有了GLKit和GLKBaseEffect类可以不必用shading language来编写GPU程序，可以自动地构建GPU程序
@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end