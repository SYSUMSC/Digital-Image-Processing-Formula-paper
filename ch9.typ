
#import "@preview/mitex:0.2.4": *
#import "@preview/tablex:0.0.6": tablex, hlinex
#import "@preview/tablem:0.1.0": tablem

#heading[第九章：形态学图像处理]
//https://www.bilibili.com/video/BV1r28we5ERQ?spm_id_from=333.788.player.switch&vd_source=52b1b43b72a779e60509273373fde7d4
//p469


/*
== 腐蚀和膨胀

B 对 A腐蚀 只用前景 $A minus.circle B = {z divides (B)_z subset.eq A} = {z divides (B)_z sect A^c = nothing} $


I为整个图，使用前景和背景运算 $I dot.circle B = {z divides (B)_z subset.eq A upright("和") A subset.eq I} union {A^c divides A^c subset.eq I} $

B对A膨胀 $hat(B)$是B旋转180° $A xor B = {z divides (hat(B))_z sect A eq.not diameter} = {z divides [(hat(B))_z sect A] subset.eq A} $

对偶性$  & (A minus.circle B)^c = A^c xor hat(B)\
\
 & (A xor B)^c = A^c minus.circle hat(B) $

== 开运算和闭运算

开运算先腐蚀再膨胀 $A circle.stroked.tiny B = (A minus.circle B) xor B =union.big {(B)_z divides (B)_z subset.eq A} $


闭运算先膨胀再腐蚀 $A bullet B = (A xor B) minus.circle B =[union.big {(B)_z divides (B)_z sect A = nothing}]^c $

对偶性$ (A circle.stroked.tiny B)^c & = (A^c bullet hat(B))\
\
(A bullet B)^c & = (A^c circle.stroked.tiny hat(B)) $

== 击中和击不中

结构元$B_1$检测前景，$B_2$检测背景

$ I ast.circle B_(1 , 2) = {z divides (B_1)_z subset.eq A upright(" 和 ") (B_2)_z subset.eq A^c} = (A dot.circle B_1) sect.big (A^c dot.circle B_2) $

== 基本算法

边界提取，前景-腐蚀结果$beta (A) = A - (A minus.circle B)$

孔洞填充,$I^c$为原图补集$X_k = (X_(k - 1) xor B) sect.big I^c , quad k = 1 , 2 , 3 , dots.h.c$

提取连通分量$X_k = (X_(k - 1) xor B) sect I , quad k = 1 , 2 , 3 , dots.h.c$

=== 凸包

$X_k^i = (X_(k - 1)^i times.circle B^i) union.big X_(k - 1)^i , quad i = 1 , 2 , 3 , 4 upright("和") k = 1 , 2 , 3 , dots.h.c$

使用第i个结构元程序收敛时(即当$X_k=X_(k 1)$时),令$D^i=X^i$凸包为$C (A) = union.big_(i = 1)^4 D^i$

假设${ B } = { B^1 , B^2 , B^3 , dots.h.c , B^n }$


=== 细化=原图-击中击不中

$A times.circle B = A - (A ast.circle B) = A sect.big (A ast.circle B)^c$ 另一公式$A times.circle { B } = ((dots.h.c ((A times.circle B^1) times.circle B^2) dots.h.c) times.circle B^n)$

=== 粗化=原图+击中击不中
$A dot.circle B = A union.big (A ast.circle B)$ 另一公式$A dot.circle { B } = ((dots.h.c ((A dot.circle B^1) dot.circle B^2) dots.h.c) dot.circle B^n)$

=== 骨架

对A的连续k次腐蚀$(A minus.circle k B) = ((dots.h.c (A minus.circle B) minus.circle B) minus.circle dots.h.c) minus.circle B \)$

K是A被腐蚀为一个空集之前的最后一个迭代步骤$K = max {k divides (A minus.circle k B) eq.not nothing}$


$S (A) = union.big_(k = 0)^K S_k (A) S_k (A) = (A minus.circle k B) - (A minus.circle k B) circle.stroked.tiny B$


=== 裁剪

//没看懂,等PPT

使用一系列设计用来检测端点的结构元对集合进行细化处理$X_1 = A times.circle { B }$

删除寄生分支$X_2 = union.big_(k = 1)^8 (X_1 ast.circle B^k)$

H是元素值为1的一个3×3结构元$X_3 = (X_2 xor H) sect A$

$X_4 = X_1 union X_3$



== 形态学重建

测地膨胀$D_G^((1)) (F) = (F xor B) sect G$ 为n代表对前一次继续做测地膨胀 $D_G^((n)) (F) = D_G^((1)) [D_G^((n - 1)) (F)]$(跟联通域抽取一样)

测地腐蚀$E_G^((1)) (F) = (F minus.circle B) union G$ 为n代表对前一次继续做测地腐蚀 $E_G^((n)) (F) = E_G^((1)) [E_G^((n - 1)) (F)]$

自动孔洞填充 $ F (x , y) = cases(delim: "{", 1 - I (x , y) "," (x , y) "在 I的边框上", 0 ",其他" ) $

#let three-line-table = tablem.with(
  render: (columns: auto, ..args) => {
    tablex(
      columns: columns,
      auto-lines: false,
      align: center + horizon,
      hlinex(y: 0),
      hlinex(y: 1),
      ..args,
      hlinex(),
    )
  }
)

#three-line-table[
  | *运算* | *公式* | *注释* |
  | ------ | ---------- | -------- |
  | 平移   | $ (B)_z = {c divides c = b + z, b in B}$ | 将$B$的原点平移到点$z$   |
  | 反射   | $ hat(B) = {w divides w = - b, b in B}$ | 相对于$B$的原点反射(转180°)   |
  | 补集   | $ A^c = {w divides w in.not A}$ | 不属于$A$ 的点集   |
  | 差集   | $ A - B = {w divides w in A, w in.not B} = A sect.big B^c$ | 属于$A$但不属于$B$的点集   |
  | 腐蚀   | $ A minus.circle B = {z divides (B)_z subset.eq A} = {z divides (B)_z sect A^c = nothing} $ | 腐蚀$A$的边界(I)   |
  | 膨胀   | $ A xor B = {z divides (hat(B))_z sect A eq.not diameter}$ | 膨胀$A$的边界(I) |
  |对偶性   | $ (A minus.circle B)^c = A^c xor hat(B);(A xor B)^c = A^c minus.circle hat(B) $| |
  | 开运算 | $ A circle.stroked.tiny B = (A minus.circle B) xor B =union.big {(B)_z \| (B)_z subset.eq A} $
 | 平滑轮廓，断开狭窄区域，删除小孤岛和尖刺(I);幂等律 |
  | 闭运算 | $ A bullet B = (A xor B) minus.circle B \= [ union.big {(B)_z|(B)_z sect A = nothing} ]^c$ | 平滑轮廓，弥合狭窄断裂和细长沟道，删除小孔洞(I);幂等律 |
  |对偶性   | $ (A circle.stroked.tiny B)^c = A^c bullet hat(B);(A bullet B)^c = A^c circle.stroked.tiny hat(B) $| |
  | 击中与击不中 | $ I ast.circle B_(1, 2) = {z divides (B_1)_z subset.eq A and (B_2)_z subset.eq A^c}=(A dot.circle B_1) sect.big(A^c dot.circle B_2)$ | 在图像$I$中寻找结构元$B$的实例 |
  | 边界提取 | $ beta (A) = A - (A minus.circle B)$ | 提取集合$A$的边界上的点集(I) |
  | 孔洞填充 | $ X_k = (X_(k - 1) xor B) sect.big I^c , quad k = 1 , 2 , 3 , dots.h.c$ | 填充$A$中的孔洞，$X_0$初始化为$I$边框(I) |
  | 连通分量 | $ X_k = (X_(k - 1) xor B) sect I , quad k = 1 , 2 , 3 , dots.h.c$ | 寻找$I$中的连通分量(I) |
  | 凸壳   | $ X_k^i = (X_(k - 1)^i times.circle B^i) union.big X_(k - 1)^i , i = 1,2,3,4$ | 计算$I$中前景像素的凸壳(I) |
  | 细化   | $ A times.circle B = A - (A ast.circle B)$ | 细化集合$A$，移除多余分支(I) |
  | 粗化   | $ A dot.circle B = A union.big (A ast.circle B)$ | 使用结构元粗化集合$A$(I) |
  | 骨架   | $ S(A) = union.big_(k = 0)^K S_k(A), quad S_k(A) = (A minus.circle k_B) - (A minus.circle k_B) circle.stroked.tiny B$ | 寻找集合$A$的骨架(I) |
  | 裁剪   | $  X_1 = A times.circle { B } quad
X_2 = union.big_(k = 1)^8 (X_1 times.circle B^k)\
X_3 = (X_2 xor H) sect A quad
X_4 = X_1 union X_3 $  | $ X_4$是裁剪集合 $ A$ 后的结果。结构元(V)用于前两个公式，$H$用于第三个公式(I) |
  | 大小为1的测地膨胀 | $  D_G^(1)(F)=(F xor B) sect G$ | $ F$和$G$分别称为标记图像和模板图像(I) |
  | 大小为1的测地腐蚀 | $ E_{G}^(1)(F)=(F dot.circle B) union G$ | $ F$和$G$分别称为标记图像和模板图像(I) |
  | 大小为n的测地腐蚀 | $ E_{G}^(n)(F)=E_{G}^(1)(E_{G}^(n-1)(F))$ | $ n$表示重复迭代次数(I) |
    | 膨胀形态学重建 | $  R_(G)^(D)(F)=D_(G)^(k)(F), quad k s.t.\ D_G^(k)(F)=D_G^(k+1)(F) $  | 通过迭代膨胀完成形态学重建(I) |
  | 腐蚀形态学重建 | $ R_G^E(F)=E_G^(k)(F), quad k s.t. \  E_G^(k)(F)=E_G^(k+1)(F)$ | 通过迭代腐蚀完成形态学重建(I) |
    | 重建开运算 | $ O_R^(n)(F)=R_F^D(F minus.circle n_B)$ | $ (F dot.circle n_B)$表示$B$对$F$的$n$次腐蚀，$B$的形式依赖于应用(I) |
  | 重建闭运算 | $ C_R^(n)(F)=R_F^E(F xor n_B)$ | $ (F xor n_B)$表示$B$对$F$的$n$次膨胀，$B$的形式依赖于应用(I) |
    | 孔洞填充 | $ H=[R_(I^c)^D(F)]^c$ | $ H$等于输入图像$I$，但所有孔洞均被填充(I) |
  | 边界清除 | $ X=I-R_I^D(F)$ | $ X$等于输入图像$I$，但删除了所有接触边界的标记(I) |
]

*/
目标通常定义为前景像素集合;结构元可以按照前景像素和背景像素来规定,原点用黑色点。\


