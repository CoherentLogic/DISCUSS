DISCUSS
 S DF="MON DD YEAR 12:60AM"
 I '$D(^DISCUSS("CONF","ID")) S ^DISCUSS("CONF","ID")=1
 S USER="guest",PAR="",PARL=0,BOARD="NONE",MSGID=^DISCUSS("CONF","ID")-1
 D SLANG($P($P($ZTRNLNM("LANG"),".",1),"_",1))
 D INIT
 Q
DEFMENUS
 S UA("login")="LOGIN^DISCUSS:"_$$MSG(7)
 S UA("new")="NEWACCT^DISCUSS:"_$$MSG(8)
 S UA("exit")="EXIT^DISCUSS:"_$$MSG(9)
 S UA("lang")="LANG^DISCUSS:"_$$MSG(25)
 S UA("?")="HELP^DISCUSS:"_$$MSG(10)
 S UA("%%%")="INV^DISCUSS:"_$$MSG(11)
 M LA=UA K LA("login"),LA("new") 
 S LA("go")="GO^DISCUSS:"_$$MSG(15)
 S LA("id")="ID^DISCUSS:"_$$MSG(16)
 S LA("me")="IDME^DISCUSS:"_$$MSG(17)
 S LA("new")="NEW^DISCUSS:"_$$MSG(32)
 S LA("list")="LIST^DISCUSS:"_$$MSG(31)
 S LA("read")="READ^DISCUSS:"_$$MSG(33)
 S LA("reply")="REPLY^DISCUSS:"_$$MSG(35)
 S LA("who")="WHO^DISCUSS:List currently online users"
 S LA("history")="HISTORY^DISCUSS:Show my history"
 Q
SLANG(L) S LANG=L D DEFMENUS I USER'="guest"  D USERMNU
 I USER="guest"  D GUESTMNU 
 W "USER = ",USER," LANG = ",LANG,! Q
GUESTMNU K ACT M ACT=UA Q
USERMNU K ACT M ACT=LA Q
INIT W !,$$MSG(1),!,$$MSG(2),!,$$MSG(3),!,! 
 W $$MSG(34)," ",^DISCUSS("CONF","ID"),!,$$MSG(19),!,!
 G MAIN
MAIN K PAR S IN="",I="" W "B:",BOARD,"/M:",MSGID," [",USER,"]> " R IN W ! S PARL=$L(IN," ") F I=1:1:PARL S PAR(I)=$P(IN," ",I) 
 S ENT=$G(ACT(PAR(1)),ACT("%%%")) S FNC=$P(ENT,":",1),DESC=$P(ENT,":",2) W ">>> ",DESC,! D @FNC D HISTENT(IN) G MAIN
HISTENT(CMD) I USER'="guest" S H=$H,^USERS(USER,"HISTORY",H)=CMD,^USERS(USER,"HISTORY")=H Q
 Q
HISTORY Q:'$D(^USERS(USER,"HISTORY"))  S S="",I=0 F  S S=$O(^USERS(USER,"HISTORY",S)) Q:S=""  W I,?12,$ZD(S,DF),":  ",^USERS(USER,"HISTORY",S),! S I=I+1
 Q
LASTACT(U) I $D(^USERS(U,"HISTORY")) S A=^USERS(U,"HISTORY") W $ZD(A,DF) Q
 Q
LOGIN N U,P I PARL>1 S U=PAR(2)
 I PARL=1 W $$MSG(4),"  " R U 
 W !,$$MSG(5),"  " U $P:NOECHO R P U $P:ECHO W ! I $G(^USERS(U,"PW"))'=P W $$MSG(13),! Q
 S USER=U,^SESS($J)=USER,^SESS($J,"START")=$H D SLANG($G(^USERS(U,"LANG"),"en")) W $$MSG(20)_", ",^USERS(USER,"NAME"),"!",!
 D DEFMENUS K ACT M ACT=LA Q
EXIT K ^SESS($J),^USERS(USER,"BOARD") W $$MSG(21),!,!,! H
INV Q
NEWACCT N U,P,NAM W $$MSG(22)," " R U W !,$$MSG(23)," " U $P:NOECHO R P U $P:ECHO W !,$$MSG(24)," " R NAM 
 D CRUSER(U,P,NAM) Q
CRUSER(UN,PW,NAM) I $D(^USERS(UN)) W $$MSG(12),! Q
 L +(^USERS(UN)):10 I $T S ^USERS(UN,"PW")=PW,^("NAME")=NAM L -(^USERS(UN)) Q
 Q
