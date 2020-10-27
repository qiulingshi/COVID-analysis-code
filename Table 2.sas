libname A 'F:\nature medicine\naturemedicine\data';

/*-------按类型计算有效再生数R-------------------------------------*/
/*注意：只区分上代是否确诊，下代不区分*/

/*确诊病例代际传播*/
/*G1: 30--> G2: 49*/
/*30 -> 49 */

/*G1-->G2*/
data a;
do i=1 to 79;
  if i<=30 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;

ods listing close;
ods html close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20200419 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data ttq1;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=ttq1;
var r;
output out=rcl12 mean=mean var=varq1 pctlpre=p pctlpts=2.5 50 97.5;
run;
ods html;
ods listing;
proc print data=rcl12;
run;


title "2.G2为确诊患者人数-->G3感染人数";
/*确诊病例代际传播*/
/*  54--> 29 */
/*G2-->G3*/
data a;
do i=1 to 83;
  if i<=54 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;
ods html close;
ods listing close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20202325 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;


proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data ttq2;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=ttq2;
var r;
output out=rcl23 mean=mean var=varq2 pctlpre=p pctlpts=2.5 50 97.5;
run;
ods html;
ods listing;
proc print data=rcl23;
run;



title "3.G3为确诊患者人数-->G4感染人数";
/*确诊病例代际传播*/
/* 13 --> 8 */

/*G3-->G4*/
data a;
do i=1 to 21;
  if i<=13 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;
ods html close;
ods listing close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20202327 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data ttq3;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=ttq3;
var r;
output out=rcl34 mean=mean var=varq3 pctlpre=p pctlpts=2.5 50 97.5;
run;
ods html;
ods listing;
proc print data=rcl34;
run;


title "4.G4为确诊患者人数-->G5感染人数";
/*  G4->G5 确诊 6---> 感染0 */


/*打印*/
/*确诊患者有效再生数*/
data RN;
set rcl12(in=i1) rcl23(in=i2) rcl34(in=i3);
if i1 then Lab="G1->G2";
if i2 then Lab="G2->G3";
if i3 then Lab="G3->G4";
Rvalue=cat(put(p50,5.2),"(",put(p2_5,5.2),",",put(p97_5,5.2),")");
format mean p2_5 p97_5 5.2;
label lab="确诊患者代际有效再生数（R）"
      mean="点估计R"
      p2_5=%str('95%CI下限')
      p97_5=%str('95%CI下限')
      rvalue=%str("点估计及95%CI");
run;

title "1.确诊病例各代际有效再生数R（基于家系）";

ods listing;
ods html;
proc print label;
var lab rvalue mean;
run;



/* 2.==============阳性检测患者代际传播=================*/

/*G1：第1代中的阳性病例，且在代系谱中*/
/*9 -> 22 */

/*G1-->G2*/
data a;
do i=1 to 31;
  if i<=9 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;

ods listing close;
ods html close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20202339 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;


proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tty1;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=tty1;
var r;
output out=rcl12 mean=mean var=vary1 pctlpre=p pctlpts=2.5 50 97.5;
run;

ods listing ;
ods html;

proc print data=rcl12;
run;


/*G2：第2代中的阳性病例，且在代系谱中*/
/*阳性检测患者代际传播*/
/* 20 --> 3*/

/*G2-->G3*/
data a;
do i=1 to 23;
  if i<=20 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;
ods listing close;
ods html close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20202340 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;


proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tty2;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=tty2;
var r;
output out=rcl23 mean=mean var=varq2 pctlpre=p pctlpts=2.5 50 97.5;
run;
ods listing ;
ods html;
proc print data=rcl23;
run;


/*G3->G4：第3代中的阳性病例，且在代系谱中*/
/*阳性检测患者代际传播*/
/* 16 -> 1*/

/*G3-->G4*/
data a;
do i=1 to 17;
  if i<=16 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;
ods html close;
ods listing close;
proc surveyselect data=a method=BALBOOT reps=5000 seed=20202341 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tty3;
set tsf;
if _2=. then _2=0;
r=_2/_1;
run;

proc univariate data=tty3;
var r;
output out=rcl34 mean=mean var=vary3 pctlpre=p pctlpts=2.5 50 97.5;
run;
ods html;
ods close;
proc print data=rcl34;
run;



/*G4->G5：第4代中的阳性病例，且在代系谱中*/
/*阳性检测患者代际传播*/
/* 3 -> 5*/
/*G4-->G5*/



/*阳性患者有效再生数*/
data RN;
set rcl12(in=i1) rcl23(in=i2) rcl34(in=i3) ;
if i1 then Lab="G1->G2";
if i2 then Lab="G2->G3";
if i3 then Lab="G3->G4";
Rvalue=cat(put(p50,5.2),"(",put(p2_5,5.2),",",put(p97_5,5.2),")");
format mean p2_5 p97_5 5.2;
label lab="阳性检测代际有效再生数（R）"
      mean="点估计R"
      p2_5=%str('95%CI下限')
      p97_5=%str('95%CI下限')
      rvalue=%str("点估计及95%CI");
run;

title "阳性患者有效再生数R（基于家系）";
ods listing;
ods html;
proc print label;
var lab rvalue mean;
run;


/*=========全部病例：45 74 29 9 5=============*/
/*R1_2： 45--> 74   */
data a;
do i=1 to 119;
  if i<=45 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;

proc surveyselect data=a method=BALBOOT reps=5000 seed=20200415 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tt;
set tsf;
r=_2/_1;
run;

proc univariate data=tt;
var r;
output out=rcl12 mean=mean pctlpre=p pctlpts=2.5 50 97.5;
run;
proc print data=rcl12;
run;


/*45	74	29	9	5*/

/*2-->3: 74-29*/

