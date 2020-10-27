libname A 'F:\nature medicine\naturemedicine\data';


/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/
                                      /*Table 1. COVID-19 Spread in Wanzhou, Chongqing.*/
/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/


PROC FORMAT;
    VALUE type
      1 = 'Symptomatic cases'
      2 = 'Asymptomatic cases'
	  3 = 'Negative close contacts';

    VALUE generation
      1 = 'G1' 2 = 'G2' 3 = 'G3' 4 = 'G4' 5 = 'G5'
      6 = 'Close contacts of G5'
      9 = 'Cases with cluster unknown'
	  10 = 'Negative close contacts of cases with cluster unknown'
	  .='Negative close contacts with source case unknown';
RUN;


proc tabulate data=A.cqmu missing;
 class group group_gen;
 tables group_gen,group*(n*f=4.0 rowpctn)
  all="Total close contacts";

 label group_gen="Generation";
 label group="Group of Participants";

 format group type.;
 format group_gen generation.;
run;






/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/
                            /*Table 3: Risk Factors for Infection with SARS-CoV-2 in Wanzhou, Chongqing (N=1398)*/
/***************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************/


data cc1; set A.cqmu;
if group in (1 2) then outcome=2;
if group=3 then outcome=1;

 /*age group:1=ref 18-49*/
if Age_string<18 then agecat=2;
if 18<=Age_string<50 then agecat=1;
if 50<=Age_string<70 then agecat=3;
if Age_string>=70 then agecat=4;

/*timing of contact  ：上代接触时间分为两种情况：1.上代是G1，用的返万时间；2.上代非G1，用的上代接触他们自己的传染源的时间*/
if group_gen=2 then timing=datdif(P_G1toWZdate,Firstdate,'actual');
if group_gen in (3 4 5 6) then timing=datdif(P_Firstdate,Firstdate,'actual');

if 0<=timing<=5 then timing2=2;if timing>5 then timing2=1;


/*exposure time: 1:'<8h' 2= '>=8h'*/
if baolu_time_new in ('8h' '9.5h' '9h' '一直' '一直接触' '20h' '24h' '10h' '11h' '12h' '13h' '14h' '15h' '16h' '17h' '18h') then exp_duration=2;
 else exp_duration=1;
if baolu_time_new='' then exp_duration=.;

/*frequency of contact: 1=Occasional/not so often, 2=Often*/
if contact_freq=1 then contact_freq2=2; if contact_freq in (2 3) then contact_freq2=1;

/*Place of contact 1=Home? 2=Other*/

if contact_place=1 then contact_place2=1; else contact_place2=2;
if contact_place=. then contact_place2=.;

/*Relationship to the source case: 1=Relatives 2=Other*/

if relations=1 then relations2=1; else relations2=2;
if relations=. then relations2=.;


 if outcome ne . & gender ne .  & agecat ne .  & timing2 ne .  & exp_duration ne . & contact_freq2 ne . & contact_place2 ne . & relations2 ne . 
    & contact_way ne . & famID ne . then model_data=1; else model_data=2;
run;


PROC FORMAT;
    VALUE outcome
      1 = 'Negative close contacts'  2 = 'Cases';

    VALUE gender
      1 = 'Men' 2 = 'Women' ;
    
    VALUE agecat
      1 = '18-49'  2 = '<18' 3 = '50-69' 4 = '>=70';

    VALUE timing
      1 = '>5 days'  2 = '<=5 days';

    VALUE exp_duration
      1 = '<8h'  2 = '>=8h';

    VALUE contact_freq
      1 = 'Occasional/not so often' 2 = 'Often';

    VALUE contact_place
      1 = 'Home' 2 = 'Other';

    VALUE relations
      1 = 'Relatives' 2 = 'Other';

    VALUE contact_way
      1 = 'Living together' 2 = 'Dining together' 3 = 'Other';

RUN;


proc tabulate data=cc1;where model_data=1;
 class outcome gender agecat timing2 exp_duration contact_freq2 contact_place2 relations2 contact_way;
 tables (gender agecat timing2 exp_duration contact_freq2 contact_place2 relations2 contact_way),outcome*(n*f=4.0 rowpctn);

Label outcome=""; format outcome outcome.; 
Label gender="Sex"; format gender gender.; 
Label agecat="Age"; format agecat agecat.; 
Label timing2="Timing of contact"; format timing2 timing.; 
Label exp_duration="Duration of contact (hours)"; format exp_duration exp_duration.; 
Label contact_freq2="Frequency of contact"; format contact_freq2 contact_freq.; 
Label contact_place2="Place of contact"; format contact_place2 contact_place.; 
Label relations2="Relationship to the source case"; format relations2 relations.; 
Label contact_way="Mode of contact"; format contact_way contact_way.;
run;

/* unadjusted models*/


%macro A(factor);
  proc genmod data=cc2;where model_data=1;
      class patient_id id &factor(ref=first) famID;
      model outcome(ref=first)=&factor / dist=bin link=logit;
      repeated subject=famID(ID) / corr=unstr corrw;
  run;

%mend a(factor);
 %a(gender)
 %a(agecat)
 %a(timing2)
 %a(exp_duration)
 %a(contact_freq2)
 %a(contact_place2)
 %a(relations2)
 %a(contact_way)



/*adjusted OR， OR and 95%CI were calculated from the estimation and 95%CI*/

 proc genmod data=cc2;where model_data=1;
      class id famID gender(ref=first) agecat(ref=first) timing2(ref=last) exp_duration(ref=first) contact_freq2(ref=first) 
            contact_place2(ref=first) relations2(ref=first) contact_way(ref=first);
      model outcome(ref=first)=gender agecat timing2 exp_duration contact_freq2 contact_way contact_place2 relations2/ dist=bin link=logit type3;
      repeated subject=ID(famID) / corr=unstr corrw;
Label gender="Sex"; format gender gender.; 
Label agecat="Age"; format agecat agecat.; 
Label timing2="Timing of contact"; format timing2 timing.; 
Label exp_duration="Duration of contact (hours)"; format exp_duration exp_duration.; 
Label contact_freq2="Frequency of contact"; format contact_freq2 contact_freq.; 
Label contact_place2="Place of contact"; format contact_place2 contact_place.; 
Label relations2="Relationship to the source case"; format relations2 relations.; 
Label contact_way="Mode of contact"; format contact_way contact_way.;

run;


