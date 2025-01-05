
#import "@preview/mitex:0.2.4": *
#heading[第六章：彩色图像处理]

== 彩色基础

红,绿,蓝量用X,Y,Z表示,叫三色值 ; 三色系数定义: $x = frac(X, X + Y + Z);...;x+y+z=1$;\
描述彩色光源的质量的三个基本量：辐射亮度：从光源流出的总能量，单位为瓦特(W)；发光强度：观察者从光源感知的总能量，单位为流明(红外的光强接近零)；亮度：主观描绘子，不可测量，体现发光强度的消色概念。\
区分不同颜色:色调: 感知的主导色，跟主波长相关;饱和度: 相对纯度，与一种色调混合的白光量;亮度: 发光强度的消色概念.色调和饱和度一起称为色度
== 彩色模型

=== RGB

针对彩色显色器和彩色摄像机开发,一个颜色有8比特,$2^8=256$种颜色,全彩色则是24比特图像

// #image("./img/rgb.png",height: 5%)
=== CMYK

颜料颜色,针对彩色打印开发;CMY(青色、深红、黄色)是RGB的补色;K是黑色,用于调节色彩\
RGB->CMY: $mat(C; M; Y) = mat(1; 1; 1) - mat(R; G; B)$\
RGB->CMYK:$K = 1 - max(R comma G comma B); C = frac(1 - R - K, 1 - K); M = frac(1 - G - K, 1 - K); Y = frac(1 - B - K, 1 - K)$

CMY->CMYK: $K=min(C,M,Y)$$K=1$则CMY都是0;\
$K eq.not 1$则$C =(C - K) \/(1 - K); M =(M - K) \/(1 - K); Y =(Y - K) \/(1 - K)$

CMYK->CMY: $C = C(1 - K) + K; M = M(1 - K) + K; Y = Y(1 - Y) + K$

=== HSI
针对人们描述和解释颜色的方式开发，解除了亮度和色彩信息的联系;
h色调(角度),s饱和度(鲜艳程度),i强度(颜色的明暗程度,平均灰度)
#image("./img/hsi.png",height: 10%)

RGB->HSI\
$theta=arccos(frac((R - G) +(R - B), 2 sqrt((R - G)^2 +(R - B)(G - B))))$ $H = cases(360 - theta  && G<B, theta & G>=B)$\
$S = 1 - frac(3, R + G + B) dot.op  min(R, G, B)$ $I = frac(R + G + B, 3)$

