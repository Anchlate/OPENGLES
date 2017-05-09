//
//  ANGLKitViewController.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/6/27.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "ANGLKitViewController.h"

typedef struct {
    
    GLKVector3 positionCoords;
    
}SceneVertex;

static const SceneVertex verticess[] = {
    
    {{ -0.5, -0.5, 0.0 }},
    {{ 0.5, -0.5, 0.0 }},
    {{ -0.5, 0.5, 0.0 }}
    
};


@interface ANGLKitViewController ()

@end

@implementation ANGLKitViewController

@synthesize baseEffect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    //
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //
    [EAGLContext setCurrentContext:view.context];
    
    //
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    //
    glClearColor(0, 0, 0, 1.0);
    
    
    // 1.
    glGenBuffers(1, &vertexBufferID);
    
    // 2.
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    // 3.
    glBufferData(GL_ARRAY_BUFFER, sizeof(verticess), verticess, GL_STATIC_DRAW);
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


@end
