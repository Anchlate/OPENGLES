
//
//  ANWenLiGLKitViewController.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/10/14.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "ANWenLiGLKitViewController.h"

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value {
    
    
    
    /*
     
     1、glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
     
     　　GL_TEXTURE_2D: 操作2D纹理.
     　　GL_TEXTURE_WRAP_S: S方向上的贴图模式.
     　　GL_CLAMP: 将纹理坐标限制在0.0,1.0的范围之内.如果超出了会如何呢.不会错误,只是会边缘拉伸填充.
     
 　　2、glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
     　　这里同上,只是它是T方向
     
 　　3、glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
     　　这是纹理过滤
     　　GL_TEXTURE_MAG_FILTER: 放大过滤
     　　GL_LINEAR: 线性过滤, 使用距离当前渲染像素中心最近的4个纹素加权平均值.
     
 　　4、glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
     　　GL_TEXTURE_MIN_FILTER: 缩小过滤
     　　GL_LINEAR_MIPMAP_NEAREST: 使用GL_NEAREST对最接近当前多边形的解析度的两个层级贴图进行采样,然后用这两个值进行线性插值.
     
     */
    
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, parameterID, value);
}
@end



@interface ANWenLiGLKitViewController ()

@end

@implementation ANWenLiGLKitViewController

@synthesize baseEffect;
//@synthesize vertexBuffer;
@synthesize shouldUseLinearFilter;
@synthesize shouldAnimate;
@synthesize shouldRepeatTexture;
@synthesize sCoordinateOffset;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

/////////////////////////////////////////////////////////////////
// Define defualt vertex data to reset vertices when needed
static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

/////////////////////////////////////////////////////////////////
// Provide storage for the vectors that control the direction
// and distance that each vertex moves per update when animated
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.preferredFramesPerSecond = 60;// 设置频率，每秒60帧
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    
    // 重新view创建一个 OpenGL ES 2.0 的上下文
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    // 创建一个GLKBaseEffect实例，有了GLKit和GLKBaseEffect类可以不必用shading language来编写GPU程序，可以自动地构建GPU程序
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE; // 默认GL_FALSE, 使用GLKVertexAttribColor属性来渲染像素颜色；GL_TRUE，使用constantColor来渲染像素颜色
    // 渲染像素颜色
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
                         usage:GL_DYNAMIC_DRAW];
    */
    
    self.stride = sizeof(SceneVertex);
    self.bufferSizeBytes = self.stride * sizeof(vertices) / sizeof(SceneVertex);
    
    
    // 1
    //为缓存生成一个独一无二的标示符  step1
    //函数解析 ： 第一个参数用于指定要生成的缓存标示符的数量，第二个参数是一个指针，指向生成标示符的内存保存位置。
    //在当前情况下，一个标示符被生成，保存在vertexBufferID成员变量中
    glGenBuffers(1, &name);                // STEP 1
    
    
    // 2
    //为接下来的运算绑定缓存   step2
    //glBindBuffer函数绑定用于指定标示符的缓存到当前缓存。但是在任意时刻每种类型只能绑定一个缓存。如果在这个例子中使用了两个顶点属性的数字缓存，那么同一时刻不能被绑定。
    //第一个参数 是一个常量，用于指定要绑定哪一种类型的缓存。 OpenGL ES2.0目前只支持两种类型的缓存。GL_ELEMENT_ARRAY_BUFFER 与GL_ARRAY_BUFFER。GL_ARRAY_BUFFER类型用于指定一个顶点属性的数组，例如，本例中三角形定点的位置。第二个参数是要绑定的缓存的标示符。
    glBindBuffer(GL_ARRAY_BUFFER, name);   // STEP 2
    
    
    // 3.
    //复制数据到 缓存中     step3
    //glBufferData 函数复制应用的额顶点数据到当前上下文所绑定的顶点缓存中。
    //第一个参数用于指定要更新当前上下文中所绑定的时哪一个缓存。
    //第二个参数指定要复制进这个缓存的自己的数量。
    //第三个参数是要复制的字节的地址
    //第四个参提示了在未来的运算中可能被怎样运用
    //GL_STATIC_DRAW 提示告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对齐进行修改。这个信息可帮助OpenGL ES优化内存使用。
    //GL_DYNAMIC_DRAW  提示数据会频繁改变，同时提示ES 以不同的方式处理缓存中得存储。
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 self.bufferSizeBytes,  // Number of bytes to copy
                 vertices,          // Address of bytes to copy
                 GL_DYNAMIC_DRAW);           // Hint: cache in GPU memory
    
    
    
    
    // Setup texture
    CGImageRef imageRef = 
    [[UIImage imageNamed:@"grid.png"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader 
                                   textureWithCGImage:imageRef 
                                   options:nil // opitons：指示GLKTextureInfo怎么解析加载图像数据的键值对的NSDictionary，其中可指示GLKTextureInfo为加载的图像生成MIP贴图
                                   error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
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


#pragma mark -Delegate
/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
//    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    glClear(GL_COLOR_BUFFER_BIT);
    
    
//    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
//                           numberOfCoordinates:3
//                                  attribOffset:offsetof(SceneVertex, positionCoords)
//                                  shouldEnable:YES];
    
    glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
                 name);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);     // Step 4
        
    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribPosition,               // Identifies the attribute to use
                          3,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          (self.stride),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, positionCoords));      // offset from start of each vertex to
    // first coord for attribute
  
    /*
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
*/
    
    
    
    
    
    /*
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    */
    glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
                 name);
    
    if(YES)
    {
        glEnableVertexAttribArray( GLKVertexAttribTexCoord0 );    // Step 4
    }
    
    glVertexAttribPointer(            // Step 5
                          GLKVertexAttribTexCoord0,               // Identifies the attribute to use
                          2,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          (self.stride),       // total num bytes stored per vertex
                          NULL + offsetof(SceneVertex, textureCoords));      // offset from start of each vertex to
    // first coord for attribute
    /*
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
*/
    
    
    
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    /*
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
    */
    
    glDrawArrays(GL_TRIANGLES, 0, 3); // Step 6
    
}


