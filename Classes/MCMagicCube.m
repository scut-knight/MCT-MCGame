//
//  RCRubiksCube.m
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//

#import "MCMagicCube.h"
#import "MCTransformUtil.h"

/**
 *	描述立方体的格式
 */
#define kSingleCubieKeyFormat @"Cubie%d"
/**
 *  描述朝向的格式
 */
#define kSingleOrientationToMagicCubeFaceKeyFormat @"OrientationToFace%d"

@implementation MCMagicCube{
    MCCubie *_magicCubies3D[3][3][3];
    /**
     *	magicCubiesList里装载着magicCubies3D[3][3][3]
     */
    MCCubie *_magicCubiesList[27];
    FaceOrientationType _orientationToMagicCubeFace[6];
}

@synthesize faceColorKeyMappingToRealColor;

/**
 *	构造函数，调用无参数的init初始化
 *
 *	@return	一个新的魔方
 */
+ (MCMagicCube *)magicCube{
    return [[[MCMagicCube alloc] init] autorelease];
}

/**
 *	从档案中恢复一个魔方，调用NSKeyedUnarchiver
 *  注意：没有检查路径是否合理
 *
 *	@param	path	文件路径
 */
+ (MCMagicCube *)unarchiveMagicCubeWithFile:(NSString *)path{
    MCMagicCube *newMagicCube = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (newMagicCube != nil) {
        [newMagicCube reloadColorMappingDictionary];
    } else {
        [[newMagicCube init] reloadColorMappingDictionary];
    }
    return newMagicCube;
}

/**
 *	构造函数之二，调用initOnlyWithCenterColor
 *
 *	@return	id 因为initOnlyWithCenterColor返回id类型
 */
+ (id)magicCubeOnlyWithCenterColor{
    return [[[MCMagicCube alloc] initOnlyWithCenterColor] autorelease];
}

/**
 *  初始化一个魔方
 *	调用了initOnlyCenterColor:来初始化每一个立方体
 */
- (id)initOnlyWithCenterColor{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        struct Point3i coordinateValue = {.x = x-1, .y = y-1, .z = z-1};
                        // isReatin means retain is need
                        BOOL isReatin = NO;
                        if (_magicCubies3D[x][y][z] == nil) {
                            _magicCubies3D[x][y][z] = [MCCubie alloc];
                            isReatin = YES;
                        }
                        [_magicCubies3D[x][y][z] initOnlyCenterColor:coordinateValue];
                        //box the magicCubes
                        _magicCubiesList[x+y*3+z*9] = _magicCubies3D[x][y][z];
                        if (isReatin) [_magicCubiesList[x+y*3+z*9] retain];
                    }
                }
            }
        }
        for (int i  = 0; i < 6; i++) {
            //At the begining, the orientation and the magic cube face orientation is same
            _orientationToMagicCubeFace[i] = (FaceOrientationType)i;
        }
        
        //Load colors mapping dictionary
        [self reloadColorMappingDictionary];
    }
    return self;
}


/**
 *  initial the rubik's cube as a new state
 *
 *	初始化魔方
 *  调用了initRightCubeWithCoordinate:来初始化每一个立方体
 */
- (id)init{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        struct Point3i coordinateValue = {.x = x-1, .y = y-1, .z = z-1};
                        BOOL isReatin = NO;
                        if (_magicCubies3D[x][y][z] == nil) {
                            _magicCubies3D[x][y][z] = [MCCubie alloc];
                            isReatin = YES;
                        }
                        [_magicCubies3D[x][y][z] initRightCubeWithCoordinate:coordinateValue];
                        _magicCubiesList[x+y*3+z*9] = _magicCubies3D[x][y][z];
                        if (isReatin) [_magicCubiesList[x+y*3+z*9] retain];
                    }
                }
            }
        }
        for (int i  = 0; i < 6; i++) {
            //At the begining, the orientation and the magic cube face orientation is same
            _orientationToMagicCubeFace[i] = (FaceOrientationType)i;
        }
        
        //Load colors mapping dictionary
        [self reloadColorMappingDictionary];
    }
    return self;
}

