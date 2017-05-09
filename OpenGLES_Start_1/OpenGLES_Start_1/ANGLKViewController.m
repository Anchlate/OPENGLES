//
//  ANGLKViewController.m
//  OpenGLES_Start_1
//
//  Created by Qianrun on 16/6/24.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "ANGLKViewController.h"

// 这是一个正方形顶点的数组，实际上它是由二个三角形接合而成的。
/******
 
 
 每行顶点数据的排列含义是：
 
 顶点X、顶点Y，顶点Z、法线X、法线Y、法线Z、纹理S、纹理T。
 
 在后面解析此数组时，将参考此规则。
 
 顶点位置用于确定在什么地方显示，法线用于光照模型计算，纹理则用在贴图中。
 
 一般约定为“顶点以逆时针次序出现在屏幕上的面”为“正面”。
 
 世界坐标是OpenGL中用来描述场景的坐标，Z+轴垂直屏幕向外，X+从左到右，Y+轴从下到上，是右手笛卡尔坐标系统。我们用这个坐标系来描述物体及光源的位置。
 
 
 ******/
GLfloat squareVertexData[48] =
{
    
//  顶点X、顶点Y，顶点Z、  法线X、法线Y、法线Z、  纹理S、纹理T。
    0.5, 0.5, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 1.0f,
    -0.5, 0.5, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f,
    0.5, -0.5, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f,
    0.5, -0.5, -0.9f,    0.0f, 0.0f, 1.0f,   1.0f, 0.0f,
    -0.5, 0.5, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 1.0f,
    -0.5, -0.5, -0.9f,    0.0f, 0.0f, 1.0f,   0.0f, 0.0f,
    
};



@interface ANGLKViewController ()<GLKViewDelegate>
{
    
    GLuint _program;
    
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;


@end

@implementation ANGLKViewController

@synthesize context;
@synthesize effect;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // init
    
    /********** 
     
     第一部分：使用“ES2”创建一个“EAGLContext”实例。
     
     第二部分：将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式。
     
     第三部分：将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
     
     第四部分：创建一个GLK内置的“着色效果”，并给它提供一个光源，光的颜色为绿色。
     
     **********/
    
    // 1. 使用“ES2”创建一个“EAGLContext”实例。
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];// 创建的时候指定版本号
    
    // 2. 将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式。
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;// 设置颜色格式
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24; // 设置深度格式：
    
    // 3. 将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
    [EAGLContext setCurrentContext:self.context]; // 将self.context 设置为当前激活的context。
    glEnable(GL_DEPTH_TEST); // 发送第一个“GL”指令：激活“深度检测”
    
    // 4. 创建一个GLK内置的“着色效果”，并给它提供一个光源，光的颜色为绿色。
    self.effect = [[GLKBaseEffect alloc]init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);// 前三个颜色rgb值,光照颜色
    
    
    // Vertext data
    
    /******  1. 写入过程  ******
    
     1、写入过程
     
     首先将数据保存进GUP的一个缓冲区中，然后再按一定规则，将数据取出，复制到各个通用顶点属性中。
     
     注：如果顶点数据只有一种类型（如单纯的位置坐标），换言之，在读数据时，不需要确定第一个数据的内存位置（总是从0开始），则不必事先保存进缓冲区。
    ******/
    
    
    /******  
     
     这几行代码表示的含义是：声明一个缓冲区的标识（GLuint类型）à让OpenGL自动分配一个缓冲区并且返回这个标识的值à绑定这个缓冲区到当前“Context”à最后，将我们前面预先定义的顶点数据“squareVertexData”复制进这个缓冲区中。
     
     注：参数“GL_STATIC_DRAW”，它表示此缓冲区内容只能被修改一次，但可以无限次读取。
     
     ******/
    
    // 1.
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW); // 将定点数据复制进buffer缓冲区
    
    /******
     
     
     首先，激活顶点属性（默认它的关闭的）。“GLKVertexAttribPosition”是顶点属性集中“位置Position”属性的索引。
     
     顶点属性集中包含五种属性：位置、法线、颜色、纹理0，纹理1。
     
     它们的索引值是0到4。
     
     激活后，接下来使用“glVertexAttribPointer”方法填充数据。
     
     参数含义分别为：
     
     顶点属性索引（这里是位置）、3个分量的矢量、类型是浮点（GL_FLOAT）、填充时不需要单位化（GL_FALSE）、在数据数组中每行的跨度是32个字节（4*8=32。从预定义的数组中可看出，每行有8个GL_FLOAT浮点值，而GL_FLOAT占4个字节，因此每一行的跨度是4*8）。
     
     最后一个参数是一个偏移量的指针，用来确定“第一个数据”将从内存数据块的什么地方开始。
     
     ******/
    
    // 2. 将缓冲区的数据复制进通用顶点属性中
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL + 0);
    
    
    /******
     
     在前面预定义的顶点数据数组中，还包含了法线和纹理坐标，所以参照上面的方法，将剩余的数据分别复制进通用顶点属性中。
     
     原则上，必须先“激活”某个索引，才能将数据复制进这个索引表示的内存中。
     
     因为纹理坐标只有两个（S和T），所以上面参数是“2”。
     
     
     ******/
    
    // 3. 继续复制其它数据
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL + 12);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*8, (char *)NULL + 24);
    
    
    /******
     
     
     万事具备，现在可以让OpenGL显示一些东西了。
     
     在GLKit框架中，尽管OpenGL的行为，是由“GLKViewController”和“GLKView”联合控制的，但实际上“GLKView”类中完全不需要写任何自己的代码，因为，“GLKView”类中每帧触发的两个方法“update”和“glkView”，都转交给“GLKViewController”代理执行了。
     
     
     这两个方法每帧都执行一次（循环执行），一般执行频率与屏幕刷新率相同（但也可以更改）。
     
     第一次循环时，先调用“glkView”再调用“update”。
     
     一般，将场景数据变化放在“update”中，而渲染代码则放在“glkView”中。
     
     ******/
    
    // 4. 执行渲染循环
    // 看下面代理方法 GLKViewDelegate -> glkView:(GLKView *)view drawInRect:(CGRect)rect
    
    
    
    
    
    
    
    
    
    // 使用纹理
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"a" ofType:@"jpg"];

    
    /******
     
     GLKit加载纹理，默认都是把坐标设置在“左上角”。然而，OpenGL的纹理贴图坐标却是在左下角，这样刚好颠倒。
     
     在加载纹理之前，添加一个“options”：
     
     ******/
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    
    
    
    
    // 自定义着色器