/////////////////////////////////////////////////////////////////
// Called automatically at rate defined by view controller’s
// preferredFramesPerSecond property
- (void)update
{
    
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    
    /*
     [vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
     numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
     bytes:vertices];
     */
    
    self.stride = sizeof(SceneVertex);
    self.bufferSizeBytes = self.stride * sizeof(vertices) / sizeof(SceneVertex);
    
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 name);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 self.bufferSizeBytes,  // Number of bytes to copy
                 vertices,          // Address of bytes to copy
                 GL_DYNAMIC_DRAW);
    
}



#pragma mark -Event
/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value.
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender
{
    self.shouldUseLinearFilter = [sender isOn];
}

/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the shouldAnimate
// property to demonstrate how texture coordinates affect
// texture mapping and visual distortion as geometry changes.
- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender
{
    self.shouldAnimate = [sender isOn];
}

/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the shouldRepeatTexture
// property to demonstrate how textures are clamped or repeated
// when mapped to geom
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender
{
    self.shouldRepeatTexture = [sender isOn];
}

/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the sCoordinateOffset
// property to demonstrate how texture coordinates affect
// texture mapping to geometry
- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender
{
    self.sCoordinateOffset = [sender value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Private
/////////////////////////////////////////////////////////////////
// Update the current OpenGL ES context texture wrapping mode
- (void)updateTextureParameters
{
    // 一、GL_TEXTURE_MIN_FILTER：多个纹素对应一个片元
    
    // 1. GL_LINEAR          GL_TEXTURE_MIN_FILTER  用现行内插法来混合这些颜色以得到片元的颜色，比如：黑白相间，就去混合颜色灰色
    // 2. GL_GL_NEAREST      GL_TEXTURE_MIN_FILTER  与片元的 U、V 坐标最接近的纹素的颜色会被取样，比如：黑边相间，距离“白色”纹素越近就是白色；距离“黑色”纹素越近就是黑色
    
    
    
    // 二、GL_TEXTURE_MAG_FILTER：一个纹素对应多个片元
    
    // 1. GL_LINEAR          GL_TEXTURE_MIN_FILTER  混合附近纹素的颜色来来计算片元的颜色，会有一个放大纹理的效果，并会让它模糊地出现在渲染的三角形上
    // 2. GL_GL_NEAREST      GL_TEXTURE_MIN_FILTER  仅仅会拾取与片元的 U、V 坐标最接近的纹素的颜色，并放大纹理，这会是它有点像素化地出现在渲染的三角形上
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER value:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
    
    
    
    
    
    /*     当 U、V 坐标的值大于1 或者 小于0 时，程序要指定会发生什么，有如下两个选择     */
    // 1、要么尽可能地重复纹理以填满映射到几何图形的整个 U、V 区域；
        //. GL_TEXTURE_WRAP_S   GL_REPEAT
        //. GL_TEXTURE_WRAP_T   GL_REPEAT
    
    // 2、要么每当片元的 U、V 坐标的值超出纹理的 S、T 坐标时，取样纹理边缘的纹素。
        //. GL_TEXTURE_WRAP_S   GL_CLAMP_TO_EDGE
        //. GL_TEXTURE_WRAP_T   GL_CLAMP_TO_EDGE
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE)];
}

/////////////////////////////////////////////////////////////////
/*
 该动画效果是通过不断改变顶点坐标和刷新来实现的
 */
// Update the positions of vertex data to create a bouncing
// animation
- (void)updateAnimatedVertexPositions
{
    if(shouldAnimate)
    {  // Animate the triangles vertex positions
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if(vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {  // Restore the triangle vertex positions to defaults
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    
    // Adjust the S texture coordinates to slide texture and
    // reveal effect of texture repeat vs. clamp behavior
    int    i;  // 'i' is current vertex index
    
    for(i = 0; i < 3; i++)
    {
        vertices[i].textureCoords.s = (defaultVertices[i].textureCoords.s + sCoordinateOffset);
//        vertices[i].textureCoords.t = (defaultVertices[i].textureCoords.t + sCoordinateOffset);
    }
    
}
@end