- (void)dealloc{
    for (int i = 0; i < 27; i++) {
        //release twice
        //第一次为了release 3*3*3个cube，第二次为了release magicCubesList
        [_magicCubiesList[i] release];
        [_magicCubiesList[i] release];
    }
    [super dealloc];
}

/**
 *	旋转,改变立方体以及中央立方体的朝向
 *
 *	@param	axis	轴
 *	@param	layer	魔方层
 *	@param	direction	(LayerRotationDirectionType)方向
 *
 *	@return     BOOL 确定是否成功完成
 */
- (BOOL)rotateOnAxis:(AxisType)axis onLayer:(int)layer inDirection:(LayerRotationDirectionType)direction{
    if (layer < 0 || layer > 2 || (direction != CW && direction != CCW)) return NO;
    MCCubie *layerCubes[9];
    switch (axis) {
        case X:
            //change data
            for(int y = 0; y < 3; ++y)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [_magicCubies3D[layer][y][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+y*3] = _magicCubies3D[layer][y][z];
                }
            }
            break;
        case Y:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int z = 0; z < 3; ++z)
                {
                    [_magicCubies3D[x][layer][z] shiftOnAxis:axis inDirection:direction];
                    layerCubes[z+x*3] = _magicCubies3D[x][layer][z];
                }
            }
            break;
        case Z:
            //change data
            for(int x = 0; x < 3; ++x)
            {
                for(int y = 0; y < 3; ++y)
                {
                    [_magicCubies3D[x][y][layer] shiftOnAxis:axis inDirection:direction];
                    layerCubes[y+x*3] = _magicCubies3D[x][y][layer];
                }
            }
            break;
        default:
            return NO;
    }
    
    //refresh pointer
    for(int index = 0; index < 9; ++index)
    {
        struct Point3i value = layerCubes[index].coordinateValue;
        _magicCubies3D[value.x+1][value.y+1][value.z+1] = layerCubes[index];
    }
    
    //change magic cube face orientation
    // 只有在layer==1，也即旋转中间层时需要变换_orientationToMagicCubeFace，因为_orientationMagicCubeFace储存的是中央立方体的六个面的朝向
    // 朝向的改变根据旋转的轴和旋转的方向来变换
    if (layer == 1) {
        switch (axis) {
            case X:
                if (direction == CW) {
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Front];
                    _orientationToMagicCubeFace[Front] = _orientationToMagicCubeFace[Down];
                    _orientationToMagicCubeFace[Down] = _orientationToMagicCubeFace[Back];
                    _orientationToMagicCubeFace[Back] = _orientationToMagicCubeFace[Up];
                    _orientationToMagicCubeFace[Up] = tmp;
                }
                else{
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Front];
                    _orientationToMagicCubeFace[Front] = _orientationToMagicCubeFace[Up];
                    _orientationToMagicCubeFace[Up] = _orientationToMagicCubeFace[Back];
                    _orientationToMagicCubeFace[Back] = _orientationToMagicCubeFace[Down];
                    _orientationToMagicCubeFace[Down] = tmp;
                }
                break;
            case Y:
                if (direction == CW) {
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Front];
                    _orientationToMagicCubeFace[Front] = _orientationToMagicCubeFace[Right];
                    _orientationToMagicCubeFace[Right] = _orientationToMagicCubeFace[Back];
                    _orientationToMagicCubeFace[Back] = _orientationToMagicCubeFace[Left];
                    _orientationToMagicCubeFace[Left] = tmp;
                } else {
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Front];
                    _orientationToMagicCubeFace[Front] = _orientationToMagicCubeFace[Left];
                    _orientationToMagicCubeFace[Left] = _orientationToMagicCubeFace[Back];
                    _orientationToMagicCubeFace[Back] = _orientationToMagicCubeFace[Right];
                    _orientationToMagicCubeFace[Right] = tmp;
                }
                break;
            case Z:
                if (direction == CW) {
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Up];
                    _orientationToMagicCubeFace[Up] = _orientationToMagicCubeFace[Left];
                    _orientationToMagicCubeFace[Left] = _orientationToMagicCubeFace[Down];
                    _orientationToMagicCubeFace[Down] = _orientationToMagicCubeFace[Right];
                    _orientationToMagicCubeFace[Right] = tmp;
                } else {
                    FaceOrientationType tmp = _orientationToMagicCubeFace[Up];
                    _orientationToMagicCubeFace[Up] = _orientationToMagicCubeFace[Right];
                    _orientationToMagicCubeFace[Right] = _orientationToMagicCubeFace[Down];
                    _orientationToMagicCubeFace[Down] = _orientationToMagicCubeFace[Left];
                    _orientationToMagicCubeFace[Left] = tmp;
                }
                break;
        }
    }
    
    return YES;
}   //rotate operation

