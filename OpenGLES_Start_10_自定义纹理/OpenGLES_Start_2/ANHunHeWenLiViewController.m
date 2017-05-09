
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
                  0.0f, // Red
                  0.0f, // Green
                  0.0f, // Blue
                  1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    /*
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    */
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
    
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader
                                    textureWithCGImage:imageRef0
                                    options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                                    error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    
    // Setup texture1
    CGImageRef imageRef1 =
    [[UIImage imageNamed:@"beetle.png"] CGImage];
    
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1
                                                                options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                                                                  error:NULL];
    
    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;// 默认模式为：GLKTextureEnvModeModulate
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
    
    glEnableVertexAttribArray(     // Step 4
                              GLKVertexAttribPosition);
    
    
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
    glEnableVertexAttribArray(     // Step 4
                              GLKVertexAttribTexCoord0);
    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribTexCoord0,               // Identifies the attribute to use
                          2,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, textureCoords));      // offset from start of each vertex to
    // first coord for attribute
    
    
    
    /*
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    */
    glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
                 name);
    glEnableVertexAttribArray(     // Step 4
                              GLKVertexAttribTexCoord1);

    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribTexCoord1,               // Identifies the attribute to use
                          2,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, textureCoords));      // offset from start of each vertex to
    // first coord for attribute

    
    
    
    
    
    
    
    
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using currently bound vertex buffer
    /*
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    */
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(SceneVertex)); // Step 6
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view 
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // Delete buffers that aren't needed when view is unloaded
//    self.vertexBuffer = nil;
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end