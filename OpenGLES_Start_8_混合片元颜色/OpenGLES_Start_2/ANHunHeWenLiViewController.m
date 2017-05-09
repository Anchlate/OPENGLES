
//
//  ANHunHeWenLiViewController.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/10/19.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "ANHunHeWenLiViewController.h"

@interface ANHunHeWenLiViewController ()

@end

@implementation ANHunHeWenLiViewController

@synthesize baseEffect;
@synthesize textureInfo0;
@synthesize textureInfo1;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    glClearColor(
                  1.0f, // Red
                  1.0f, // Green
                  1.0f, // Blue
                  1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    /*
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    */
//    stride = aStride;
//    bufferSizeBytes = stride * count;
    
    glGenBuffers(1,                // STEP 1
                 &name);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 name);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 sizeof(SceneVertex) * (sizeof(vertices) / sizeof(SceneVertex)),  // Number of bytes to copy
                 vertices,          // Address of bytes to copy
                 GL_STATIC_DRAW);           // Hint: cache in GPU memory
    
    
    
    
    
    // Setup texture0
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    
    self.textureInfo0 = [GLKTextureLoader
                         textureWithCGImage:imageRef0
                         // GLKTextureLoaderOriginBottomLeft:YES：命令GLKTextureLoader类，垂直翻转图像数据，这个翻转可以抵消图像的原点与OpenGL标准原点之间的差异
                         options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                         error:NULL];
    
    // Setup texture1
    CGImageRef imageRef1 =
    [[UIImage imageNamed:@"beetle.png"] CGImage];
    
    self.textureInfo1 = [GLKTextureLoader
                         textureWithCGImage:imageRef1
                         options:[NSDictionary dictionaryWithObjectsAndKeys : [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                         error:NULL];
    
    // Enable fragment blending with Frame Buffer contents
    glEnable(GL_BLEND); // 开启纹理混合
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); // 设置混合函数，其参数指定每个片元的最终颜色元素是怎么影响混合的
    
    
    // GL_SRC_ALPHA：用于让片元的透明度元素挨个地与其他的片元颜色相乘；
    // GL_ONE_MINUS_SRC_ALPHA：用于让片元的透明度元素（1.0）与在帧缓存内正被更新的像素的颜色元素相乘。
    
    
    
}


/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing)
//    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    glClear(GL_COLOR_BUFFER_BIT);
    
    /*
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    */
    glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
                 name);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);     // Step 4
    
    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribPosition,               // Identifies the attribute to use
                          3,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, positionCoords));      // offset from start of each vertex to
    // first coord for attribute
    
    
    
    
    /*
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    */
    glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
                 name);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);     // Step 4
                              
    
    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribTexCoord0,               // Identifies the attribute to use
                          2,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, textureCoords));      // offset from start of each vertex to
    // first coord for attribute
    
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using the vertices in the 
    // currently bound vertex buffer
    /*
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    */
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(SceneVertex)); // Step 6
    
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using currently bound vertex buffer
    /*
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
     */
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(SceneVertex)); // Step 6
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