HSI->RGB\
1.RG扇区$0^circle.small lt.eq H < 120^circle.small$\
$& R = I dot.op (1 + frac(S dot.op  cos(H), cos(60^circle.small - H))) ;
& G = 1-(R+B) ;
& B = I dot.op (1 - S)$\
2.GB扇区($120^circle.small lt.eq H < 240^circle.small$\
$& H' = H - 120^circle.small \
& G = I dot.op (1 + frac(S dot.op cos(H'), cos(60^circle.small - H'))) ;
& B = 1-(R+G)  ;
& R = I dot.op (1 - S)$\
3.BR扇区$240^circle.small lt.eq H < 360^circle.small$\
$& H' = H - 240^circle.small \
& B = I dot.op (1 + frac(S dot.op cos(H'), cos(60^circle.small - H'))) ;
& R =  1-(G+B)  ;
& G = I dot.op (1 - S)$

=== CIE LAB
基于人眼视觉感知的模型，不依赖于具体的设备（如显示器、打印机等），因此可以在不同设备之间保持颜色的一致性。\
$X_w = 0.95047,   Y_w = 1.000,  Z_w = 1.08883$\
$L_star = 116 * h(Y / Y_W) - 16$;$a_star = 500 * [h(X / X_W) - h(Y / Y_W)]$;$b_star = 200 * [h(Y / Y_W) - h(Z / Z_W)]$\
$h(q) = cases((3 / 2) * q^(1/3)&q > 0.008856 ,7.787 * q + 16 / 116 &  q <= 0.008856
)$\
L表示亮度，范围从0（黑色）到100（白色）。a表示从绿色到红色的轴。b表示从蓝色到黄色的轴。h(q)是一个辅助函数，用于处理非线性变换。

== 假彩色
*采用多种颜色进行灰度分层*：[0,L-1]灰度级别,分为P+1个区间,$I_1, I_2, dots.c, I_(P + 1)$,属于某个区间就赋值一个彩色;若$f(x, y) in I_k$则令$f(x, y) = c_k$
*假彩色增强*：设置$f_R,f_G,f_B$三个函数,把灰度映射为不同通道的颜色
== 全彩色图像处理基础
1.标量框架：分别处理每幅灰度级分量图像（像素值为标量），将处理后的各分量图
像合成一幅彩色图像。 2.向量框架：直接处理彩色像素，将彩色像素视为向量处理。
== 彩色变换
//6.5
$s_i = T_i (r_i), quad i in [i,n]$ n为分量图像总数,ri为输入i分量灰度,$s_i$为输出i分量灰度\
三种颜色模型下提高亮度: RGB三个分量乘以常数k;CMY求线性变化$s_i = k r_i +(1 - k), quad i = 1, 2, 3$;CMYK只需改变第四个分量(K)$s_i = k r_i +(1 - k), quad i = 4$\
补色:彩色环：首先等距离地放置三原色，其次将二次色等距离地放置在原色之间
在彩色环上，与一种色调直接相对立的另一色调称为补色
=== 彩色分层

突出图像中某个特定的彩色范围，有助于将目标从周围分离出来;基于假设：在同一色彩空间下，相邻的点具有相近的颜色。\
感兴趣的颜色被宽度为W、中心在原型(即平均)颜色并具有分量$a_j$的立方体(n>3时为超立方体)包围，\
$s_i = cases(0 . 5 comma\, quad [ lr(|r_j - a_j|) > W \/ 2 ]_(1 lt.eq j lt.eq n), r_i comma\, quad "其他",) quad i = 1, 2, dots.c, n$\
用一个球体来规定感兴趣的颜色时\
$s_i = cases(0 . 5 comma\, quad sum_(j = 1)^n (r_j - a_j)^2 > R_0^2, r_i comma\, quad "其他",) quad i = 1, 2, dots.c, n$

== 平滑和锐化

平滑 $overline(c)(x, y) = mat(frac(1, K) sum_((s comma t) in S_(s y)) R(s comma t);; frac(1, K) sum_((s comma t) in S_(s y)) G(s comma t);; frac(1, K) sum_((s comma t) in S_(s y)) B(s comma t))$ ;
锐化 $nabla^2 mat(delim: #none, c(x comma y)) = mat(nabla^2 R(x comma y);; nabla^2 G(x comma y);; nabla^2 B(x comma y))$

== 分割图像

HSI:如果按颜色分割,考虑色调(H);可以用饱和度(S),大于某个阈值分割\
RGB: 令z表示RGB空间中的任意一点,RGB向量a来表示分割颜色样本集平均颜色\
欧氏距离为 $D(z, a) =|z - a| = [(z - a)^upright(T) (z - a) ]^frac(1, 2)= [(z_R - a_R)^2 +(z_G - a_G)^2 +(z_B - a_B)^2 ]^frac(1, 2)$\
$D(z,a)≤D_0$的点的轨迹是半径为$D_0$的一个实心球体\
马哈拉诺比斯距离 $D(z, a) = [(z - a)^upright(T) C^(-1)(z - a) ]^frac(1, 2)$ ;$D(z,a)≤D_0$的点的轨迹是半径为$D_0$的一个实心三维椭球体\
两个方法都计算代价也很高昂,一般用边界盒关于a居中，它沿各坐标轴的长度与样本沿坐标轴的标准差成比例

== RGB边缘检测
Di Zenzo法:不分通道计算梯度的处理方法 ; $upright(bold(u)) = frac(partial R, partial x) upright(bold(r)) + frac(partial G, partial x) upright(bold(g)) + frac(partial B, partial x) upright(bold(b)) quad upright(bold(v)) = frac(partial R, partial y) upright(bold(r)) + frac(partial G, partial y) upright(bold(g)) + frac(partial B, partial y) upright(bold(b))$\
$g_(x x) = upright(bold(u)) dot.op upright(bold(u)) = upright(bold(u))^T upright(bold(u)) = lr(|frac(partial R, partial x)|)^2 + lr(|frac(partial G, partial x)|)^2 + lr(|frac(partial B, partial x)|)^2 g_(y y) = upright(bold(v)) dot.op upright(bold(v)) = upright(bold(v))^T upright(bold(v)) = lr(|frac(partial R, partial y)|)^2 + lr(|frac(partial G, partial y)|)^2 + lr(|frac(partial B, partial y)|)^2$ \
$g_(x y) = upright(bold(u)) dot.op upright(bold(v)) = upright(bold(u))^T upright(bold(v)) = frac(partial R, partial x) frac(partial R, partial y) + frac(partial G, partial x) frac(partial G, partial y) + frac(partial B, partial x) frac(partial B, partial y)$
最大变化率方向$theta (x , y) = 1 / 2 tan^(- 1) [frac(2 g_(x y), g_(x x) - g_(y y))]$\
坐标x,y处$theta$方向的变化率为$F_theta (x , y) = {1 / 2 [(g_(x x) + g_(y y)) + (g_(x x) - g_(y y)) cos 2 theta (x , y) + 2 g_(x y) sin 2 theta (x , y)]}^(1 / 2)$
== 噪声
只有一个RGB通道受到噪声污染时，到HSI的转换会将噪声分布到所有HSI分量图像上

// == 压缩