/**
 *	旋转
 *
 *	@param	notation	(SingmasterNotation)
 *
 *	@return	BOOL 确定是否成功完成
 */
- (BOOL)rotateWithSingmasterNotation:(SingmasterNotation)notation{
    switch (notation) {
        case F:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
        }
            break;
        case Fi:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
        }
            break;
        case F2:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
        }
            break;
        case B:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
        }
            break;
        case Bi:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
        }
            break;
        case B2:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
        }
            break;
        case R:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
        }
            break;
        case Ri:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
        }
            break;
        case R2:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
        }
            break;
        case L:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
        }
            break;
        case Li:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
        }
            break;
        case L2:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
        }
            break;
        case U:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
        }
            break;
        case Ui:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
        }
            break;
        case U2:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
        }
            break;
        case D:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
        }
            break;
        case Di:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
        }
            break;
        case D2:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
        }
            break;
        case x:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
        }
            break;
        case xi:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
        }
            break;
        case x2:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
        }
            break;
        case y:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
        }
            break;
        case yi:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
        }
            break;
        case y2:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
        }
            break;
        case z:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
        }
            break;
        case zi:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
        }
            break;
        case z2:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
        }
            break;
        case Fw:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
        }
            break;
        case Fwi:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
        }
            break;
        case Fw2:
        {
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:2 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
        }
            break;
        case Bw:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
        }
            break;
        case Bwi:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
        }
            break;
        case Bw2:
        {
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
        }
            break;
        case Rw:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
        }
            break;
        case Rwi:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
        }
            break;
        case Rw2:
        {
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:2 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
        }
            break;
        case Lw:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
        }
            break;
        case Lwi:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CW];
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
        }
            break;
        case Lw2:
        {
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:0 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
        }
            break;
        case Uw:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
        }
            break;
        case Uwi:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case Uw2:
        {
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:2 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
        }
            break;
        case Dw:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case Dwi:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case Dw2:
        {
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:0 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case M:
        {
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
        }
            break;
        case Mi:
        {
            [self rotateOnAxis:X onLayer:1 inDirection:CW];
        }
            break;
        case M2:
        {
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
            [self rotateOnAxis:X onLayer:1 inDirection:CCW];
        }
            break;
        case E:
        {
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case Ei:
        {
            [self rotateOnAxis:Y onLayer:1 inDirection:CW];
        }
            break;
        case E2:
        {
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
            [self rotateOnAxis:Y onLayer:1 inDirection:CCW];
        }
            break;
        case S:
        {
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
        }
            break;
        case Si:
        {
            [self rotateOnAxis:Z onLayer:1 inDirection:CCW];
        }
            break;
        case S2:
        {
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
            [self rotateOnAxis:Z onLayer:1 inDirection:CW];
        }
            break;
        default:
            return NO;
    }
    return YES;
}

