//
//  Global.h
//  RubiksCube
//
//  Created by Aha on 12-9-24.
//  Copyright (c) 2012年 Aha. All rights reserved.
//
/**
 *	@file
 *  这个文件里描述了魔方的很多基础性的表示
 */
#pragma once
#ifndef RubiksCube_Global_h
#define RubiksCube_Global_h
/**
 *	命名空间MC中定义了与各种状态有关的常量和枚举类型
 *  注意这里面的东西将会被频繁使用到，尤其在DataModel部分
 *  还有，枚举类里枚举变量的顺序都是有特定意义的
 */
namespace MC{
    /**
     *	3D point 
     */
    struct Point3i{
        int x;
        int y;
        int z;
    };
    
#pragma mark - 立方体状态描述的相关枚举类
    
    /**
     *	define the face color type to apart color data from model
     */
    typedef enum _FaceColorType {
        UpColor     = 0,
        DownColor   = 1,
        FrontColor  = 2,
        BackColor   = 3,
        LeftColor   = 4,
        RightColor  = 5,
        NoColor     = 6
    } FaceColorType;

    /// The color mapping file name
    #define FACE_COLOR_MAPPING_FILE_NAME @"FaceColorMapping"

    /// Keys for getting real color
    #define KEY_UP_FACE_COLOR      @"UpColor"
    #define KEY_DOWN_FACE_COLOR    @"DownColor"
    #define KEY_FRONT_FACE_COLOR   @"FrontColor"
    #define KEY_BACK_FACE_COLOR    @"BackColor"
    #define KEY_LEFT_FACE_COLOR    @"LeftColor"
    #define KEY_RIGHT_FACE_COLOR   @"RightColor"

    /**
     *	define the orientation of face
     */
    typedef enum _FaceOrientationType {
        Up      = 0,
        Down    = 1,
        Front   = 2,
        Back    = 3,
        Left    = 4,
        Right   = 5,
        WrongOrientation    = 6
    } FaceOrientationType;

    /// three types of cubies
    typedef enum _CubieType {
        NoType,
        CentralCubie,
        EdgeCubie,
        CornerCubie
    } CubieType;

    /// define the rotation direction, clockwise and anticlockwise
    typedef enum _LayerRotationDirectionType {
        CW  = 0,
        CCW = 1
    } LayerRotationDirectionType;

    /// 3D coordinate axis
    typedef enum _AxisType {
        X   = 0,
        Y   = 1,
        Z   = 2
    } AxisType;

    /**
     * 表示立方块带有的颜色组合(色块组合)
     * 注意以下的枚举类型的顺序是固定的，分别表示[0][0][0] 到 [2][2][2]的三维坐标上立方块的位置
     * name after direction in this order:front(F), back(B), left(L), right(R), up(U), down(D)
     * e.g. BLD is the cube that has three colors:BACK_COLOR, LEFT_COLOR, DOWN_COLOR
     */
    typedef enum _ColorCombinationType {
        BLDColors, BDColors, BRDColors, // [0][0][0] - [0][0][2]
        BLColors, BColor     , BRColors,
        BLUColors, BUColors, BRUColors,
        LDColors , DColor  , RDColors ,
        LColor  , CenterBlank, RColor  ,
        LUColors , UColor  , RUColors ,
        FLDColors, FDColors, FRDColors,
        FLColors, FColor     , FRColors,
        FLUColors, FUColors, FRUColors, 
        ColorCombinationTypeBound
    } ColorCombinationType;
    
#pragma mark - 构造关于魔方解法的领域特定语言
    
    /**
     *	the node pattern type
     */
    typedef enum _NodeType {
        ExpNode,
        ElementNode,
        PatternNode,
        ActionNode,
        InformationNode
    } NodeType;

    /// the expression type
    typedef enum _ExpType {
        And,
        Or,
        Sequence,
        Not
    } ExpType;

    /**
     *	the rull(rule?) action type
     */
    typedef enum _ActionType {
        Rotate,
        FaceToOrientation,
        LockCubie,
        UnlockCubie
    } ActionType;

    /// the getting information type
    typedef enum _InformationType {
        getCombinationFromOrientation = 0,
        getFaceColorFromOrientation = 1,
        lockedCubie = 2,
        getCombinationFromColor = 3
    } InformationType;

    /// the pattern type
    typedef enum _PatternType {
        Home,
        Check,
        ColorBindOrientation,
        At,
        NotAt,
        CubiedBeLocked,
    } PatternTyp;

    /// Token tag

    #define Token_And -1
    #define Token_Or -2
    #define Token_LeftParentheses -3
    #define Token_RightParentheses -4
    #define Token_Not -5
    #define PLACEHOLDER -10000

