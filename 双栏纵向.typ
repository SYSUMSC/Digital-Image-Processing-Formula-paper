#set page(
  width: 21cm,
  height: 29.7cm,
  margin: (top:0.5cm, bottom:0.5cm, left:0.5cm, right:0.5cm),
  columns: 2
)
//调整这个确保在4页打印
#set text(0.587em)
//伪粗体
#import "@preview/cuti:0.2.1": show-cn-fakebold
#show: show-cn-fakebold
#set text(font: ("Times New Roman", "SimSun"))

#show heading.where(
  level: 1
): it => block(width: 100%)[
  #set align(center)
  #set text(10pt, weight: "bold")
  #smallcaps(it.body)
]


#show heading.where(
  level: 2
): it => block(width: 100%)[
  #set text(8pt, weight: "bold")
  #smallcaps(it.body)
]

#include("ch2.typ")
#include("ch3.typ")
#include("ch4.typ")
#include("ch5.typ")
#include("ch6.typ")
#include("ch9.typ")
#include("ch10.typ")
#include("ch11.typ")