//    NSString *vertFile = [[NSBundle mainBundle]pathForResource:@"v.shader" ofType:nil];
//    NSString *fragFile = [[NSBundle mainBundle]pathForResource:@"f.shader" ofType:nil];
//    
//    _program = [self loadShaders:vertFile frag:fragFile];
//    
//    int params;
//    glGetProgramiv(_program, GL_LINK_STATUS, &params);
//    NSLog(@"......:%d", params);
    
    
    /******
     
     第一部分是绑定“position”属性到通用的的顶点属性索引“0”上，绑定“texCoord”到通用的顶点属性索引“3”上。（索引1是法线，2是顶点颜色）。
     
     绑定后，必须调用“glLinkProgram”方法才能生效。
     
     
     
     第二部分，绑定“统一的纹理sampler2D”变量，到纹理0号单元——在使用“GLKTextureLoader”加载纹理时，默认是激活了“0”号单元。当然，如果是激活其他单元（例如8），则这里就相应的改为8。
     
     绑定之前，必须调用“glUseProgram”才起作用。
     
     ******/
    
//    glBindAttribLocation(_program, 0, "position");
//    glBindAttribLocation(_program, 3, "texCoord");
//    glLinkProgram(_program);
//    
//    
//    glUseProgram(_program);
//    GLint colorMap = glGetUniformLocation(_program, "colorMap");
//    glUniform1i(colorMap, 0);
    
}


#pragma mark -Delegate
#pragma mark -GLKViewDelegate
- (void)update {
    
    CGSize size  = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    
    /******/
//    GLKMatrix4 projectionMatrix = GLKMatrix4Identity;
//    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, aspect, 1.0f);
//    self.effect.transform.projectionMatrix = projectionMatrix;
    /******/
    
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    
    /******/
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -1.0f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    /******/
    
    
//    GLint mat = glGetUniformLocation(_program, "modelViewProjecionMatrix");
//    
//    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 1.0f, 1.0f, -1.0f);
//    
//    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
//    glUniformMatrix4fv(mat, 1, GL_FALSE, modelViewProjectionMatrix.m);
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f); // 清除颜色缓冲区的内容,并填充RGB(0.3f, 0.6f, 1.0f)颜色背景
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // 清除深度缓冲区中的内容
    
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    /******
     
     前两行为渲染前的“清除”操作，清除颜色缓冲区和深度缓冲区中的内容，并且填充淡蓝色背景（默认背景是黑色）。
     
     “prepareToDraw”方法，是让“效果Effect”针对当前“Context”的状态进行一些配置，它始终把“GL_TEXTURE_PROGRAM”状态定位到“Effect”对象的着色器上。此外，如果Effect使用了纹理，它也会修改“GL_TEXTURE_BINDING_2D”。
     
     接下来，用“glDrawArrays”指令，让OpenGL“画出”两个三角形（拼合为一个正方形）。OpenGL会自动从通用顶点属性中取出这些数据、组装、再用“Effect”内置的着色器渲染。
     
     ******/
    
    glUseProgram(_program);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (GLint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    
    GLuint vertShader, fragShader;
    GLint pprogram = glCreateProgram();
    
    [self compileShader:&vertShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    glAttachShader(pprogram, vertShader);
    glAttachShader(pprogram, fragShader);
    
    glLinkProgram(pprogram);
    
    return pprogram;
}

- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    const GLchar *source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
}

@end