    /**
     *the rull action type
     *Singmaster 的 魔方标记法
     *Singmaster是一个人，他的成就：
     *@see http://zh.wikipedia.org/wiki/%E5%A4%A7%E8%A1%9B%C2%B7%E8%BE%9B%E9%A6%AC%E6%96%AF%E7%89%B9
     *关于这种标记法的介绍：
     *@see http://rubiks.wikia.com/wiki/Notation (English)
     *@see http://www.mf100.org/base/about.php (中文)
     *后文暂且称呼这种类型为动作类型
     */
    typedef enum _SingmasterNotation {
        F, Fi, F2,
        B, Bi, B2,
        R, Ri, R2,
        L, Li, L2,
        U, Ui, U2,
        D, Di, D2,
        x, xi, x2,
        y, yi, y2,
        z, zi, z2,
        Fw,Fwi,Fw2,
        Bw,Bwi,Bw2,
        Rw,Rwi,Rw2,
        Lw,Lwi,Lw2,
        Uw,Uwi,Uw2,
        Dw,Dwi,Dw2,
        M, Mi, M2,
        E, Ei, E2,
        S, Si, S2,
        NoneNotation
    } SingmasterNotation;

    /**
     * the result indicates whether the current rotation accords the required rotation
     * 反应当前旋转的结果，尤其是是否与所需的旋转相符合
     */
    typedef enum _RotationResult{
        Accord,
        Disaccord,
        StayForATime,
        Finished,
        NoneResult
    } RotationResult;


    //-------------------------------------------------------------------------------------------

    /// It indicates that no layer was selected.
    #define NO_SELECTED_LAYER -999


    //----------------------------------Knowledge base part--------------------------------------
#pragma mark - knowledge database
    /// the knowledge db name
    #define KNOWLEDGE_DB_FILE_NAME @"KnowledgeBase.sqlite3"

    #define ETFF 0  /// method 0, 8355

    /// the state of magic cube when everything is unknown.
    #define UNKNOWN_STATE @"Unknown"

    /// every method`s first state name
    #define START_STATE     @"Init"
    /// every method`s last state name
    #define END_STATE       @"End"

    /// At most time, the general number of states of the specified method
    #define GENERAL_STATES_NUM 10

    /// At most time, the general number of rules of specified state
    #define GENERAL_RULES_NUM 20

    /// the pattern table name
    #define DB_PATTERN_TABLE_NAME @"PATTERNS"

    /// the rule table name
    #define DB_RULE_TABLE_NAME @"RULES"

    /// the special pattern table name
    #define DB_SPECIAL_PATTERN_TABLE_NAME @"SPECIAL_PATTERNS"

    /// the special rule table name
    #define DB_SPECIAL_RULE_TABLE_NAME @"SPECIAL_RULES"

    /// the state table name
    #define DB_STATE_TABLE_NAME @"STATES"

    //-------------------------------------------------------------------------------------------

    /// the temprorary file store the unfinished magic cube's status
    #define TmpMagicCubeData @"tmpMagicCube"

    /// the temprorary file store the unfinished magic cube's status
    #define TmpInputMagicCubeData @"tmpInputMagicCube"
    
    /// the temprorary file store the unfinished magic cube's status
    #define TmpCounttingPageMagicCubeData @"tmpCounttingPageMagicCube"

    
    //Helper------------------------------------------------------------------------------------
    #pragma mark - helper
    /// the keys that get actions
    #define KEY_ROTATION_QUEUE @"RotationQueue"
    #define KEY_TIPS @"TipsMessage"
    #define KEY_LOCKED_CUBIES @"LockedCubies"

    /// There is two types of rules to be applied.
    typedef enum _AppliedRuleType {
        General,
        Special
    } AppliedRuleType;

    //-------------------------------------------------------------------------------------------

    /// There is three types of rotation relevant to axis, layer and direction.
    typedef enum _RotationLayerMode {
        Single,
        Double,
        Trible,
        SingleTwoTimes,
        DoubleTwoTimes,
        TribleTwoTimes
    } RotationLayerMode;


    /// an encapsulation
    struct RotateNotationType {
        AxisType axis;
        int layer;
        LayerRotationDirectionType direction;
        RotationLayerMode type;
    };
    //Test switcher--------------------------------------------------------------------------------

    //#define ONLY_TEST

    //Popup item attr------------------------------------------------------------------------------
    #pragma mark- popup item attr

    #define POPUP_ITEM_WINDOW_SIZE_RATIO 0.1
    #define K_QUADCURVE_MENU_DEFAULT_NEAR_RADIUS 95.0f
    #define K_QUADCURVE_MENU_DEFAULT_END_RADIUS 100.0f
    #define K_QUADCURVE_MENU_DEFAULT_FAR_RADIUS 110.0f
    #define K_QUADCURVE_MENU_DEFAULT_TIME_OFFSET 0.036
    #define K_QUADCURVE_MENU_DEFAULT_ROTATE_ANGLE 0.0
    #define K_QUADCURVE_MENU_DEFAULT_WHOLE_ANGLE 3.1415926535898 * 2
    #define K_QUADCURVE_MENU_DEFAULT_SELECT_ANIM_LAST_TIME 0.3f
    #define K_QUADCURVE_MENU_DEFAULT_OPEN_ANIM_LAST_TIME 0.3f
    #define K_QUADCURVE_MENU_DEFAULT_CLOSE_ANIM_LAST_TIME 0.2f


    //-------------------------------------------------------------------------------------------

}

using namespace MC;

#endif