MSG(NUM) N LOC S LOC="MSGS"_LANG_"+"_NUM_"^DISCMSGS" Q $P($T(@LOC),";;",2)
HELP N SUB S SUB="" F  S SUB=$O(ACT(SUB)) Q:SUB=""  I SUB'="%%%" W "  ",SUB,": ",$P(ACT(SUB),":",2),!
 Q
ID 
 N UID S UID=USER S:$D(PAR(2)) UID=PAR(2) I '$D(^USERS(UID)) W $$MSG(26)," '",UID,"'",! Q
 W $$MSG(27)," '",UID,"' ",$$MSG(28)," ",^USERS(UID,"NAME"),".",!
 W "Current board:  ",$G(^USERS(UID,"BOARD"),"User Offline"),!
 W "Last Activity:  " D LASTACT(UID) W ! Q
IDME S PAR(2)=USER D ID Q
LANG N LL,S,I,O S S="",I=0,O(0)=LANG,O(0,"NAME")=$$MSG(29) D GLANGS(.LL) F  S S=$O(LL(S)),I=I+1 Q:S=""  S O(I)=LL(S),O(I,"NAME")=S
 S ID="" F  S ID=$O(O(ID)) Q:ID=""  W ID,": ",O(ID,"NAME"),!
 N SO W !,$$MSG(30),"> " R SO W ! S:+SO'>I ^USERS(USER,"LANG")=O(SO) D SLANG(O(SO))
 I +SO>I W $$MSG(11),! 
 Q      
GLANGS(RES) N L,P,I,N,A S L=$P($T(^DISCMSGS),";;",2) F I=1:1:$L(L,",")  S P=$P(L,",",I),N=$P(P,":",1),A=$P(P,":",2),RES(N)=A
 Q
NEW I PARL=1 W $$MSG(36),! Q
 I (PAR(2)'="message")&(PAR(2)'="board") W $$MSG(36),! Q
 I PAR(2)="message" D NMESG Q
 I PAR(2)="board" D NBOARD Q
NMESG Q
NBOARD N NB,SC W $$MSG(38)," " R NB W !,$$MSG(40)," " U $P:CONV R SC#8 U $P:NOCONV W ! S:'$D(^DISCUSS("BOARDS",SC)) ^DISCUSS("BOARDS",SC,"NAME")=NB,^("MOD")=USER 
 ZSYSTEM "mkdir -p /home/discuss/DISCUSS/boards/"_SC_"/posts > /dev/null 2>&1" 
 ZSYSTEM "cp /home/discuss/DISCUSS/templates/BOARDWLC.DTP /home/discuss/DISCUSS/boards/"_SC_"/.message"
 ZSYSTEM "rnano /home/discuss/DISCUSS/boards/"_SC_"/.message"
 S PAR(2)=SC D GO
 Q
LIST I PARL=1 W $$MSG(37),! Q
 I (PAR(2)'="message")&(PAR(2)'="board") W $$MSG(37),! Q
 I PAR(2)="message" D LMESG Q
 I PAR(2)="board" D LBOARD Q 
LMESG
LBOARD W $J("ID",15),$J("MODERATOR",15),$J("BOARD NAME",60),! S SC="" F  S SC=$O(^DISCUSS("BOARDS",SC)) Q:SC=""  S NB=^DISCUSS("BOARDS",SC,"NAME"),MOD=^("MOD") W $J(SC,15),$J(MOD,15),$J(NB,60),!
READ Q
REPLY Q
GO 
 N TB S TB=$$UCASE(PAR(2)) 
 I $D(^DISCUSS("BOARDS",TB)) S BOARD=TB D WELCOME(TB) Q
 N B,PROP,L S B="",PROP=1,L=$L(TB)
 F  S B=$O(^DISCUSS("BOARDS",B)) Q:B=""  D
 . I $E(B,1,L)=TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME"),PROP=PROP+1
 . I B[TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME")
 . I $$UCASE(^DISCUSS("BOARDS",B,"NAME"))[TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME") 
 S PROP=PROP-1,B=""
 I PROP=1 S B=$O(PROP(B)),BOARD=B W "I assume you meant ",B," (",PROP(B,"NAME"),")",! D WELCOME(B) Q
 I PROP<1 W "No board matches that shortcut",! Q
 S B=""
 W "Did you mean:",!
 F  S B=$O(PROP(B)) Q:B=""  D
 . W " ",B,":  ",?15,PROP(B,"NAME")," (command: 'go ",$$LCASE(B),"')",!
 W ! Q
WELCOME(B) W "Changed to board '",^DISCUSS("BOARDS",B,"NAME"),"'",! 
 S ^USERS(USER,"BOARD")=B
 ZSYSTEM "cat /home/discuss/DISCUSS/boards/"_B_"/.message 2>/dev/null" Q
UCASE(I) Q $TR(I,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LCASE(I) Q $TR(I,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")