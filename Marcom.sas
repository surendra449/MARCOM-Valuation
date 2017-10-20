proc means data=tmp1.case3;
run;
proc reg data = tmp1.case3;
model NS = 
dm_cnt sms_cnt email_cnt
adv_NPI	adv_SPC	unadv
q2 q3 q4
ColumbusDay Memorial_Day Super_Savings Super_Weekend;
run; quit;
proc contents data=tmp1.case3 out=case;
run;
proc reg data = tmp1.case3;
model ns = 
/*Coupon_Commotion Daffodil_Dash Firefly_Frenzy Friday_Doorbusters Friends_Family Home_Sale July4Sale Labor_Day Memorial_Day Merry_Moolah Moonlight_Madness PreEaster 
PresidentsDay Saturday_Doorbusters Super_Savings Super_Weekend ThreeDaySale VeteransDay Winter_Warmup*/ adv_NPI adv_SPC disc_perc dm_cnt email_cnt 
q1 q2 q3 q4 sms_cnt unadv net_price/selection=stepwise;
run;

proc gplot data=tmp1.case3;
plot NS*net_price;
run;
proc corr data=tmp1.case3;
run;
proc reg data = tmp1.case3;
model ns = dm_cnt net_price q4 unadv sms_cnt Friday_Doorbusters q3 Super_Savings email_cnt Super_Weekend/VIF COLLIN;
run;quit;
proc reg data = tmp1.case3;
model ns = dm_cnt net_price q4 unadv sms_cnt Friday_Doorbusters q3 Super_Savings email_cnt Super_Weekend;
run;
proc reg data=tmp1.case3 plots(maxpoints=110);
model ns = dm_cnt net_price q4 unadv sms_cnt Friday_Doorbusters q3 Super_Savings email_cnt Super_Weekend; 
output out = case3 p = PUNITS r = RUNITS student=student;
run;
data case3;
set case3;
pos =0; neg = 0;
if student > 3.0 then delete;
if student < -3.0 then delete;
run;
proc reg data=tmp1.case3 plots(maxpoints=110);
model ns = dm_cnt net_price q4 unadv sms_cnt Friday_Doorbusters q3 Super_Savings email_cnt Super_Weekend; 
output out = case3 p = PUNITS r = RUNITS student=student;
run;
data case3;
set case3;
pos =0; neg = 0;
if student > 3.0 then pos = 1;
if student < -3.0 then neg = 1;
run;

proc reg data = case3;
model ns = pos dm_cnt net_price q4 unadv sms_cnt Friday_Doorbusters q3 Super_Savings email_cnt Super_Weekend;
run;
/*
proc pdlreg data = case3;
model ns =  net_price(3,3) dm_cnt(4,2) email_cnt(2,2) sms_cnt(3,1) unadv(4,1) q3 q4 Friday_Doorbusters Super_Savings Super_Weekend/dwprob;
run;*/
proc pdlreg data = case3;
model ns = neg net_price(7,7) dm_cnt(4,4) email_cnt(2,2) sms_cnt(3,3) adv_NPI(5,5) adv_SPC(5,5) unadv(4,4) q2 q3 q4 ColumbusDay
 Super_Savings Super_Weekend ThreeDaySale Friday_Doorbusters/dwprob;
run;
