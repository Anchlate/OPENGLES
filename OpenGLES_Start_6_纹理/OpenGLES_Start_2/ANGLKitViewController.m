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
    GLKVector2 textureCoords;
    
}SceneVertex;

static const SceneVertex verticess[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};


@interface ANGLKitViewController ()

@end

@implementation ANGLKitViewController

@synthesize baseEffect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    
    // 重新view创建一个 OpenGL ES 2.0 的上下文
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 将重新创建的上下文设置为当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    // 创建一个GLKBaseEffect实例，有了GLKit和GLKBaseEffect类可以不必用shading language来编写GPU程序，可以自动地构建GPU程序
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE; // 默认GL_FALSE, 使用GLKVertexAttribColor属性来渲染像素颜色；GL_TRUE，使用constantColor来渲染像素颜色
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0); // 渲染像素颜色
    
    // 上下文的 “清除颜色”，即：背景颜色
    glClearColor(1, 1, 1, 1.0);
    
    
    // 1.
    //为缓存生成一个独一无二的标示符  step1
    //函数解析 ： 第一个参数用于指定要生成的缓存标示符的数量，第二个参数是一个指针，指向生成标示符的内存保存位置。
    //在当前情况下，一个标示符被生成，保存在vertexBufferID成员变量中
    glGenBuffers(1, &vertexBufferID);
    
    
    // 2.
    //为接下来的运算绑定缓存   step2
    //glBindBuffer函数绑定用于指定标示符的缓存到当前缓存。但是在任意时刻每种类型只能绑定一个缓存。如果在这个例子中使用了两个顶点属性的数字缓存，那么同一时刻不能被绑定。
    //第一个参数 是一个常量，用于指定要绑定哪一种类型的缓存。 OpenGL ES2.0目前只支持两种类型的缓存。GL_ELEMENT_ARRAY_BUFFER 与GL_ARRAY_BUFFER。GL_ARRAY_BUFFER类型用于指定一个顶点属性的数组，例如，本例中三角形定点的位置。第二个参数是要绑定的缓存的标示符。
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    
    // 3.
    //复制数据到 缓存中     step3
    //glBufferData 函数复制应用的额顶点数据到当前上下文所绑定的顶点缓存中。
    //第一个参数用于指定要更新当前上下文中所绑定的时哪一个缓存。
    //第二个参数指定要复制进这个缓存的自己的数量。
    //第三个参数是要复制的字节的地址
    //第四个参提示了在未来的运算中可能被怎样运用
    //GL_STATIC_DRAW 提示告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对齐进行修改。这个信息可帮助OpenGL ES优化内存使用。
    //GL_DYNAMIC_DRAW  提示数据会频繁改变，同时提示ES 以不同的方式处理缓存中得存储。
    glBufferData(GL_ARRAY_BUFFER, sizeof(verticess), verticess, GL_STATIC_DRAW);
    
    
    // Setup texture
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader
                                   textureWithCGImage:imageRef
                                   options:nil
                                   error:NULL];
    
    // 设置baseEffect的textture2d0属性来使用一个新的纹理缓存
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

//视图被最终卸载时调用。卸载的试图将不再被绘制，因此任何指示再回只是需要的OpenGL ES 缓存都可以被安全的删除。
- (void)viewDidUnload {
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != vertexBufferID) {
        
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    
    //设置视图的上下文属性为nil，并设置当前上下文为nil。以便让ios 收回所有上下文使用的内存和其他资源。
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

#pragma mark -Delegate
//此委托方法的实现告诉baseEffect装备好当前的OpenGL ES的上下文，一边为使用baseEffect生成的属性和Shading Language程序的绘画做好准备。
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    
    [self.baseEffect prepareToDraw];
    
     // 当前绑定的帧缓存的像素颜色缓存中的每一个像素的颜色为当前 glClear() 函数设定的值。
    glClear(GL_COLOR_BUFFER_BIT);

    
    // 4.
    //glEnableVertexAttribArray 启动定点缓存渲染操作。
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    
    // 5.
    //glVertexAttribPointer 函数会告诉 OpenGL ES 定点数据在哪里，以及解释为每个顶点保存的数据。 step 5
    //第一个参数指示当前绑定的缓存包含每个定点的位置信息
    //第二个参数指示每个顶点位置有三个组成部分
    //第三个参数告诉ES 每个部分都保存为一个浮点类型的值
    //第四个参数告诉ES 小数点固定数据是否可以被改变。 没有使用所以用GL_FALSE
    //第五个参数叫做 “步幅”，他指定了每个订单的保存需要多少个字节。
    //最后一个参数 NULL，这告诉OpenGL ES可以从当前绑定的定点缓存的开始位置访问定点数据。
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));//
    
    
    
    // 让OpenGL 为每个定点的两个纹理坐标的渲染做好准备
    /*-----------------------------------*/
    
    // 4.
    //glEnableVertexAttribArray 启动定点缓存渲染操作。
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    
    // 5.
    //glVertexAttribPointer 函数会告诉 OpenGL ES 定点数据在哪里，以及解释为每个顶点保存的数据。 step 5
    //第一个参数指示当前绑定的缓存包含每个定点的位置信息
    //第二个参数指示每个顶点位置有三个组成部分
    //第三个参数告诉ES 每个部分都保存为一个浮点类型的值
    //第四个参数告诉ES 小数点固定数据是否可以被改变。 没有使用所以用GL_FALSE
    //第五个参数叫做 “步幅”，他指定了每个订单的保存需要多少个字节。
    //最后一个参数 NULL，这告诉OpenGL ES可以从当前绑定的定点缓存的开始位置访问定点数据。
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));//  + offsetof(SceneVertex, textureCoords)
    
    /*-----------------------------------*/
     
    
    
    
    // 6.
    //调用glDrawArrays 执行绘图。 step 6
    //第一个参数告诉GPU 怎么处理绑定的顶点缓存内的顶点数据。
    //第二个和第三个 分别制定缓存内的需要渲染的第一个顶点的位置，炫耀渲染的顶点的数量。
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}


@end