/**
 *	根据色块组合获取对应方块的坐标
 *
 *	@param	combination	色块组合
 *
 *	@return	描述坐标的Point3i
 */
- (struct Point3i)coordinateValueOfCubieWithColorCombination:(ColorCombinationType)combination{
    return _magicCubiesList[combination].coordinateValue;
}   //get coordinate of cube having the color combination

/**
 * get the cubie having the colors combination
 */
- (NSObject<MCCubieDelegate> *)cubieWithColorCombination:(ColorCombinationType)combination{
    return (combination >= 0 && combination < ColorCombinationTypeBound)? _magicCubiesList[combination] : nil;
}

/**
 * get the cube in the specified position
 */
- (NSObject<MCCubieDelegate> *)cubieAtCoordinateX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    return _magicCubies3D[x+1][y+1][z+1];
}

/**
 * get the cube in the specified position
 */
- (NSObject<MCCubieDelegate> *)cubieAtCoordinatePoint3i:(struct Point3i)point{
    return _magicCubies3D[point.x+1][point.y+1][point.z+1];
}

/**
 *	返回中央立方块的朝向
 *
 *	@param	orientation	当前朝向
 *
 *	@return	原来的朝向
 */
- (FaceOrientationType)centerMagicCubeFaceInOrientation:(FaceOrientationType)orientation{
    return _orientationToMagicCubeFace[orientation];
}

/**
 *encode the object
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [aCoder encodeObject:_magicCubies3D[x][y][z] forKey:[NSString stringWithFormat:kSingleCubieKeyFormat, x+3*y+9*z]];
                }
            }
        }
    }
    for (int i  = 0; i < 6; i++) {
        [aCoder encodeInteger:_orientationToMagicCubeFace[i] forKey:[NSString stringWithFormat:kSingleOrientationToMagicCubeFaceKeyFormat, i]];
    }
}

/**
 *decode the object
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    if (x != 1 || y != 1 || z != 1) {
                        //get the cubie object
                        _magicCubies3D[x][y][z] = [aDecoder decodeObjectForKey:[NSString stringWithFormat:kSingleCubieKeyFormat, x+3*y+9*z]];
                        [_magicCubies3D[x][y][z] retain];
                        //set the right pointer
//                        NSInteger listIndex = _magicCubies3D[x][y][z].identity;
                        NSInteger listIndex = x + 3 * y + 9 * z;
                        _magicCubiesList[listIndex] = _magicCubies3D[x][y][z];
                        [_magicCubiesList[listIndex] retain];
                    }
                }
            }
        }
        for (int i  = 0; i < 6; i++) {
            _orientationToMagicCubeFace[i] = (FaceOrientationType)[aDecoder decodeIntegerForKey:[NSString stringWithFormat:kSingleOrientationToMagicCubeFaceKeyFormat, i]];
        }
    }
    return self;
}

/**
 *	Get the state of cubies
 * Every state in the "format" axis-orientation
 * 获取每一个立方体的三维空间轴
 * 调用了MCCube的getCubieOrientationOfAxis:
 *
 *  @see MCCube#getCubieOrientationOfAxis:
 *
 *	@return	储存除中央立方体之外26个立方体的状态,中央立方块为空字典
 */
- (NSArray *)getAxisStatesOfAllCubie{
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:26];
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [states addObject:[_magicCubies3D[x][y][z] getCubieOrientationOfAxis]];
                }
                else{
                    [states addObject:[NSDictionary dictionary]];
                }
            }
        }
    }
    return  [NSArray arrayWithArray:states];
}

/**
 *	Get the state of cubies
 * Every state in the "format" orientation-face color
 * 获取每一个立方体的三维空间轴
 * 调用了MCCube的getCubieColorInOrientations:
 *
 *  @see MCCube#getCubieColorInOrientations:
 *
 *	@return	储存除中央立方体之外26个立方体的状态,中央立方块为空字典
 */
