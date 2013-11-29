//
//  MCFonts.m
//  MCGame
//
//  Created by kwan terry on 13-6-18.
//
//

#import "MCFonts.h"

@implementation MCFonts
/**
 *	返回适当大小的默认字体(如果字体不存在，则返回nil)
 *
 *	@param	size : (int)the size of font
 *
 *	@return	 (UIFont*)the font
 */
+(UIFont*)customFontWithSize:(int)size{
    // 你的字体路径
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"fzzzhonghjw" ofType:@"ttf"];
    //fzzhonghjw is a font provided by the app. I don`t know why it is called with the name.
    NSURL *url = [NSURL fileURLWithPath:fontPath];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL(( CFURLRef)url);
    if (fontDataProvider == NULL)
        return nil;
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    if (newFont == NULL)
        return nil;
    NSString *fontName = ( NSString *)CGFontCopyFullName(newFont);
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(newFont);
    return font;
}
@end
