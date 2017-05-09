//
//  ANWenLiGLKitViewController.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/10/14.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ANWenLiGLKitViewController : GLKViewController
{
    GLuint name;// 缓存ID
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
//@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;

@property (nonatomic) GLfloat sCoordinateOffset;
@property (nonatomic, assign) GLsizei stride;
@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;

@end