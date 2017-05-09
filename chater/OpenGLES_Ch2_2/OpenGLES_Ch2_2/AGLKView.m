//
//  AGLKView.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/21.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGLKView

@synthesize delegate;
@synthesize context;


// CAEAGLLayer 是 Core Animation提供的标准层之一。 CAEAGLLayer会于一个OpenGL ES 的帧缓存共享它的像素颜色仓库

// 每一个UIView的实例都有一个相关联的被Cocoa Touch 按需自动创建的 Core Animation 层

+ (Class)layerClass {
    
    return [CAEAGLLayer class];
    
}

#pragma mark -Initialize
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext {
    
    if (self = [super initWithFrame:frame]) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        
                                        [NSNumber numberWithBool:NO],
                                        kEAGLDrawablePropertyRetainedBacking, // 不保存以前回执的图像
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat, // 用8位来保存每个像素的颜色元素的值
                                        nil];
        self.context = aContext;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        
                                        [NSNumber numberWithBool:NO],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat,
                                        nil];
        
    }
    return self;
}

- (void)dealloc {
    
    if ([EAGLContext currentContext] == context) {
        
        [EAGLContext setCurrentContext:nil];
        
    }
    
    context = nil;
}

#pragma mark -Overide
- (void)layoutSubviews {
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer]; // 会调整视图的缓存尺寸以匹配层的的新尺寸
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer); // 绑定像素颜色渲染缓存，让其成为当前展示的像素颜色渲染缓存
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER); // 检查一下渲染是否有错误
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"faild to make complete frame buffer object %x", status);
    }
    
}

- (void)drawRect:(CGRect)rect {
    
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:rect];
    }
    
}

#pragma mark -PublicMetho
- (void)display {
    
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLint)self.drawableWidth, (GLint)self.drawableHeight); // 可以控制渲染至帧缓存的子集，这里使用的是整个帧缓存
    
    [self drawRect:self.bounds];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER]; // 上下文调整外观，并调用Core Animation合成器把帧缓存的像素颜色渲染缓存与其他相关层混合起来
}


#pragma mark -setter
- (void)setContext:(EAGLContext *)aContext {
    
    if (context != aContext) {
        
        // 设置当前上下文，会删除之前创建的缓存
        [EAGLContext setCurrentContext:context];
        
        if (0 != defaultFrameBuffer) {
            
            glDeleteFramebuffers(1, &defaultFrameBuffer); //
            defaultFrameBuffer = 0;
            
        }
        
        if (0 != colorRenderBuffer) {
            
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        
        context = aContext;
        
        if (nil != context) {
            // 配置新的上下文
            context = aContext;
            [EAGLContext setCurrentContext:context];
            
            glGenFramebuffers(1, &defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            
            
            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            
            // 配置当前绑定的帧缓存，以便在colorRenderBuffer中保存渲染的像素颜色
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
        }
    }
}

#pragma mark -Getter
- (EAGLContext *)context {
    return context;
}

/////////////////////////////////////////////////////////////////
// This method returns the width in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableWidth;
{
    GLint          backingWidth;
    
    // 获取和返回当前上下文的帧缓存的像素颜色渲染缓存的尺寸
    glGetRenderbufferParameteriv(
                                 GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &backingWidth);
    
    return (NSInteger)backingWidth;
}


/////////////////////////////////////////////////////////////////
// This method returns the height in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableHeight;
{
    GLint          backingHeight;
    
    glGetRenderbufferParameteriv(
                                 GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT, 
                                 &backingHeight);
    
    return (NSInteger)backingHeight;
}

@end