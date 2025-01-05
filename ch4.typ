#import "@preview/mitex:0.2.4": *

#heading[第四章：频率域滤波]

在空域不好解决的问题，在频域上可能变得非常容易（性能及时间上）;不同于空域像素的调整，对频谱系数修改会作用于整个空域图像。空域适合：局部特征、实时操作、简单的像素级调整。频域适合：全局特征、复杂操作、周期性噪声去除、压缩等。

== 采样

周期冲激串 $s_(Delta T)(t) = sum_(n = - infinity)^infinity delta(x-n Delta T)$ \ 取样后函数$tilde(f)(t) = f(t) s_(Delta T)(t) = sum_(n = - infinity)^infinity f(t) delta(t - n Delta T)$ \ 积分得到取样点的值$f_k (k) = integral_(- oo)^oo f (t) delta (t - k Delta T) upright(d) t = f (k Delta T)$\
采样定理:采样率$f_s$应大于等于信号最高频率的两倍，即$f_s>2f_max$，否则会出现混叠现象。\


== 单变量的傅里叶变换

连续 $f(t) = integral_(-infinity)^infinity F(mu) e^(j 2 pi mu t) d mu quad F(mu) = integral_(-infinity)^infinity$ ; $f(t) e^(-j 2 pi mu t) d t$\
离散 $u,x in [0,M-1]$ \
$F(u) = sum_(x = 0)^(M - 1) f(x) e^(-j 2 pi u x \/ M)$ ; $f(x) = frac(1, M) sum_(u = 0)^(M - 1) F(u) e^(j 2 pi u x \/ M)$\
冲激性质:$integral_(- oo)^oo e^(j omega t) upright(d) omega = 2 pi delta (t)$ ; $f(t) delta(t) = f(0) delta(t)$ ; $integral_(-infinity)^infinity f(t) delta(t - t_0) dif t = f(t_0)$\

$sum_(k = 0)^(n - 1) e^(-i 2 pi frac(m k, n)) =brace.l
mat(delim: #none, n comma, "如果 " m equiv 0(upright(m o d) n);
0 comma, "否则",,)$;$integral_(-infinity)^(+infinity) e^(-x^2) d x = sqrt(pi)$


== 二变量函数的傅里叶变换

二维傅里叶变换是一维情形向两个方向的简单扩展\
$F(u, v) = integral_(-infinity)^(+infinity) integral_(-infinity)^(+infinity) f(t, z) e^(-j 2 pi(u t + v z)) d t d z$ ;
$f(t, z) = integral_(-infinity)^(+infinity) integral_(-infinity)^(+infinity) F(u, v) e^(j 2 pi(mu t + v z)) d u d v$\
采样：$tilde(f)(t, z) = f(t, z) s_(Delta T Delta Z)(t, z) = sum_(m = - infinity)^(infinity) sum_(n = - infinity)^(infinity) f(t, z) sigma(t - m Delta T, z - n Delta Z)$\
DFT：$F(u, v) = sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) f(x, y) e^(-j 2 pi(u x \/ M + v y \/ N))$\
IDFT：$f(x, y) = frac(1, M N) sum_(u = 0)^(M - 1) sum_(v = 0)^(N - 1) F(u, v) e^(j 2 pi(u x \/ M + v y \/ N))$

=== 二维DFT和IDFT性质
//表4.3
*谱* $lr(|F(u comma nu)|) = [ R^2 (u, nu) + I^2 (u, nu) ]^(1 \/ 2))$ 相角$phi.alt(u, v) = arctan  [ frac(I(u comma v), R(u comma v))  ]$ R实部,I虚部\
*极坐标* $F(u comma nu) = lr(|F(u comma nu)|) e^(j phi.alt(u, v)) $\
周期性(k为整数) $F(u, v) = F(u + k_1 M, v + k_2 N)$ \ $f(x, y) = f(x + k_1 M, y + k_2 N)$

*卷积* $(f star h)(x, y) = sum_(m = 0)^(M - 1) sum_(n = 0)^(N - 1) f(m, n) h(x - m, y - n)$

*相关* $(f star.stroked h)(x, y) = sum_(m = 0)^(M - 1) sum_(n = 0)^(N - 1) f^* (m, n) h(x + m, y + n)$

*使用DFT算法求IDFT* $M N f^* (x, y) = sum_(u = 0)^(M - 1) sum_(v = 0)^(N - 1) F^* (u, v) upright(e)^(-upright(j) 2 pi(u x \/ M + nu y \/ N))$ 结果取复共轭并除以MN就可得到反变换; *共轭对称性*$F(-u, - v) = F^* (u, v)$\
//表4.4
*离散单位冲激* $delta(x, y) arrow.l.r.double 1, 1 arrow.l.r.double M N delta(u, v)$\
*卷积定理*$(f star h)(x, y) arrow.l.r.double(F dot.op H)(u, v) || (f dot.op h)(x, y) arrow.l.r.double frac(1, M N)(F star H)(u, v)$

*平移性* $f(x, y) upright(e)^(upright(j) 2 pi(u_0 x \/ M + v_0 y \/ N)) arrow.l.r.double F(u - u_0, v - v_0) $ \ $f(x - x_0, y - y_0) arrow.l.r.double F(u, v) upright(e)^(-upright(j) 2 pi(u x_0 \/ M + nu y_0 \/ N))$\
$delta(x - a, y - b) arrow.l.r.double e^(-j 2 pi(u a + v b))$