- (NSArray *)getColorInOrientationsOfAllCubie{
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:26];
    for (int z = 0; z < 3; z++) {
        for (int y = 0; y < 3; y++) {
            for (int x = 0; x < 3; x++) {
                if (x != 1 || y != 1 || z != 1) {
                    [states addObject:[_magicCubies3D[x][y][z] getCubieColorInOrientations]];
                }
                else{
                    [states addObject:[NSDictionary dictionary]];
                }
            }
        }
    }
    return [NSArray arrayWithArray:states];
}

/**
 *	fter change the color setting,
 * you can applying it in the data model by invoking this method.
 * 将魔方各个面的颜色储存在FACE_COLOR_MAPPING_FILE_NAME.plist里
 */
- (void)reloadColorMappingDictionary{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:FACE_COLOR_MAPPING_FILE_NAME ofType:@"plist"];
    self.faceColorKeyMappingToRealColor = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

/**
 *	根据颜色朝向得到当前对应的颜色
 *
 *	@param	color	颜色朝向
 *
 *	@return	颜色的名字
 */
- (NSString *)getRealColor:(FaceColorType)color{
    switch (color) {
        case UpColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_UP_FACE_COLOR];
            break;
        case DownColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_DOWN_FACE_COLOR];
            break;
        case FrontColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_FRONT_FACE_COLOR];
            break;
        case BackColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_BACK_FACE_COLOR];
            break;
        case LeftColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_LEFT_FACE_COLOR];
            break;
        case RightColor:
            return [self.faceColorKeyMappingToRealColor objectForKey:KEY_RIGHT_FACE_COLOR];
            break;
        default:
            return @"";
    }
}

/**
 *	判断是否是恰当位置的立方体
 *
 *	@param	identity	某个色块组合
 */
- (BOOL)isCubieAtHomeWithIdentity:(ColorCombinationType)identity{
    NSObject<MCCubieDelegate> *targetCubie = [self cubieWithColorCombination:identity];
    BOOL isHome = YES;
    NSDictionary *colorOrientationMapping = [targetCubie getCubieColorInOrientationsWithoutNoColor];
    NSArray *orientations = [colorOrientationMapping allKeys];
    for (NSNumber *orientation in orientations) {
        switch ([self centerMagicCubeFaceInOrientation:(FaceOrientationType)[orientation integerValue]]) {
            case Up:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != UpColor) {
                    isHome = NO;
                }
                break;
            case Down:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != DownColor) {
                    isHome = NO;
                }
                break;
            case Left:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != LeftColor) {
                    isHome = NO;
                }
                break;
            case Right:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != RightColor) {
                    isHome = NO;
                }
                break;
            case Front:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != FrontColor) {
                    isHome = NO;
                }
                break;
            case Back:
                if ([[colorOrientationMapping objectForKey:orientation] integerValue] != BackColor) {
                    isHome = NO;
                }
                break;
            case WrongOrientation:
                isHome = NO;
                break;
        }
        if (!isHome) {
            break;
        }
    }
    return isHome;
}

/**
 *	判断魔方里所有的立方体是否符合应该在的位置
 *
 *	@return	返回YES说明魔方的旋转已正常完成
 */
- (BOOL)isFinished{
    // 0 - 12
    for (int i = 0; i < 13; i++) {
        if (![self isCubieAtHomeWithIdentity:(ColorCombinationType)i]) {
            return NO;
        }
    }
    // 跳过13，因为第13个方块位于魔方中心
    // 14 -26
    for (int i = 14; i < 27; i++) {
        if (![self isCubieAtHomeWithIdentity:(ColorCombinationType)i]) {
            return NO;
        }
    }
    
    return YES;
}


/**
 *	更新魔方中含有的27个立方体
 *   The center color must be stable. Otherwise, it will bring up some problems.
 */
