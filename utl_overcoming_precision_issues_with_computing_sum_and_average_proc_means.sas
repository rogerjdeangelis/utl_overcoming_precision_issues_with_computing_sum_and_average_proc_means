Overcoming precision issues with Computing Sum and Average PROC MEANS

Note: 128bit floats completey eliminates this problem and many others.
Eliminate bigint, decimal arithmetic, memory addressing .... other issues.

This method is especially useful when dealing with dollars and cents.

"I have encountered a problem while computing sum and mean in SAS for
particularly a set of four numbers (0.3, -0.2, -0.1, 0).
While I pass these numbers to Proc means the output
gives sum as -2.77556E-17 and mean as -6.93889E-18.
While actually the sum should be zero and hence the mean should be zero."

Problem:  SUM and MEAN of (0.3, -0.2, -0.1, 0) should be zero

  The MEANS Procedure

  Variable             Sum            Mean
  ----------------------------------------
  DEC         -2.77556E-17    -6.93889E-18


INPUT
=====

  * for display purposes until inexact operations are needed;
  proc format;
  picture decimal
      low-high = '9.9' ( mult=.1);
  run;quit;


  WORK.HAVE total obs=4

  Obs     DEC

   1      0.3
   2     -0.2
   3     -0.1
   4      0.0


WANT
====

   SUM and MEAN of (0.3, -0.2, -0.1, 0) should be zero

                      NUM_SUM                  NUM_MEAN

 Decimal       0.0000000000000000000     0.0000000000000000000
 Float hex       '0000000000000000'x       '0000000000000000'x


  Analysis Variable : NUM

         Sum            Mean
 ----------------------------
          0              0
 ----------------------------

 WITH FORMAT

  NUM_SUM    NUM_MEAN

    0.0        0.0

PROCESS
=======

  Keep data as integers by mutiplying by 10)

  With 128bit floats this is not necessary (fuzz 10**(-100)?) and
  only worry about 18 decimal places (round 10**(-18))

  data want;
    set have;
    num=round(10*dec,1);
  run;quit;

  ods output summary=sumry;
  proc means data=have(drop=dec) sum mean;
  run;quit;

  proc print data=sumry;
  format num: decimal.;
  run;quit;

*                _                _       _
 _ __ ___   __ _| | _____      __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \    / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/   | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|    \__,_|\__,_|\__\__,_|

;

data have;
  input dec;
cards4;
0.3
-0.2
-0.1
0
;;;;
run;quit;

