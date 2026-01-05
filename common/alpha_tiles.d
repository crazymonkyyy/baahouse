#!/usr/bin/env opend run
module common.alpha_tiles;

/**
 * Core tile definitions for the baahouse project
 * Following the required format:
 * - alias output=bool; (for current alpha tiles)
 * - enum maxtiles=256; (defines functions in the set)
 * - Tiles defined in overload set with int value template specialization
 * - Coordinate system: (0,0) is top-left, (1,1) is bottom-right
 */

import std.math;

alias output=bool;
enum maxtiles=256;

// Basic tiles - starting with simple geometric patterns

output tile(int i:0)(float x,float y)=>x+y<1.0;//diagonal half (top-left triangle white)
output tile(int i:1)(float x,float y)=>abs((x-0.5)*(y-0.5))<0.1;//small cross/hyperbola band pattern - balanced
output tile(int i:2)(float x,float y)=>abs(x-0.25)<0.15 || abs(x-0.75)<0.15;//double vertical stripes
output tile(int i:3)(float x,float y)=>abs(y-0.25)<0.15 || abs(y-0.75)<0.15;//double horizontal stripes
output tile(int i:4)(float x,float y)=>y>0.5;//bottom half
output tile(int i:5)(float x,float y)=>abs(x-y)<0.2;//diagonal band
output tile(int i:6)(float x,float y)=>x>y;//diagonal top-left to bottom-right
output tile(int i:7)(float x,float y)=>x+y>1.0;//diagonal bottom-left to top-right
output tile(int i:8)(float x,float y)=>x>0.5 && y>0.5;//bottom-right quadrant
output tile(int i:9)(float x,float y)=>x<0.5 && y<0.5;//top-left quadrant
output tile(int i:10)(float x,float y)=>x>0.5 && y<0.5;//top-right quadrant
output tile(int i:11)(float x,float y)=>x<0.5 && y>0.5;//bottom-left quadrant
output tile(int i:12)(float x,float y)=>abs(x-0.5)<0.05 || abs(y-0.5)<0.05;//thin crosshair
output tile(int i:13)(float x,float y)=>abs((x+y-1.0))<0.08 && abs((x-0.5)-(y-0.5))>0.2;//diagonal band with wider gap
output tile(int i:14)(float x,float y)=>abs((x+y-1.0))<0.1;//diagonal stripe
output tile(int i:15)(float x,float y)=>abs((x-y))<0.1;//diagonal stripe opposite
output tile(int i:16)(float x,float y)=>abs((x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)-0.15)<0.05;//ring
output tile(int i:17)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2;//square
output tile(int i:18)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.2 && abs(x-0.5)+abs(y-0.5)>0.1;//diamond outline
output tile(int i:19)(float x,float y)=>abs(x-0.5)<0.1 || abs(y-0.5)<0.1;//horizontal and vertical cross
output tile(int i:20)(float x,float y)=>(cast(int)(x*10)+cast(int)(y*10))%2==0;//checkerboard small

// Additional tiles for suggested 50 total

output tile(int i:21)(float x,float y)=>x>0.3 && x<0.7;//vertical center band
output tile(int i:22)(float x,float y)=>y>0.3 && y<0.7;//horizontal center band
output tile(int i:23)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.1;//center square
output tile(int i:24)(float x,float y)=>(x<0.1 || x>0.9) && (y<0.1 || y>0.9);//corner square
output tile(int i:25)(float x,float y)=>abs(x-y)<0.05;//thin diagonal
output tile(int i:26)(float x,float y)=>abs(x-(1-y))<0.05;//thin anti-diagonal
output tile(int i:27)(float x,float y)=>x>0.2 && x<0.8 && y>0.2 && y<0.8;//center rectangle
output tile(int i:28)(float x,float y)=>((x<0.2 && y<0.2) || (x>0.8 && y>0.8)) && !((x<0.1 && y<0.1) || (x>0.9 && y>0.9));//larger corner border
output tile(int i:29)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.5)<0.05;//small center square
output tile(int i:30)(float x,float y)=>abs((x-0.5)*2+(y-0.5)*2)<0.5;//diagonal band
output tile(int i:31)(float x,float y)=>abs((x-0.5)*2-(y-0.5)*2)<0.5;//anti-diagonal band
output tile(int i:32)(float x,float y)=>sin(PI*6*x)<0.0;//horizontal waves
output tile(int i:33)(float x,float y)=>sin(PI*6*y)<0.0;//vertical waves
output tile(int i:34)(float x,float y)=>sin(PI*6*x)*sin(PI*6*y)<0.0;//grid waves
output tile(int i:35)(float x,float y)=>abs(sin(PI*4*x))<0.5;//horizontal stripes
output tile(int i:36)(float x,float y)=>abs(sin(PI*4*y))<0.5;//vertical stripes
output tile(int i:37)(float x,float y)=>abs(sin(PI*4*x)*sin(PI*4*y))<0.25;//grid stripes
output tile(int i:38)(float x,float y)=>(x+y)<0.5;//upper left triangle
output tile(int i:39)(float x,float y)=>(x+y)>1.5;//lower right triangle
output tile(int i:40)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.3;//diamond shape
output tile(int i:41)(float x,float y)=>abs(x-0.5)+abs(y-0.5)>0.7;//outside diamond
output tile(int i:42)(float x,float y)=>(x-0.5)*(y-0.5)<0.1;//saddle shape
output tile(int i:43)(float x,float y)=>(x-0.5)*(y-0.5)<0.0;//negative saddle
output tile(int i:44)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.1;//horizontal rectangle
output tile(int i:45)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.3;//vertical rectangle
output tile(int i:46)(float x,float y)=>abs(x-0.5)<0.3 || abs(y-0.5)<0.3;//cross shape
output tile(int i:47)(float x,float y)=>(cast(int)(x*5)+cast(int)(y*5))%2==0;//medium checkerboard
output tile(int i:48)(float x,float y)=>(cast(int)(x*20)+cast(int)(y*20))%2==0;//fine checkerboard
output tile(int i:49)(float x,float y)=>(cast(int)(x*3)+cast(int)(y*3))%2==0;//coarse checkerboard