- (NSArray *)updateIndexAccordingToCubies{
    BOOL updateSuccess = YES;
    
    for (int i = 0; i < ColorCombinationTypeBound; i++) {
        _magicCubiesList[i] = nil;
    }
    
    for (int i = 0; i < ColorCombinationTypeBound; i++) {
        // 0 < X,Y,Z < 3
        int x = i % 3;
        int y = i / 3 % 3;
        int z = i / 9;
        
        if (x != 1 || y != 1 || z != 1) {
            ColorCombinationType newIdentity = [_magicCubies3D[x][y][z] identity];
            
            // If there are two same cubies, error occures.
            if (_magicCubiesList[i] != nil) {
                updateSuccess = NO;
                break;
            }
            
            // Update list index.
            _magicCubiesList[newIdentity] = _magicCubies3D[x][y][z];
        }

    }
    
    if (!updateSuccess) {
        for (int z = 0; z < 3; z++) {
            for (int y = 0; y < 3; y++) {
                for (int x = 0; x < 3; x++) {
                    _magicCubiesList[x + y * 3 + z * 9] = _magicCubies3D[x][y][z];
                }
            }
        }
    }
    
    
    return nil;
}

/**
 *  颠倒魔方
 *
 *	This function will flip the magic cube.
 * The result will be that:
 *
 * UpColor face Up
 * DownColor face Down
 * FrontColor face Front
 * BackColor face Back
 * LeftColor face Left
 * RightColor face Right
 */
- (void)resetCenterFaceOrientation{
    [self rotateWithSingmasterNotation:
     [MCTransformUtil getPathToMakeCenterCubieAtPosition:[self coordinateValueOfCubieWithColorCombination:DColor]
                                           inOrientation:Down]];
    
    [self rotateWithSingmasterNotation:
     [MCTransformUtil getPathToMakeCenterCubieAtPosition:[self coordinateValueOfCubieWithColorCombination:FColor]
                                           inOrientation:Front]];
}

/**
 *	返回由6*9个颜色标签组成的描述状态的字符串
 *
 *	@return	UpFrontRightDownLeftBack
 */
- (NSString *)stateString{
    if (_orientationToMagicCubeFace[Up] != Up || _orientationToMagicCubeFace[Front] != Front) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:54];
    
    // Up face
    for (int z = 0; z < 3; z++) {
        for (int x = 0; x < 3; x++) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[x][2][z] faceColorInOrientation:Up]]];
        }
    }
    
    // Front face
    for (int y = 2; y >= 0; y--) {
        for (int z = 2; z >= 0; z--) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[2][y][z] faceColorInOrientation:Right]]];
        }
    }
    
    // Right face
    for (int y = 2; y >= 0; y--) {
        for (int x = 0; x < 3; x++) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[x][y][2] faceColorInOrientation:Front]]];
        }
    }
    
    // Down face
    for (int z = 2; z >= 0; z--) {
        for (int x = 0; x < 3; x++) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[x][0][z] faceColorInOrientation:Down]]];
        }
    }
    
    // Left face
    for (int y = 2; y >= 0; y--) {
        for (int z = 0; z < 3; z++) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[0][y][z] faceColorInOrientation:Left]]];
        }
    }
    
    // Back face
    for (int y = 2; y >= 0; y--) {
        for (int x = 2; x >= 0; x--) {
            [result appendString:[MCTransformUtil getStringTagOfFaceColor:[_magicCubies3D[x][y][0] faceColorInOrientation:Back]]];
        }
    }
    
    
    return [NSString stringWithString:result];
}

/**
 *	判断是否所有的面已经填充了颜色
 */
- (BOOL)hasAllFacesBeenFilledWithColors{
    for (int i = 0; i < 13; i++) {
        if (![_magicCubiesList[i] hasAllFacesBeenFilledWithColors]) {
            return NO;
        }
    }
    for (int i = 14; i < 27; i++) {
        if (![_magicCubiesList[i] hasAllFacesBeenFilledWithColors]) {
            return NO;
        }
    }
    
    return YES;
}


@end
