
//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/7/19.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizei stride;


@end

@implementation AGLKVertexAttribArrayBuffer

@synthesize bufferSizeBytes;
@synthesize stride;
@synthesize glName;

- (id)initWithAttribStride:(GLsizei)aStride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage {
    
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    if (self = [super init]) {
        
        stride = aStride;
        bufferSizeBytes = stride *count;
        
        // 1.
        glGenBuffers(1, &glName);
        
        
        // 2.
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);
        
        
        // 3.
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage);
        
        
        NSAssert(0 != glName, @"fail to generate glName");
        
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLint)index numberOfCoordinats:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable {
    
    NSParameterAssert(0 < count && 4 > count);
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != glName, @"invalid glName");
    
    // 2.
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    
    // 4.
    if (shouldEnable) {
        
        glEnableVertexAttribArray(index);
        
    }
    
    // 5
    glVertexAttribPointer(index,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          self.stride,
                          NULL + offset);
    
}

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count {
    
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride), @"asssss");
    
    glDrawArrays(mode, first, count);
    
}

- (void)dealloc {
    
    if (0 != glName) {
        glDeleteBuffers(1, &glName);
    }
    glName = 0;
    
}



@end