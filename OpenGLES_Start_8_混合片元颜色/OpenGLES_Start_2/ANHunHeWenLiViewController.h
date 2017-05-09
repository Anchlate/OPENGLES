//
//  ANHunHeWenLiViewController.h
//  OpenGLES_Start_2
//
//  Created by Qianrun on 16/10/19.
//  Copyright © 2016年 qianrun. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ANHunHeWenLiViewController : GLKViewController
{
    GLuint name;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end