//
//  MCMaterialController.h
//  MCGame
//
//  Created by kwan terry on 12-9-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCTexturedQuad;
@class MCAnimatedQuad;

#import "MCPoint.h"

/**
 *	整个应用的材质纹理加载器，加载png图片等等
 */
@interface MCMaterialController : NSObject{
    /**
     *  model meterial
     */
    NSMutableDictionary * materialLibrary;
    /**
	 *  button meterial
     */
    NSMutableDictionary * quadLibrary;
}

+ (MCMaterialController*)sharedMaterialController;
- (MCAnimatedQuad*)animationFromAtlasKeys:(NSArray*)atlasKeys;
- (MCTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
/**
 *  build a textured quad from a dictionary
 *
 *  通过atlasSize和materialKey等等来创建一个纹理区域。
 *
 *  对旧有数据格式的支持。
 */
- (MCTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary*)record 
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString*)key;
/**
 *  build a textured quad from a dictionary
 *
 *  通过atlasSize和materialKey等等来创建一个纹理区域。
 *
 *  对texturepacker的支持
 */
- (MCTexturedQuad*)texturedQuadFrom_TexturePacker_AtlasRecord:(NSDictionary*)record
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString*)key;
- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (id) init;
- (void) loadLowResolution;
- (void) loadHighResolution;
- (void) dealloc;
- (void)bindMaterial:(NSString*)materialKey;
/**
 *  load the atlas data and load the atlas texture
 *
 *  根据名字加载对应的纹理数据，并且为对应数据建立纹理区块。
 *  适用于旧数据plist格式文件
 */
- (void)loadAtlasData:(NSString*)atlasName;
/**
 *  load the atlas data and load the atlas texture
 *
 *  根据名字加载对应的纹理数据，并且为对应数据建立纹理区块。
 *  兼容texturepacker格式文件
 */
- (void)loadAtlas_TexturePacker_Data:(NSString*)atlasName;

/**
 *	返回某个纹理width和heighth
 *
 *	@param	filename	纹理所在的plist文件
 *	@param	key	纹理对应的键值
 *
 *	@return	MCPoint(width,height,z_index),其中z_index为1
 */
+(MCPoint)getWidthAndHeightFromTextureFile:(NSString *)filename forKey:(NSString*)key;
@end