// Card suit patterns
output tile(int i:50)(float x,float y)=>((x-0.5)*(x-0.5)+(y-0.7)*(y-0.7)<0.05) || (abs((x-0.5)*2)+(abs(y-0.7)*2)<0.5 && y>0.7); //heart shape - balanced pattern
output tile(int i:51)(float x,float y)=>((x-0.25)*(x-0.25)+(y-0.25)*(y-0.25)<0.04) && ((x-0.75)*(x-0.75)+(y-0.75)*(y-0.75)<0.04); //two small circles
output tile(int i:52)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.2 && abs(x-0.5)+abs(y-0.5)>0.05; //diamond with center gap - balanced pattern
output tile(int i:53)(float x,float y)=>abs(x-0.5)<0.15 && abs(y-0.5)<0.15 && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05); //square with center hole - balanced pattern
output tile(int i:54)(float x,float y)=>abs(x-0.25)+abs(y-0.25)<0.2 || abs(x-0.75)+abs(y-0.75)<0.2;//double diamond
output tile(int i:55)(float x,float y)=>abs((x-0.5)*(y-0.5))<0.02;//saddle band
output tile(int i:56)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(x-0.5)>0.05 && abs(y-0.5)>0.05;//square frame
output tile(int i:57)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.3 && abs(x-0.5)+abs(y-0.5)>0.1;//diamond frame
output tile(int i:58)(float x,float y)=>(x<0.1 || x>0.9 || y<0.1 || y>0.9) && !((x>0.4 && x<0.6 && y>0.4 && y<0.6));//inverted frame with center
output tile(int i:59)(float x,float y)=>abs(x-0.5)<0.05 || abs(y-0.5)<0.05 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.02;//cross with dot
output tile(int i:60)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.08 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.02;//ring
output tile(int i:61)(float x,float y)=>abs(x-y)<0.1 && abs(x+y-1.0)<0.1 && abs(x-0.5)+abs(y-0.5)>0.35;//x shape with larger center gap
output tile(int i:62)(float x,float y)=>(abs(x-0.5)<0.2 && abs(y-0.5)<0.05) || (abs(x-0.5)<0.05 && abs(y-0.5)<0.2);//plus sign
output tile(int i:63)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.15 && abs(x-0.5)>0.1;//crescent
output tile(int i:64)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.3 && abs(x-0.5)-abs(y-0.5)>0.1;//triangle
output tile(int i:65)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.12 && (abs(x-0.5)<0.08 || abs(y-0.5)<0.08);//target
output tile(int i:66)(float x,float y)=>(abs(x-0.3)+abs(y-0.3)<0.1) || (abs(x-0.7)+abs(y-0.7)<0.1);//double diamond offset
output tile(int i:67)(float x,float y)=>abs((x-0.5)*(y-0.5))<0.01 && abs(x-0.5)+abs(y-0.5)>0.15;//saddle shape with center gap
output tile(int i:68)(float x,float y)=>(x-0.5)*(y-0.5)<0.0 && (x-0.5)*(y-0.5)>-0.1;//saddle band
output tile(int i:69)(float x,float y)=>abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && (abs(x-0.5)+abs(y-0.5)>0.2);//rounded square
output tile(int i:70)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(x-0.5)*abs(y-0.5)<0.01;//rounded corner square
output tile(int i:71)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.1 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.03;//ring segment
output tile(int i:72)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)>0.1 && abs(y-0.5)>0.1;//square ring
output tile(int i:73)(float x,float y)=>(abs(x-0.5)<0.1 || abs(y-0.5)<0.1) && (abs(x-0.5)>0.05 && abs(y-0.5)>0.05);//broken cross
output tile(int i:74)(float x,float y)=>(abs(x-0.2)+abs(y-0.2)<0.08) || (abs(x-0.8)+abs(y-0.8)<0.08);//two smaller diamonds
output tile(int i:75)(float x,float y)=>abs(x-0.5)<0.15 && abs(y-0.5)<0.25 || abs(x-0.5)<0.25 && abs(y-0.5)<0.15;//thick cross
output tile(int i:76)(float x,float y)=>(x-0.5)*(y-0.5)>0.03;//positive saddle
output tile(int i:77)(float x,float y)=>abs((x-0.5)*(x-0.5)-(y-0.5)*(y-0.5))<0.1;//hyperbolic bands
output tile(int i:78)(float x,float y)=>abs(x-0.5)<0.05 && y>0.5 || abs(y-0.5)<0.05 && x>0.5;//L shape
output tile(int i:79)(float x,float y)=>abs(x-0.5)<0.05 && y<0.5 || abs(y-0.5)<0.05 && x<0.5;//opposite L shape
output tile(int i:80)(float x,float y)=>abs(x-0.5)<0.05 && y>0.5 && y<0.8 || abs(y-0.5)<0.05 && x>0.5 && x<0.8;//short L
output tile(int i:81)(float x,float y)=>abs(x-0.5)<0.05 && y<0.5 && y>0.2 || abs(y-0.5)<0.05 && x<0.5 && x>0.2;//opposite short L
output tile(int i:82)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.1 || abs(x-0.5)+abs(y-0.5)>0.3 && abs(x-0.5)+abs(y-0.5)<0.4;//dual diamond
output tile(int i:83)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.1 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.2 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.3;//dual circle
output tile(int i:84)(float x,float y)=>(abs(x-0.5)<0.1 && abs(y-0.5)<0.1) && !((abs(x-0.5)<0.05 && abs(y-0.5)<0.05));//center square with hole
output tile(int i:85)(float x,float y)=>(abs(x-0.5)<0.2 && abs(y-0.5)<0.2) && !((abs(x-0.5)<0.15 && abs(y-0.5)<0.15));//square ring
output tile(int i:86)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.2 && !((x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.15);//circle ring
output tile(int i:87)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.25 && abs(y-0.5)>0.15;//vertical bar with gap
output tile(int i:88)(float x,float y)=>abs(y-0.5)<0.1 && abs(x-0.5)<0.25 && abs(x-0.5)>0.15;//horizontal bar with gap
output tile(int i:89)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.5)<0.05 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.15 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.08;//dot with ring
output tile(int i:90)(float x,float y)=>(abs(x-0.5)<0.1 || abs(y-0.5)<0.1) && !((abs(x-0.5)<0.05 && abs(y-0.5)<0.05));//cross with hole
output tile(int i:91)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.25 && (abs(x-0.5)<0.05 || abs(y-0.5)<0.05);//diamond frame with center
output tile(int i:92)(float x,float y)=>cast(int)((x-0.5)*20)%2==0 && cast(int)((y-0.5)*20)%2==0;//grid pattern
output tile(int i:93)(float x,float y)=>abs(x-0.5)<0.15 && y<0.3 || abs(x-0.5)<0.15 && y>0.7;//top bottom bars
output tile(int i:94)(float x,float y)=>x<0.3 && abs(y-0.5)<0.15 || x>0.7 && abs(y-0.5)<0.15;//left right bars
output tile(int i:95)(float x,float y)=>abs(x-0.25)<0.1 && abs(y-0.25)<0.1 || abs(x-0.75)<0.1 && abs(y-0.75)<0.1;//diagonal squares
output tile(int i:96)(float x,float y)=>abs(x-0.25)<0.1 && abs(y-0.75)<0.1 || abs(x-0.75)<0.1 && abs(y-0.25)<0.1;//anti-diagonal squares
output tile(int i:97)(float x,float y)=>abs(x-0.5)<0.2 && y>0.6 || abs(y-0.5)<0.2 && x>0.6;//corner shape
output tile(int i:98)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.25)<0.1 || abs(x-0.5)<0.1 && abs(y-0.75)<0.1;//top bottom horizontal bars
output tile(int i:99)(float x,float y)=>abs(x-0.25)<0.1 && abs(y-0.5)<0.1 || abs(x-0.75)<0.1 && abs(y-0.5)<0.1;//left right vertical bars
// Extended tile definitions for 250 tiles total
output tile(int i:100)(float x,float y)=>abs(x-0.5)<0.05 || abs(y-0.5)<0.05 || abs(x-y)<0.05 || abs(x+y-1.0)<0.05;//four line cross
output tile(int i:101)(float x,float y)=>abs((x-0.5)*2-(y-0.5)*2)<0.1 && abs((x-0.5)*2+(y-0.5)*2)>0.2;//skewed cross pattern
output tile(int i:102)(float x,float y)=>abs((x-0.5)*3-(y-0.5)*3)<0.2 && abs((x-0.5)*3+(y-0.5)*3)>0.1;//asymmetric skewed bands
output tile(int i:103)(float x,float y)=>sin(PI*4*x)*sin(PI*4*y)>0.3;//wave intersection
output tile(int i:104)(float x,float y)=>sin(PI*3*x)*cos(PI*3*y)>0.2;//wave interference pattern
output tile(int i:105)(float x,float y)=>sin(PI*6*(x+y))*sin(PI*6*(x-y))>0.1;//diagonal wave interference
output tile(int i:106)(float x,float y)=>abs(sin(PI*3*x))<0.3 || abs(cos(PI*3*y))<0.3;//wave stripes
output tile(int i:107)(float x,float y)=>abs(sin(PI*2*x)*cos(PI*2*y))<0.2;//wave checkerboard
output tile(int i:108)(float x,float y)=>(x-0.5)*(x-0.5)*4+(y-0.5)*(y-0.5)*4<1.0 && (x-0.5)*(x-0.5)*4+(y-0.5)*(y-0.5)*4>0.2;//elliptical ring
output tile(int i:109)(float x,float y)=>abs(x-0.5)*2+abs(y-0.5)*2<1.0 && abs(x-0.5)*2+abs(y-0.5)*2>0.3;//diamond ring
output tile(int i:110)(float x,float y)=>abs(abs(x-0.5)*2-abs(y-0.5)*2)<0.3;//diagonal diamond pattern
output tile(int i:111)(float x,float y)=>abs((x-0.5)*2*(y-0.5)*2)<0.1;//center area with exclusion
output tile(int i:112)(float x,float y)=>abs((x-0.5)*(y-0.5)*(x+y-1.0))<0.05;//triangular area pattern
output tile(int i:113)(float x,float y)=>abs(sin(PI*8*x)+sin(PI*8*y))<0.5;//combined wave pattern
output tile(int i:114)(float x,float y)=>abs(sin(PI*5*x)*sin(PI*5*y)+cos(PI*5*x)*cos(PI*5*y))<0.3;//trigonometric combination
output tile(int i:115)(float x,float y)=>abs(sin(PI*3*(x+y))+sin(PI*3*(x-y)))<0.4;//sum of diagonal waves
output tile(int i:116)(float x,float y)=>abs(cos(PI*4*x)+cos(PI*4*y))<0.5;//cosine wave pattern
output tile(int i:117)(float x,float y)=>abs(cos(PI*2*(x+y))+cos(PI*2*(x-y)))<0.3;//diagonal cosine pattern
output tile(int i:118)(float x,float y)=>abs(tan(PI*2*x)*tan(PI*2*y))<2.0;//tangent pattern (limited)
output tile(int i:119)(float x,float y)=>abs(x-0.5)*abs(y-0.5)*(x+y)<0.08;//asymmetric center area
output tile(int i:120)(float x,float y)=>(cast(int)(x*4)+cast(int)(y*4))%3==0;//tertiary checkerboard
output tile(int i:121)(float x,float y)=>(cast(int)(x*5)+cast(int)(y*3))%2==0;//asymmetric checkerboard
output tile(int i:122)(float x,float y)=>(cast(int)(x*6)*cast(int)(y*6))%2==0;//multiplicative checkerboard
output tile(int i:123)(float x,float y)=>(abs(x-0.25)<0.1 || abs(x-0.75)<0.1) && (abs(y-0.25)<0.1 || abs(y-0.75)<0.1);//grid squares
output tile(int i:124)(float x,float y)=>(abs(x-0.33)<0.15 || abs(x-0.67)<0.15) && (abs(y-0.33)<0.15 || abs(y-0.67)<0.15);//ternary grid
output tile(int i:125)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)>0.3 || abs(y-0.5)<0.2 && abs(x-0.5)>0.3;//cross with excluded center
output tile(int i:126)(float x,float y)=>abs(x-0.5)+abs(y-0.5)>0.6 && abs(x-0.5)-abs(y-0.5)<0.2;//modified diamond with cutouts
output tile(int i:127)(float x,float y)=>abs(x-0.5)*abs(y-0.5)>0.05 && abs(x-0.5)+abs(y-0.5)<0.4;//center area with central hole
output tile(int i:128)(float x,float y)=>((x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.2) && ((x-0.25)*(x-0.25)+(y-0.25)*(y-0.25)>0.05);//circle with inner cutout
output tile(int i:129)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && !((abs(x-0.5)<0.1 && abs(y-0.5)<0.1)); //square with center hole
output tile(int i:130)(float x,float y)=>abs((x-0.5)*(y-0.5))>0.02 && abs(x-0.5)+abs(y-0.5)<0.35;//center area excluding the very center
output tile(int i:131)(float x,float y)=>abs(x-0.5)<0.15 && y>0.5 && y<0.8 || abs(y-0.5)<0.15 && x>0.5 && x<0.8;//partial cross
output tile(int i:132)(float x,float y)=>x>0.7 && y<0.3 || x<0.3 && y>0.7;//diagonal corner bands
output tile(int i:133)(float x,float y)=>abs(x-0.5)<0.1 && y>0.7 && y<0.9 || abs(y-0.5)<0.1 && x>0.7 && x<0.9;//corner cross segments
output tile(int i:134)(float x,float y)=>abs(x-y)<0.15 && x<0.4 && y<0.4 || abs(x+y-1.0)<0.15 && x>0.6 && y>0.6;//diagonal corner segments
output tile(int i:135)(float x,float y)=>sin(PI*4*(x+y-1.0))*sin(PI*4*(x-y))>0.2;//diagonal wave intersection
output tile(int i:136)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.25)<0.05 || abs(x-0.5)<0.05 && abs(y-0.75)<0.05;//vertical dots
output tile(int i:137)(float x,float y)=>abs(x-0.25)<0.05 && abs(y-0.5)<0.05 || abs(x-0.75)<0.05 && abs(y-0.5)<0.05;//horizontal dots
output tile(int i:138)(float x,float y)=>abs(x-0.25)<0.05 && abs(y-0.25)<0.05 || abs(x-0.75)<0.05 && abs(y-0.75)<0.05 || abs(x-0.25)<0.05 && abs(y-0.75)<0.05 || abs(x-0.75)<0.05 && abs(y-0.25)<0.05;//four corner dots
output tile(int i:139)(float x,float y)=>(x-0.5)*(x-0.5)*4+(y-0.5)*(y-0.5)*9<1.0;//vertical ellipse
output tile(int i:140)(float x,float y)=>(x-0.5)*(x-0.5)*9+(y-0.5)*(y-0.5)*4<1.0;//horizontal ellipse
output tile(int i:141)(float x,float y)=>abs(x-0.5)*2+abs(y-0.5)*3<1.0;//vertical diamond
output tile(int i:142)(float x,float y)=>abs(x-0.5)*3+abs(y-0.5)*2<1.0;//horizontal diamond
output tile(int i:143)(float x,float y)=>abs(abs(x-0.5)*2-abs(y-0.5)*3)<0.5 && abs(abs(x-0.5)*2+abs(y-0.5)*3)<1.5;//asymmetric diamond pattern
output tile(int i:144)(float x,float y)=>(x-0.5)*(y-0.5)*((x-0.5)+(y-0.5))<0.01 && (x-0.5)*(y-0.5)*((x-0.5)+(y-0.5))>-0.01;//triple intersection band
output tile(int i:145)(float x,float y)=>(abs(x-0.5)<0.2 && abs(y-0.5)<0.1 && abs(x-0.5)>0.05) || (abs(y-0.5)<0.2 && abs(x-0.5)<0.1 && abs(y-0.5)>0.05);//frame with gap
output tile(int i:146)(float x,float y)=>abs(x-0.25)<0.1 && abs(y-0.25)<0.1 && abs(x-0.25)+abs(y-0.25)>0.05 || abs(x-0.75)<0.1 && abs(y-0.75)<0.1 && abs(x-0.75)+abs(y-0.75)>0.05;//diagonal squares with centers removed
output tile(int i:147)(float x,float y)=>abs(x-0.5)*abs(y-0.5)<0.05 && abs(x-0.5)+abs(y-0.5)<0.3;//center proximity pattern
output tile(int i:148)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && (x-0.5)*(y-0.5)<0.02 && (x-0.5)*(y-0.5)>-0.02;//center with diagonal exclusion
output tile(int i:149)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.05 && abs(x-0.5)+abs(y-0.5)<0.25;//diamond excluding center
output tile(int i:150)(float x,float y)=>(abs(x-0.25)+abs(y-0.25)<0.15) || (abs(x-0.75)+abs(y-0.75)<0.15) || (abs(x-0.25)+abs(y-0.75)<0.15) || (abs(x-0.75)+abs(y-0.25)<0.15);//all four diamonds
output tile(int i:151)(float x,float y)=>((x-0.5)*(x-0.5)+(y-0.25)*(y-0.25)<0.08) || ((x-0.5)*(x-0.5)+(y-0.75)*(y-0.75)<0.08);//vertical double circle
output tile(int i:152)(float x,float y)=>((x-0.25)*(x-0.25)+(y-0.5)*(y-0.5)<0.08) || ((x-0.75)*(x-0.75)+(y-0.5)*(y-0.5)<0.08);//horizontal double circle
output tile(int i:153)(float x,float y)=>((x-0.25)*(x-0.25)+(y-0.25)*(y-0.25)<0.08) || ((x-0.75)*(x-0.75)+(y-0.75)*(y-0.75)<0.08) || ((x-0.25)*(x-0.25)+(y-0.75)*(y-0.75)<0.08) || ((x-0.75)*(x-0.75)+(y-0.25)*(y-0.25)<0.08);//four corner circles
output tile(int i:154)(float x,float y)=>abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && (abs(x-0.5)>0.15 || abs(y-0.5)>0.15);//square with center cross excluded
output tile(int i:155)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.3 && (abs(x-0.5)+abs(y-0.5)>0.15 || abs(x-0.5)<0.05 && abs(y-0.5)<0.05);//diamond with center inclusion
output tile(int i:156)(float x,float y)=>abs((x-0.5)*2)>0.7 && abs((y-0.5)*2)>0.7;//outer corner squares
output tile(int i:157)(float x,float y)=>abs((x-0.5)*2)<0.3 && abs((y-0.5)*2)<0.3 && (abs((x-0.5)*2)>0.1 || abs((y-0.5)*2)>0.1);//inner square frame
output tile(int i:158)(float x,float y)=>abs((x-0.5)*2)<0.4 && abs((y-0.5)*2)<0.4 && (abs((x-0.5)*2)<0.2 && abs((y-0.5)*2)<0.2);//concentric squares
output tile(int i:159)(float x,float y)=>abs((x-0.5)*3)<0.6 && abs((y-0.5)*3)<0.6 && (abs((x-0.5)*3)<0.3 && abs((y-0.5)*3)<0.3) && (abs((x-0.5)*3)>0.4 || abs((y-0.5)*3)>0.4);//multi concentric squares
output tile(int i:160)(float x,float y)=>sin(PI*6*x)*sin(PI*6*y)<0.0 && sin(PI*6*x)*sin(PI*6*y)>-0.3;//negative wave intersection
output tile(int i:161)(float x,float y)=>abs(sin(PI*4*x)*cos(PI*4*y))>0.4 && abs(sin(PI*4*x)*cos(PI*4*y))<0.8;//selective wave pattern
output tile(int i:162)(float x,float y)=>(abs(x-y)<0.2 && abs(x+y-1.0)>0.6) || (abs(x+y-1.0)<0.2 && abs(x-y)>0.6);//orthogonal diagonal pattern
output tile(int i:163)(float x,float y)=>abs(abs(x-0.5)-0.25)<0.1 || abs(abs(y-0.5)-0.25)<0.1;//cross with offset bars
output tile(int i:164)(float x,float y)=>abs(abs(x-0.5)-0.25)+abs(abs(y-0.5)-0.25)<0.15;//centered diamond around quarters
output tile(int i:165)(float x,float y)=>abs(x-0.5)*abs(y-0.5)<0.05 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.1;//center exclusion near circle
output tile(int i:166)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.3 && abs(x-0.5)+abs(y-0.6)>0.1 || abs(y-0.5)<0.1 && abs(x-0.5)<0.3 && abs(x-0.6)+abs(y-0.5)>0.1;//cross with center gaps
output tile(int i:167)(float x,float y)=>abs(sin(PI*2*x)*sin(PI*2*y)*cos(PI*2*x)*cos(PI*2*y))<0.2;//complex trigonometric pattern
output tile(int i:168)(float x,float y)=>abs((x-0.5)*(y-0.5)*((x-0.5)+(y-0.5))*((x-0.5)-(y-0.5)))<0.005;//complex center pattern
output tile(int i:169)(float x,float y)=>abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && !(abs(x-0.5)<0.15 && abs(y-0.5)<0.15) && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05);//double square frame
output tile(int i:170)(float x,float y)=>(x<0.2 || x>0.8 || y<0.2 || y>0.8) && !(x<0.1 || x>0.9 || y<0.1 || y>0.9);//double frame border
output tile(int i:171)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.5)>0.4 || abs(y-0.5)<0.05 && abs(x-0.5)>0.4;//outer cross
output tile(int i:172)(float x,float y)=>abs((x-0.5)*2+(y-0.5)*2-1.0)<0.3 && abs((x-0.5)*2-(y-0.5)*2)<0.3;//intersection of diagonal bands
output tile(int i:173)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && (abs(x-0.5)<0.1 || abs(y-0.5)<0.1);//cross inside square
output tile(int i:174)(float x,float y)=>abs(x-0.5)>0.3 && abs(y-0.5)>0.3 && (abs(x-0.5)<0.4 || abs(y-0.5)<0.4);//outer corner connector
output tile(int i:175)(float x,float y)=>abs((x-0.5)*(y-0.5))<0.02 && abs(x-0.5)+abs(y-0.5)>0.2 && abs(x-0.5)+abs(y-0.5)<0.35;//diamond ring segment
output tile(int i:176)(float x,float y)=>sin(PI*3*(x+y))*sin(PI*3*(x-y))>0.4 || cos(PI*3*(x+y))*cos(PI*3*(x-y))>0.4;//combined wave pattern
output tile(int i:177)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.1 || abs(x-0.5)<0.1 && abs(y-0.5)<0.3 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.05;//plus sign with center dot
output tile(int i:178)(float x,float y)=>(abs(x-0.5)+abs(y-0.5)<0.25) && !((abs(x-0.5)<0.15 && abs(y-0.5)<0.05) || (abs(x-0.5)<0.05 && abs(y-0.5)<0.15));//diamond frame with center cross excluded
output tile(int i:179)(float x,float y)=>abs((x-0.5)*(x-0.5)-(y-0.5)*(y-0.5))<0.2 && abs(x-0.5)+abs(y-0.5)<0.4;//hyperbolic bands inside diamond
output tile(int i:180)(float x,float y)=>abs(x-0.5)<0.15 && abs(y-0.5)<0.15 && abs(x-0.5)*abs(y-0.5)<0.01;//rounded cross center
output tile(int i:181)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.2 && abs((x-0.5)-(y-0.5))>0.15 && abs((x-0.5)+(y-0.5))>0.15;//circle with diagonal exclusions
output tile(int i:182)(float x,float y)=>abs(abs(x-0.5)-0.2)<0.05 && abs(y-0.5)<0.25 || abs(abs(y-0.5)-0.2)<0.05 && abs(x-0.5)<0.25;//offset cross
output tile(int i:183)(float x,float y)=>abs(x-0.1)<0.05 || abs(x-0.3)<0.05 || abs(x-0.5)<0.05 || abs(x-0.7)<0.05 || abs(x-0.9)<0.05;//vertical grid lines
output tile(int i:184)(float x,float y)=>abs(y-0.1)<0.05 || abs(y-0.3)<0.05 || abs(y-0.5)<0.05 || abs(y-0.7)<0.05 || abs(y-0.9)<0.05;//horizontal grid lines
output tile(int i:185)(float x,float y)=>(abs(x-0.1)<0.05 || abs(x-0.3)<0.05 || abs(x-0.5)<0.05 || abs(x-0.7)<0.05 || abs(x-0.9)<0.05) && (abs(y-0.1)<0.05 || abs(y-0.3)<0.05 || abs(y-0.5)<0.05 || abs(y-0.7)<0.05 || abs(y-0.9)<0.05);//grid intersections
output tile(int i:186)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-y)<0.3 && abs(x+y-1.0)<0.3;//intersection of center area and diagonals
output tile(int i:187)(float x,float y)=>abs(((x-0.5)*2)%0.4)<0.1 || abs(((y-0.5)*2)%0.4)<0.1;//modulo grid pattern
output tile(int i:188)(float x,float y)=>abs(((x-0.5)*3)%0.6)<0.15 && abs(((y-0.5)*3)%0.6)<0.15;//modulo checkerboard
output tile(int i:189)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(((x-0.5)*2)%0.4)<0.1 && abs(((y-0.5)*2)%0.4)<0.1;//center with modulo pattern
output tile(int i:190)(float x,float y)=>abs(((x-0.5)*2)%0.4)<0.1 && abs(((y-0.5)*2)%0.4)<0.1 && abs(x-0.5)+abs(y-0.5)<0.4;//restricted modulo grid
output tile(int i:191)(float x,float y)=>abs(x-0.5)<0.15 && abs(y-0.5)>0.2 && abs(y-0.5)<0.3 || abs(y-0.5)<0.15 && abs(x-0.5)>0.2 && abs(x-0.5)<0.3;//elongated rectangle cross
output tile(int i:192)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)-abs(y-0.5)<0.1 && abs(y-0.5)-abs(x-0.5)<0.1;//square rotated 45 degrees inside square
output tile(int i:193)(float x,float y)=>(abs(x-0.5)+abs(y-0.5)<0.3) && (abs(x-0.5)-abs(y-0.5)>0.1 || abs(y-0.5)-abs(x-0.5)>0.1);//diamond with center exclusion in cross shape
output tile(int i:194)(float x,float y)=>abs((x-0.5)*(y-0.5)*((x-0.5)+(y-0.5))*((x-0.5)-(y-0.5)))<0.005;//complex center pattern
output tile(int i:195)(float x,float y)=>(x<0.1 || x>0.9) && (y<0.1 || y>0.9) || (abs(x-0.5)<0.1 && abs(y-0.5)<0.1);//corner squares and center dot
output tile(int i:196)(float x,float y)=>abs(x-0.5)<0.25 && abs(y-0.5)>0.35 || abs(y-0.5)<0.25 && abs(x-0.5)>0.35;//outer rectangular cross
output tile(int i:197)(float x,float y)=>(abs(x-y)<0.1 && abs(x-0.5)<0.3 && abs(y-0.5)<0.3) || (abs(x+y-1.0)<0.1 && abs(x-0.5)<0.3 && abs(y-0.5)<0.3);//center diagonals
output tile(int i:198)(float x,float y)=>abs((x-0.5)*2*(y-0.5)*2)<0.05 && abs(x-0.5)+abs(y-0.5)>0.15;//center with exclusion zones
output tile(int i:199)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.1 || abs(x-0.5)<0.05 && abs(y-0.5)<0.2 || abs(x-0.5)<0.2 && abs(y-0.5)<0.05;//compound center pattern
output tile(int i:200)(float x,float y)=>abs((x-0.5)*(y-0.5))<0.03 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.25;//center area with radial restriction
output tile(int i:201)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.5)>0.3 || abs(y-0.5)<0.05 && abs(x-0.5)>0.3 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.02;//outer cross with center dot
output tile(int i:202)(float x,float y)=>abs(x-0.5)>0.25 && abs(y-0.5)>0.25 && (abs(x-0.5)<0.35 || abs(y-0.5)<0.35);//outer corner connectors
output tile(int i:203)(float x,float y)=>abs(x-0.5)*abs(y-0.5)<0.01 && abs(x-0.5)+abs(y-0.5)<0.3 && abs(x-0.5)+abs(y-0.5)>0.1;//center diamond band
output tile(int i:204)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs((x-0.5)-(y-0.5))<0.1 && abs((x-0.5)+(y-0.5)-1.0)>0.4;//square with diagonal center
output tile(int i:205)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.1 && abs(x-0.5)*abs(y-0.5)<0.005;//very small center pattern
output tile(int i:206)(float x,float y)=>abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && (abs(x-0.5)>0.25 || abs(y-0.5)>0.25) && abs(x-0.5)*abs(y-0.5)<0.05;//large square frame with center gap
output tile(int i:207)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.4 && abs(x-0.5)+abs(y-0.5)>0.25 && abs((x-0.5)-(y-0.5))>0.15 && abs((x-0.5)+(y-0.5)-1.0)>0.15;//diamond ring with diagonal exclusions
output tile(int i:208)(float x,float y)=>abs((x-0.5)*sin(PI*3*x))<0.1 || abs((y-0.5)*cos(PI*3*y))<0.1;//nonlinear wave pattern
output tile(int i:209)(float x,float y)=>abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && abs(x-0.5)*abs(y-0.5)<0.01 && (abs(x-0.5)<0.1 || abs(y-0.5)<0.1);//compound center pattern
output tile(int i:210)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.3 && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05) || abs(y-0.5)<0.1 && abs(x-0.5)<0.3 && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05);//cross with center hole
output tile(int i:211)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)>0.1 && abs(y-0.5)>0.1 && abs((x-0.5)-(y-0.5))<0.15;//center square with diagonal exclusion
output tile(int i:212)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(x-0.5)+abs(y-0.5)>0.15 && abs((x-0.5)-(y-0.5))>0.1 && abs((x-0.5)+(y-0.5))>0.1;//diamond inside square with diagonal exclusions
output tile(int i:213)(float x,float y)=>abs((x-0.5)*2+(y-0.5)*2-1.0)<0.1 && abs((x-0.5)*2-(y-0.5)*2)<0.2 && abs(x-0.5)+abs(y-0.5)<0.4;//compound diagonal pattern
output tile(int i:214)(float x,float y)=>abs(x-0.5)>0.1 && abs(y-0.5)>0.1 && abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs((x-0.5)*(y-0.5))<0.02;//center area with center exclusion
output tile(int i:215)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)<0.1 && abs(y-0.5)>0.1 || abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(y-0.5)<0.1 && abs(x-0.5)>0.1;//inner corner pattern
output tile(int i:216)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 || abs(x-0.5)>0.3 && abs(y-0.5)>0.3 && abs(x-0.5)<0.4 && abs(y-0.5)<0.4;//center square with outer ring
output tile(int i:217)(float x,float y)=>(abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && !(abs(x-0.5)<0.3 && abs(y-0.5)<0.3)) || (abs(x-0.5)<0.1 && abs(y-0.5)<0.1);//ring with center dot
output tile(int i:218)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs((x-0.5)*(y-0.5))>0.005 || abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs(x-0.5)>0.25 && abs(y-0.5)>0.25;//nested squares with hole
output tile(int i:219)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.35 && abs(x-0.5)+abs(y-0.5)>0.2 && abs((x-0.5)-(y-0.5))>0.15;//diamond ring with diagonal exclusions
output tile(int i:220)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs((x-0.5)-(y-0.5))<0.1 && abs((x-0.5)+(y-0.5)-1.0)<0.1 && (abs(x-0.5)+abs(y-0.5))>0.3;//intersection with exclusion
output tile(int i:221)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.4 && abs(y-0.5)>0.2 || abs(y-0.5)<0.1 && abs(x-0.5)<0.4 && abs(x-0.5)>0.2;//elongated cross
output tile(int i:222)(float x,float y)=>abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs(x-0.5)*abs(y-0.5)<0.02 && abs(x-0.5)+abs(y-0.5)>0.25;//center with radial exclusion
output tile(int i:223)(float x,float y)=>abs((x-0.5)*2+(y-0.5)*2-1.0)<0.1 && abs((x-0.5)*2-(y-0.5)*2)>0.3;//circular band with diagonal exclusion
output tile(int i:224)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(abs(x-0.5)-0.15)<0.05 || abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(abs(y-0.5)-0.15)<0.05;//square with internal grid
output tile(int i:225)(float x,float y)=>abs(x-0.25)<0.1 && abs(y-0.25)<0.1 || abs(x-0.75)<0.1 && abs(y-0.75)<0.1 || abs(x-0.25)<0.1 && abs(y-0.75)<0.1 || abs(x-0.75)<0.1 && abs(y-0.25)<0.1 || abs(x-0.5)<0.05 && abs(y-0.5)<0.05;//four corner squares and center dot
output tile(int i:226)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && !(abs(x-0.5)<0.1 && abs(y-0.5)<0.1) && !(abs(x-0.5)<0.2 && abs(y-0.5)<0.05) && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.2);//square frame with partial cross exclusion
output tile(int i:227)(float x,float y)=>abs(x-0.5)>0.2 && abs(y-0.5)>0.2 && abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && (x-0.5)*(y-0.5)>0.01 && (x-0.5)*(y-0.5)<0.04;//outer corner with exclusion
output tile(int i:228)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && (abs(x-0.5)+abs(y-0.5))<0.15 || abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)+abs(y-0.5)>0.25;//nested diamond pattern
output tile(int i:229)(float x,float y)=>abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs(x-0.5)<0.1 && abs(y-0.5)>0.2 || abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs(y-0.5)<0.1 && abs(x-0.5)>0.2;//square with inner corner pattern
output tile(int i:230)(float x,float y)=>abs(x-0.5)<0.35 && abs(y-0.5)<0.35 && abs((x-0.5)-(y-0.5))>0.2 && abs((x-0.5)+(y-0.5)-1.0)>0.2;//square with diagonal exclusions
output tile(int i:231)(float x,float y)=>abs(x-0.5)>0.1 && abs(y-0.5)<0.1 || abs(y-0.5)>0.1 && abs(x-0.5)<0.1 || (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.01;//cross with center dot
output tile(int i:232)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.2 && abs(x-0.5)>0.05 || abs(y-0.5)<0.1 && abs(x-0.5)<0.2 && abs(y-0.5)>0.05;//cross frame pattern
output tile(int i:233)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)>0.1 && abs(y-0.5)>0.1 && abs(x-y)>0.3;//square frame with diagonal exclusion
output tile(int i:234)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(x-y)<0.1 && abs(x+y-1.0)<0.1;//center with diagonal inclusions
output tile(int i:235)(float x,float y)=>abs(x-0.5)>0.15 && abs(y-0.5)<0.05 || abs(y-0.5)>0.15 && abs(x-0.5)<0.05 || abs(x-0.5-0.2)*abs(y-0.5-0.2)<0.01 || abs(x-0.5+0.2)*abs(y-0.5+0.2)<0.01;//cross with corner dots
output tile(int i:236)(float x,float y)=>abs(x-0.5)+abs(y-0.5)<0.25 && abs((x-0.5)-(y-0.5))>0.1 && abs((x-0.5)+(y-0.5))>0.1 || abs(x-0.5)<0.05 && abs(y-0.5)<0.05;//diamond frame with center dot
output tile(int i:237)(float x,float y)=>abs(x-0.5)<0.15 && abs(y-0.5)<0.35 && abs(x-0.5)+abs(y-0.5)>0.15 || abs(y-0.5)<0.15 && abs(x-0.5)<0.35 && abs(x-0.5)+abs(y-0.5)>0.15;//extended cross with center exclusion zone
output tile(int i:238)(float x,float y)=>abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs((x-0.5)*(y-0.5))<0.01 && abs(x-0.5)+abs(y-0.5)>0.2 && abs(x-0.5)+abs(y-0.5)<0.35;//center area with distance exclusion
output tile(int i:239)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)>0.2 && abs(y-0.5)<0.4 || abs(y-0.5)<0.1 && abs(x-0.5)>0.2 && abs(x-0.5)<0.4;//outer cross extension
output tile(int i:240)(float x,float y)=>(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.3 && (x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)>0.1 && abs((x-0.5)-(y-0.5))>0.2 && abs((x-0.5)+(y-0.5)-1.0)>0.2;//ring with diagonal exclusions
output tile(int i:241)(float x,float y)=>abs(x-0.5)<0.05 && abs(y-0.5)<0.25 || abs(y-0.5)<0.05 && abs(x-0.5)<0.25 || abs(x-0.25)<0.05 && abs(y-0.25)<0.05 || abs(x-0.75)<0.05 && abs(y-0.75)<0.05;//cross with diagonal dots
output tile(int i:242)(float x,float y)=>abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)*abs(y-0.5)<0.01 && abs(abs(x-0.5)-0.15)<0.05 && abs(abs(y-0.5)-0.15)<0.05;//square with offset grid pattern
output tile(int i:243)(float x,float y)=>abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs(x-0.5)+abs(y-0.5)>0.15 && (abs(x-0.5)<0.05 || abs(y-0.5)<0.05);//diamond frame with center cross
output tile(int i:244)(float x,float y)=>(abs(x-0.5)<0.35 && abs(y-0.5)<0.35 && !(abs(x-0.5)<0.25 && abs(y-0.5)<0.25)) || (abs(x-0.5)<0.1 && abs(y-0.5)<0.1);//ring with center dot
output tile(int i:245)(float x,float y)=>abs(x-0.5)<0.1 && abs(y-0.5)<0.3 && abs(x-0.5)<0.05 || abs(y-0.5)<0.1 && abs(x-0.5)<0.3 && abs(y-0.5)<0.05;//cross with overlapping center
output tile(int i:246)(float x,float y)=>abs(x-0.5)<0.4 && abs(y-0.5)<0.4 && abs(x-0.5)+abs(y-0.5)>0.3 && abs(x-0.5)-abs(y-0.5)<0.15 && abs(y-0.5)-abs(x-0.5)<0.15;//square with diamond intersection
output tile(int i:247)(float x,float y)=>(abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && abs((x-0.5)-(y-0.5))<0.1 && abs((x-0.5)+(y-0.5)-1.0)>0.3) || (abs(x-0.5)<0.1 && abs(y-0.5)<0.1);//diamond with diagonal exclusion and center dot
output tile(int i:248)(float x,float y)=>(abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)*abs(y-0.5)<0.01 && abs(x-0.5)+abs(y-0.5)<0.2) || (abs(x-0.5)<0.05 && abs(y-0.5)<0.05);//combined small patterns
output tile(int i:249)(float x,float y)=>abs(x-0.5)<0.35 && abs(y-0.5)<0.35 && abs(x-0.5)>0.15 && abs(y-0.5)>0.15 && abs((x-0.5)-(y-0.5))>0.05 && abs((x-0.5)+(y-0.5)-1.0)>0.05;//square with inner exclusions