平移  $(B)_z = {c divides c = b + z, b in B}$ 将 $B$ 的原点平移到点 $z$ \
反射  $hat(B) = {w divides w = - b, b in B}$ 相对于 $B$ 的原点反射(转180°)\
补集  $A^c = {w divides w in.not A}$ 不属于 $A$ 的点集\
差集  $A - B = {w divides w in A, w in.not B} = A sect.big B^c$ 属于 $A$ 但不属于 $B$ 的点集

*腐蚀*  $A minus.circle B = {z divides (B)_z subset.eq A} = {z divides (B)_z sect A^c = nothing}$ 腐蚀 $A$ 的边界(I);能缩小、细化二值图像中的目标\
*膨胀*  $A xor B = {z divides (hat(B))_z sect A eq.not diameter}$ 膨胀 $A$ 的边界(I);可修复图像中的断裂字符\
对偶性  $(A minus.circle B)^c = A^c xor hat(B);  (A xor B)^c = A^c minus.circle hat(B)$

*开运算* $A circle.stroked.tiny B = (A minus.circle B) xor B =union.big {(B)_z \| (B)_z subset.eq A}$ 平滑轮廓，断开狭窄区域，删除小孤岛和尖刺(I);幂等律;当B在A的边界*内侧*滚动时，B所能到达的A的边界的最远点;B的所有平移的并集。\
*闭运算* $A bullet B = (A xor B) minus.circle B \= [ union.big {(B)_z|(B)_z sect A = nothing} ]^c$ 平滑轮廓，弥合狭窄断裂和细长沟道，删除小孔洞(I);幂等律;当B在A的边界*外侧*滚动时，B所能到达的A的边界的最远点;B的所有不与A重叠的平移的并集的补集。\
对偶性  $(A circle.stroked.tiny B)^c = A^c bullet hat(B);(A bullet B)^c = A^c circle.stroked.tiny hat(B)$

