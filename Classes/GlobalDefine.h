//
//  TPGlobalDefine.h
//  TP
//
//  Created by Aha on 13-6-13.
//  Copyright (c) 2013年 Aha. All rights reserved.
//

#pragma once
#ifndef TwoPhase_Global_h
#define TwoPhase_Global_h

//++++++++++++++++++++ Names the colors of the cube facelets ++++++++++++++++++++++++++++++++++++++
/**
 *	TP == TwoPhase
 *
 *  该命名空间放着的是实现two-phase算法所需的基本类型
 *
 *  来自网上的资料：
 *
 *  两阶段搜索算法中文版本: 两阶段搜索算法 ( 翻译by Roundy,呵呵,乱译.) (如果您在利用本译文研究时导致您的脑子或者您的魔方或者计算机等损坏,本人概不负责) 下面的介绍尝试给你一个关于这个算法基本的概念. 
 *
 *  (3阶)魔方的六个面我们分别叫U(上),D(下),R(右),L(左),F(前) 和B(后). U的意思就是把'上'面顺时针旋转90度.而U2的意思是把'上'面顺时针旋转180度.U'的意思是把'上'面逆时针旋转90度. 一个移动序列如 U D R' D2 ,我们称之为一个'步法'. 如果你在拧魔方的时候不使用R, R', L, L', F, F', B和B',那么会生成一个状态子集.这个子集我们用G1=<U,D,R2,L2,F2,B2>表示.在这个子集里面,角块和边块的方向是不会改变的(这点在盲拧中我们也可以体会到,译者注).那就是说,对于一个块(边块或角块)而言,他的方向是不会改变的.而UD间夹心的那四块边块仍然会待在UD间.(那么自然,U/D面的边角块仍然会待在U/D面) 
 *  
 *  在第1阶段的搜索中,本算法会查找能把一个打乱的魔方变成G1状态的步法.那就是说,做完该步后,整个魔方边/角块方向都被纠正.UD间夹心的那四块边块被运到UD间(那么自然,U/D面的边角块会待在U/D面).在这个抽象的空间里,移动魔方一步会把代表魔方状态的三位组(x,y,z)变成(x',y',z'),所有G1状态的魔方都拥有相同的三位组(x0,y0,z0).而这就是第1阶段搜索的目标.
 *
 *  为了达到这个目标,本程序使用了一种正在研究中的叫做 下限启发式迭代深度A星算法,缩写为IDA*(晕,不知道怎么翻译好,但大概知道这种算法的优点是省内存).在第2阶段搜索中,它会给出需求解的魔方确切的达到G1状态的最少步数.这种启发式的算法可以在产生解法的时候提前剪枝,这让你不需要等待一段非常非常长的时间来等结果.这种启发式的算法h1使用的是基于内存的查表方法,最多允许提前12步做出判断剪枝. 
 *
 *  在第2阶段搜索中,本算法使用G1步法(U,D,R2,L2,F2,B2)来复原魔方.实际上就是复原 8个角块,U/D面的8个边块和UD面夹心的那四块的位置.启发式函数 h2(a,b,c) 只对复原六面的步法长度内的情况做出评估,因为G1子集里面的情况实在太多了. 本算法不会在找到上面的解法后停止,而是会继续的在第一阶段的结果基础上继续展开第二阶段的搜索.举一个例子,如果上面的解法找到第1阶段需要10步,第2阶段需要12步,但后面搜索的结果可能是第1阶段11步,而第2阶段变成了5步.第1阶段的步法长度增加了,但第2阶段的步法减少了.如果第2阶段的步法长度减少到0.那么这个解法是优化完毕的,算法结束.
 *
 *  当前的两阶段搜索算法并不能在所有的情况下都找到最优解,在这种情况下我们必须倒回头,继续做一次2阶段搜索.这会增加相当多大的时间.如果你确实需要优化一些情况,你可以使用' 优化'(Optimal)选项. 最后举个例子让大家体会上面所说的内容.用步法D2 F2 L2 B2 U B2 U L' F R2 D2 U2 L D2 B' U F' R2 U2打乱一个已复原六面的魔方,然后使用cube explorer求出解法U2 R2 F U' B D2 L' U2 D2 R2 F' L U' B2 U' B2 L2 F2 D2 .我们可以看到,整个解法可以分为两步 (U2 R2 F U' B D2 L' U2 D2 R2 F' L)*(U' B2 L2 F2 D2),你可以尝试在'*'号的位置停下来看一看整个魔方的状态,加深一下对这个算法的感性认识.
 *
 *  @see http://kociemba.org/cube.htm
 *
 *  @see http://blog.renren.com/share/277247847/15426217791 关于计算机解魔方的各种扯淡
 */
namespace TP{
    /**
     *	faceColor type
     */
    enum Color {
        U, R, F, D, L, B
    };



    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /**
     *	色块组合，决定了立方块所在的位置
     *  
     *  这里是八个角色块
     */
    //The names of the corner positions of the cube. Corner URF e.g., has an U(p), a R(ight) and a F(ront) facelet
    enum Corner {
        URF, UFL, ULB, UBR, DFR, DLF, DBL, DRB
    };


    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    /**
     *	色块组合，决定了立方块所在的位置
     *
     *  这里是十二个边色块
     */
    //Then names of the edge positions of the cube. Edge UR e.g., has an U(p) and R(ight) facelet.
    enum Edge {
        UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR
    };


    /**
     * <pre>
     * The names of the facelet positions of the cube
     *             |************|
     *             |*U1**U2**U3*|
     *             |************|
     *             |*U4**U5**U6*|
     *             |************|
     *             |*U7**U8**U9*|
     *             |************|
     * ************|************|************|************|
     * *L1**L2**L3*|*F1**F2**F3*|*R1**R2**F3*|*B1**B2**B3*|
     * ************|************|************|************|
     * *L4**L5**L6*|*F4**F5**F6*|*R4**R5**R6*|*B4**B5**B6*|
     * ************|************|************|************|
     * *L7**L8**L9*|*F7**F8**F9*|*R7**R8**R9*|*B7**B8**B9*|
     * ************|************|************|************|
     *             |************|
     *             |*D1**D2**D3*|
     *             |************|
     *             |*D4**D5**D6*|
     *             |************|
     *             |*D7**D8**D9*|
     *             |************|
     * </pre>
     *
     *A cube definition string "UBL..." means for example: In position U1 we have the U-color, in position U2 we have the
     * B-color, in position U3 we have the L color etc. according to the order U1, U2, U3, U4, U5, U6, U7, U8, U9, R1, R2,
     * R3, R4, R5, R6, R7, R8, R9, F1, F2, F3, F4, F5, F6, F7, F8, F9, D1, D2, D3, D4, D5, D6, D7, D8, D9, L1, L2, L3, L4,
     * L5, L6, L7, L8, L9, B1, B2, B3, B4, B5, B6, B7, B8, B9 of the enum constants.
     */
    enum Facelet {
        U1, U2, U3, U4, U5, U6, U7, U8, U9, R1, R2, R3, R4, R5, R6, R7, R8, R9, F1, F2, F3, F4, F5, F6, F7, F8, F9, D1, D2, D3, D4, D5, D6, D7, D8, D9, L1, L2, L3, L4, L5, L6, L7, L8, L9, B1, B2, B3, B4, B5, B6, B7, B8, B9
    };

}

#endif