== 频率域滤波
(1)对图像f(x,y)进行零填充(长宽均变为两倍，变为$P times Q$\
//防止交叠错误
(2)频谱中心化：用$(-1)^(x+y)=e^(j pi(x + y))$乘以填充后的图像\
(3)计算`(2)`结果的DFT，即$F(u,v);$\
(4)用滤波器函数(中心在(P/2,Q/2))$H(u,v)$乘以$F( u, v) :G(u, v) = H(u, v) F(u, v)$\
(5)计算`(4)`中结果的IDFT，$g(x, y) = F^(-1)(G(u, v)) $理论值为实数，计算误差会导致寄生复成分\
(6)得到`(5)`结果中的实部;\
(7) 用$(-1)^{(x+y)}$乘以(6)中的结果\
(8)提取(7)中的左上角(与输入图像同大小)。


== 低通频率域滤波器
理想低通滤波器ILPF $D_0$为截止频率;$D(u comma v) = [(u - M \/ 2)^2 +(v - N \/ 2)^2 ]$ ; $H(u comma v) =brace.l
mat(delim: #none, 1 comma, D(u comma v) lt.eq D_0;
0 comma, D(u comma v) > D_0,); $\
截止频率位置 D0决定了通过的频率成分所包含的功率, 以及在总功率中所占的比例\
总功率$P_T = sum_(u = 0)^(P - 1) sum_(v = 0)^(Q - 1) P(u, v) = sum_(u = 0)^(P - 1) sum_(v = 0)^(Q - 1) lr(|F(u comma v)|)^2$\
在D(u,v)内的功率占比 $alpha = 100 dot.op(sum_u sum_v P(u, v) \/ P_T) quad w h e r e quad D(u, v) lt.eq D_0$\
理想的低通滤波器无法通过电子元件实现;通过计算机模拟会出现模糊与振铃现象\
巴特沃斯BLPF $H(u, v) = frac(1, 1 + [ D(u comma v) \/ D_0 ]^(2 n))$ ;
高斯GLPF $H(u, v) = e^(-D^2 (u, v) \/ 2 D_0^2)$ 无振铃效应\
例子:低分辨率文本字符修复,面部柔和,去除传感器扫描线

== 高通滤波器

对低通滤波相反操作得到高通：\
$H_(H P)(u,v)=1-H_(L P)(u,v)$; $h_(H P)= delta (x , y) - h_(L P) (x , y) eq.not 1 - h_(L P) (x , y)$\
理想IHPF：$H(u, v) =brace.l mat(delim: #none, 0 comma, D(u comma v) lt.eq D_0; 1 comma, D(u comma v) > D_0)$\
巴特沃斯：$H(u, v) = frac(1, 1 + [ D_0 \/ D(u comma v) ]^(2 n))$ ; 高斯：$H(u, v) = 1 - e^(-D^2 (u, v) \/ 2 D_0^2)$\
频域拉普拉斯算子： $H (u , v) = - 4 pi^2 (u^2 + v^2)$
中心化版$H (u , v) = - 4 pi^2 [(u - P \/ 2)^2 + (v - Q \/ 2)^2] = - 4 pi^2 D^2 (u , v)$\
基于锐化滤波的图像增强$g (x , y) = f (x , y) + c nabla^2 f (x , y)$;其中二阶梯度傅里叶变换为H*F\
高提升滤波：$H_(h b)(u, v) =(A - 1) + H_(h p)(u, v)$\
高频加强滤波：$H_(h f e)(u, v) = a + b H_(h p)(u, v)$ a控制原始贡献，b控制高通贡献\
同态滤波 $H(u, v) =(gamma_H - gamma_L) [ 1 - e^(-c(D^2 (u, v) \/ D_0^2)) ] + gamma_L$ 衰减图像的低频成分（光照分量），增强高频成分（反射分量）\
其中$gamma_L<1$低频成分增益因且$gamma_H>1$高频成分增益因子;$c$用于控制滤波器函数斜面的锐化

== 带阻滤波器
// #image("./img/带阻滤波器.png",height: 3%)
理想带阻(IBRF) $H(u, v) =cases(0 " " C_0 - frac(W, 2) lt.eq D(u comma v) lt.eq C_0 + frac(W, 2), 1 " " "其他情况")$
高斯带阻(GBRF) $H(u, v) = 1 - e^(-(frac(D^2 (u comma v) - C_0^2, D(u comma v) W))^2)$\
巴特沃斯带阻 (BBRF) $H(u, v) = frac(1, 1 +(frac(D(u comma v) W, D^2 (u comma v) - C_0^2))^(2 n))$
带阻作用:去除摩尔纹;去除周期干扰
== 快速傅里叶变换
利用傅里叶变换基底性质，将$M$个数据的傅里叶变换转为2组$M/2$个数据的傅里叶变换，此时计算量从 $M^2$ 降低为 $M^2/2$\
$F(u) = sum_(x = 0)^(K - 1) f(2 x) W_(2 K)^(u(2 x)) + sum_(x = 0)^(K - 1) f(2 x + 1) W_(2 K)^(u(2 x + 1))$ 偶数部分+奇数部分\
$W_M = e^(-j 2 pi \/ upright(M))$ ; $W_M^(u x) = (W_M)^(u x) = e^(- j 2 pi u x \/ M)$ ; $ W_(2 K) ""^(2 u x) = W_k ""^(u x)$

$F_(e v e n)(u) = sum_(x = 0)^(K - 1) f(2 x) W_K^(u x) quad F_(o d d)(u) = sum_(x = 0)^(K - 1) f(2 x + 1) W_K^(u x)$

$F(u) = F_(e v e n)(u) + F_(o d d)(u) W_(2 K)^u \ F(u + K) = F_(e v e n)(u) - F_(o d d)(u) W_(2 K)^u$
