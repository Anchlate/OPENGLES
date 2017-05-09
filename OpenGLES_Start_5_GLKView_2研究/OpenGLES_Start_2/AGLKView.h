//
//  AGLKView.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/21.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class EAGLContext;
@protocol AGLKViewDelegate;

@interface AGLKView : UIView
{
    EAGLContext *context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLuint drawableWidth;
    GLuint drawableHeight;
}

@property (nonatomic, weak) IBOutlet id<AGLKViewDelegate> delegate;

@property (nonatomic, retain) EAGLContext *context;// OpenGL ES 2.0 的上下文
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)display;

@end

#pragma mark -AGLKViewDelegate

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end