*击中与击不中* $I ast.circle B_(1, 2) = {z divides (B_1)_z subset.eq A and (B_2)_z subset.eq A^c}=(A minus.circle B_1) sect.big(A^c minus.circle B_2)$ 前景中检测形状的 B1，在背景中检测形状的 B2同时满足的保留

*边界提取* $beta (A) = A - (A minus.circle B)$ 提取集合 $A$ 的边界上的点集(I)\
*孔洞填充* $X_k = (X_(k - 1) xor B) sect.big I^c , quad k = 1 , 2 , 3 , dots.h.c$ 填充 $A$ 中的孔洞， $X_0$ 初始化为 $I$大小,在每个孔洞中填充1.在其他位置填充 0\
*提取连通分量* $X_k = (X_(k - 1) xor B) sect I , quad k = 1 , 2 , 3 , dots.h.c$ 寻找 $I$ 中的连通分量(I)\
*凸壳*  $X_k^i = (X_(k - 1)^i ast.circle B^i) union.big X_(k - 1)^i , i = 1,2,3,4$ 计算 $I$ 中前景像素的凸壳(I)\
//PPT写（了解）
细化  $A times.circle B = A - (A ast.circle B)$ 细化集合 $A$ ，移除多余分支(I)\
粗化  $A dot.circle B = A union.big (A ast.circle B)$ 使用结构元粗化集合 $A$ (I)\
骨架  $S(A) = union.big_(k = 0)^K S_k(A), quad S_k(A) = (A minus.circle k_B) - (A minus.circle k_B) circle.stroked.tiny B$ 寻找集合 $A$ 的骨架(I)\
裁剪  $X_1 = A times.circle { B }$ ; $X_2 = union.big_(k = 1)^8 (X_1 times.circle B^k)$ ; $X_3 = (X_2 xor H) sect A $ ; $X_4 = X_1 union X_3$  $X_4$ 是裁剪集合  $A$ 后的结果。结构元(V)用于前两个公式， $H$ 裁剪用于第三个公式(I)\
通常用于细化和骨架绘制算法的后处理.用于消除“毛刺”—比较短的像素端点，比如说小于等于3个像素长度.
// 大小为1的测地膨胀 $D_G^(1)(F)=(F xor B) sect G$  $F$ 和 $G$ 分别称为标记图像和模板图像(I)
// 大小为1的测地腐蚀 $E_{G}^(1)(F)=(F dot.circle B) union G$  $F$ 和 $G$ 分别称为标记图像和模板图像(I)
// 大小为n的测地腐蚀 $E_{G}^(n)(F)=E_{G}^(1)(E_{G}^(n-1)(F))$  $n$ 表示重复迭代次数(I)
// 膨胀形态学重建 $R_(G)^(D)(F)=D_(G)^(k)(F), quad k s.t.\ D_G^(k)(F)=D_G^(k+1)(F)$ 通过迭代膨胀完成形态学重建(I)
// 腐蚀形态学重建 $R_G^E(F)=E_G^(k)(F), quad k s.t. \  E_G^(k)(F)=E_G^(k+1)(F)$ 通过迭代腐蚀完成形态学重建(I)
// 重建开运算 $O_R^(n)(F)=R_F^D(F minus.circle n_B)$  $(F dot.circle n_B)$ 表示 $B$ 对 $F$ 的 $n$ 次腐蚀， $B$ 的形式依赖于应用(I)
// 重建闭运算 $C_R^(n)(F)=R_F^E(F xor n_B)$  $(F xor n_B)$ 表示 $B$ 对 $F$ 的 $n$ 次膨胀， $B$ 的形式依赖于应用(I)
// 孔洞填充 $H=[R_(I^c)^D(F)]^c$  $H$ 等于输入图像 $I$ ，但所有孔洞均被填充(I)
// 边界清除 $X=I-R_I^D(F)$  $X$ 等于输入图像 $I$ ，但删除了所有接触边界的标记(I)
== 灰度级形态学
把膨胀、腐蚀、开运算和闭运算的基本运算扩展到灰度图像\
平坦结构元:内部灰度值相同;非平坦结构元的灰度值会随它们的定义域变化\
补集定义$f^c(x,y)=-f(x,y)$ 反射定义$hat(b)(x,y)=b(-x,-y)$\
灰度腐蚀 平坦$ [f minus.circle b] (x , y) = min_((s , t) in b) { f (x + s , y + t) }$ 非平坦$ [f minus.circle b_N] (x , y) = min_((s , t) in b_N) { f (x + s , y + t) - b_N (s , t) }$\
灰度膨胀 平坦$ [f xor b] (x , y) = max_((s , t) in hat(b)) { f (x - s , y - t) }$ 非平坦$ [f xor b_N] (x , y) = max_((s , t) in hat(b)_N) { f (x - s , y - t) + hat(b)_N (s , t) }$\
灰度腐蚀和膨胀相对于补集和反射是对偶的(这里省略参数)\
$(f minus.circle b)^c = f^c plus.circle hat(b) quad(f plus.circle b)^c = f^c minus.circle hat(b)$

开运算$ f circle.stroked.tiny b = (f minus.circle b) xor b$ 闭运算$ f bullet b = (f xor b) minus.circle b$ 它们也是对偶的\
开运算经常用于去除小而明亮的细节；闭运算经常用于去除小而黑暗的细节\
从信号图像看开削峰，闭填谷;两个都满足图片中的性质
#image("./img/灰度开运算和闭运算性质.png",height: 5%)\
形态学梯度 $g = vec(f xor b) - vec(f minus.circle b)$ ; 显示边缘
顶帽变换 $T_(h a t)(f)=f - (f circle.stroked.tiny b)$ 亦称“白顶帽”变换，用于暗背景上亮物体;暗背景下亮目标分割\
底帽变换 $B_(h a t)(f)=(f bullet b) - f$ 亦称“黑底帽”变换，用于亮背景上暗物体;亮背景下暗目标分割\
粒度测定:使用逐渐增大的结构元对图像进行开运算。某个特殊尺寸的开运算对包含类似尺寸的颗粒的输入图像的区域产生最大的效果。