data a23;
do i=1 to 103;
  if i<=74 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;

proc surveyselect data=a23 method=BALBOOT reps=5000 seed=2020041513 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;
/*proc freq data=samplerep noprint;*/
/*table Replicate*outcome/chisq nopercent norow nocol;*/
/*output out=sf1;*/
/*run;*/

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tt;
set tsf;
r=_2/_1;
run;

proc univariate data=tt;
var r;
output out=rcl23 mean=mean pctlpre=p pctlpts=2.5 50 97.5;
run;
proc print data=rcl23;
run;

/*45	74	29	9	5*/

/*3-->4:*/
data a34;
do i=1 to 38;
  if i<=29 then outcome=1;else outcome=2;
  output;
end;
drop i;
run;

proc surveyselect data=a34 method=BALBOOT reps=5000 seed=04152345 out=SampleRep;
run;
proc tabulate data=samplerep out=sf;
class Replicate outcome;
table Replicate,outcome;
run;
/*proc freq data=samplerep noprint;*/
/*table Replicate*outcome/chisq nopercent norow nocol;*/
/*output out=sf1;*/
/*run;*/

proc transpose data=sf out=tsf;
by Replicate;
id outcome;
var n;
run;

data tt;
set tsf;
r=_2/_1;
run;

proc univariate data=tt;
var r;
output out=rcl34 mean=mean pctlpre=p pctlpts=2.5 50 97.5;
run;
proc print data=rcl34;
run;


/*45	74	29	9	5*/
/*4-->5:*/



/*全部患者有效再生数*/
data RN;
set rcl12(in=i1) rcl23(in=i2) rcl34(in=i3)  ;
if i1 then Lab="G1->G2";
if i2 then Lab="G2->G3";
if i3 then Lab="G3->G4";
Rvalue=cat(put(p50,5.2),"(",put(p2_5,5.2),",",put(p97_5,5.2),")");
format mean p2_5 p97_5 5.2;
label lab="有效再生数（R）"
      mean="点估计R"
      p2_5=%str('95%CI下限')
      p97_5=%str('95%CI下限')
      rvalue=%str("点估计及95%CI");
run;

title "全部患者有效再生数R（基于家系）";
ods listing;
ods html;
proc print label;
var lab rvalue;
run;




/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/
/*Transmission risk period for asymptomatic cases*/
/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/

data asymtransrisk; set A.cqmu;
  if group=2 & group_gen=1 then transrisk=Diagdate-G1toWZdate;
  if group=2 & group_gen in (2 3 4 5) then transrisk=Diagdate-firstdate;
run;

proc tabulate data=asymtransrisk; where group=2 & group_gen in (1 2 3 4 5);
 var transrisk; 
 class group_gen;
 table transrisk,group_gen*(mean std n*f=4.0);
run;

proc print data=asymtransrisk; where group=2 & group_gen =1;
 var ID group_gen G1toWZdate Diagdate transrisk;
run;

/***************************************************************************************************************************************************************/
/*number of Contacts before symptom onset or diagnosis*/
/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/

data days_contact; set A.cqmu;
  if p_group=1 then do;  /* before symptomatic onset for symptomatic case*/
   if firstdate>=P_Onsetdate then presymptom_contact=2;
   if firstdate<P_Onsetdate then presymptom_contact=1;
   if firstdate=. then presymptom_contact=.;
   if P_Onsetdate=. then presymptom_contact=.;
 end;

  if p_group=2 then do;  /* before diagnosis for asymptomatic case*/
   if firstdate>=P_Diagdate then asymptom_contact=2;
   if firstdate<P_Diagdate then asymptom_contact=1;
   if firstdate=. then asymptom_contact=.;
   if P_Diagdate=. then asymptom_contact=.;
  end;
run;

PROC FORMAT;
    VALUE contact
      1 = 'Contact before symptom onset'  2 = 'Contact before symptom onset';

    VALUE gender
      1 = 'Contact before diagnosis' 2 = 'Contact before diagnosis' ;

	VALUE type 
      1 = 'Symptomatic cases' 2 = 'Asymptomatic cases' 3 = 'Negative close contacts';
run;

proc tabulate data=days_contact;
 class presymptom_contact group;
 tables presymptom_contact,group*(n*f=4.0 rowpctn)  all="Total close contacts";
 label presymptom_contact="Symptomatic case as the source case";
 label group="Type of Participant";

 format group type.;
run;

proc tabulate data=days_contact;
 class asymptom_contact group;
 tables asymptom_contact,group*(n*f=4.0 rowpctn) all="Total close contacts";
 label asymptom_contact="Asymptomatic case as the source case";
 label group="Type of Participant";

 format group type.;
run;


/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/
/*Dispension Parameter K*/
/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/

/* Fit Negative Binomial  */
data CountData;
set A.cqmu;
count=numoffsprings;
/*Generation*/
/*where numoffsprings ne . and group_gen =1;*/
/*总的*/
where numoffsprings ne . and group_gen ne 9;
keep group_gen numoffsprings count;
run;


/* Fit Negative Binomial distribution to data */
proc genmod data=CountData;
   model count= /dist=NegBin;       /* No variables are specified, only mean is estimated */
   ods output parameterestimates=NegBinParameters;
run;

/* Transpose Data */
proc transpose data=NegBinParameters out=NegBinParameters;
   var estimate lowerwaldcl upperwaldcl;
   id parameter;
run;

/* Calculate k and p from intercept and dispersion parameters */
data NegBinParameters;
   set NegBinParameters;
   k = 1/dispersion;
   p = 1/(1+exp(intercept)*dispersion);
run;

proc transpose data=NegBinParameters out=tneg;
var k;
id _name_;
run;
/*Dispersion k and 95%CI */

proc print data=tneg;
run;
