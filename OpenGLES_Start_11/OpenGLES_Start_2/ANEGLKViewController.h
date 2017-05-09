//
//  ANEGLKViewController.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/10/21.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ANEGLKViewController : GLKViewController
{
    GLuint name;
    
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texture0ID;
    GLuint _texture1ID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
//@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end
