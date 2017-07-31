DISCUSS
 S DF="MON DD YEAR 12:60AM"
 I '$D(^DISCUSS("CONF","ID")) S ^DISCUSS("CONF","ID")=1
 I '$D(^DISCUSS("CONF","TID")) S ^DISCUSS("CONF","TID")=1
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
 S LA("who")="WHO^DISCUSS:"_$$MSG(41)
 S LA("history")="HISTORY^DISCUSS:"_$$MSG(42)
 S LA("enforce")="ENFORCE^DISCUSS:"_$$MSG(56)
 S LA("unenforce")="UNENF^DISCUSS:"_$$MSG(57)
 S LA("moderate")="MOD^DISCUSS:"_$$MSG(58)
 S LA("assign")="ASGN^DISCUSS:"_$$MSG(63)
 S LA("delete")="DELETE^DISCUSS:"_$$MSG(59)
 S LA("w")="WRITE^DISCUSS:"_$$MSG(74)
 Q
ASGN S PU=$G(PAR(2),"") I (PARL<2)!('$D(^USERS(PU))) W $$MSG(64),! Q
 I ^DISCUSS("BOARDS",BOARD,"MOD")'=USER W $$MSG(62),! Q
 I BOARD="NONE" W $$MSG(65),! Q
 S ^DISCUSS("BOARDS",BOARD,"MOD")=PAR(2) Q 
ENFORCE I BOARD="NONE" W $$MSG(60),! Q
 I ^DISCUSS("BOARDS",BOARD,"MOD")'=USER W $$MSG(62),! Q
 S ^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")="" Q
UNENF I BOARD="NONE" W $$MSG(61),! Q
 I ^DISCUSS("BOARDS",BOARD,"MOD")'=USER W $$MSG(62),! Q
 K ^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED") Q
SLANG(L) S LANG=L D DEFMENUS I USER'="guest"  D USERMNU
 I USER="guest"  D GUESTMNU 
 W "USER = ",USER," LANG = ",LANG,! Q
GUESTMNU K ACT M ACT=UA Q
USERMNU K ACT M ACT=LA Q
INIT W !,$$MSG(1),!,$$MSG(2),!,$$MSG(3),!,! 
 W $$MSG(34)," ",^DISCUSS("CONF","ID"),!,$$MSG(19),!,!
 G MAIN
MAIN W ! D CHATTER K PAR S IN="",I="" W "B:",BOARD,"/P:",MSGID," [",USER,"]> " R IN W ! S PARL=$L(IN," ") F I=1:1:PARL S PAR(I)=$P(IN," ",I) 
 S ENT=$G(ACT(PAR(1)),ACT("%%%")) S FNC=$P(ENT,":",1),DESC=$P(ENT,":",2) W ">>> ",DESC,! D @FNC D HISTENT(IN) G MAIN
HISTENT(CMD) I USER'="guest" S H=$H,^USERS(USER,"HISTORY",H)=CMD,^USERS(USER,"HISTORY")=H Q
 Q
HISTORY Q:'$D(^USERS(USER,"HISTORY"))  S S="",I=0 F  S S=$O(^USERS(USER,"HISTORY",S)) Q:S=""  W I,?12,$ZD(S,DF),":  ",^USERS(USER,"HISTORY",S),! S I=I+1
 Q
LASTACT(U) I $D(^USERS(U,"HISTORY")) S A=^USERS(U,"HISTORY") W $ZD(A,DF) Q
 Q
CHATTER S H="" F  S H=$O(^CHAT(USER,H)) Q:H=""  W $ZD(H,DF)," [",^CHAT(USER,H,"SENDER"),"]: ",^("MSG"),! K ^CHAT(USER,H)
 Q
WRITE S TGT=PAR(2),M=$P(IN," ",3,$L(IN," ")) D WUSER(TGT,M) Q
WUSER(TGT,MSG) S H=$H,^CHAT(TGT,H,"MSG")=MSG,^("SENDER")=USER Q
LOGIN N U,P I PARL>1 S U=PAR(2)
 I PARL=1 W $$MSG(4),"  " R U 
 W !,$$MSG(5),"  " U $P:NOECHO R P U $P:ECHO W ! I $G(^USERS(U,"PW"))'=P W $$MSG(13),! Q
 S USER=U,^SESS(USER,$J)=$H,(BOARD,^USERS(USER,"BOARD"))=$G(^USERS(USER,"LASTBOARD"),"NONE") D SLANG($G(^USERS(U,"LANG"),"en")) W $$MSG(20)_", ",^USERS(USER,"NAME"),"!",!
 D DEFMENUS K ACT M ACT=LA Q
EXIT S ^USERS(USER,"LASTBOARD")=BOARD K:USER'="guest" ^SESS(USER,$J),^USERS(USER,"BOARD") W $$MSG(21),!,!,! H
INV Q
NEWACCT N U,P,NAM W $$MSG(22)," " R U W !,$$MSG(23)," " U $P:NOECHO R P U $P:ECHO W !,$$MSG(24)," " R NAM 
 D CRUSER(U,P,NAM) Q
CRUSER(UN,PW,NAM) I $D(^USERS(UN)) W $$MSG(12),! Q
 L +(^USERS(UN)):10 I $T S ^USERS(UN,"PW")=PW,^("NAME")=NAM L -(^USERS(UN)) Q
 Q
MSG(NUM) N LOC S LOC="MSGS"_LANG_"+"_NUM_"^DISCMSGS" Q $P($T(@LOC),";;",2)
HELP N SUB S SUB="" F  S SUB=$O(ACT(SUB)) Q:SUB=""  I SUB'="%%%" W "  ",SUB,?18,$P(ACT(SUB),":",2),!
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
 I (PAR(2)'="post")&(PAR(2)'="board") W $$MSG(36),! Q
 I PAR(2)="post" D NMESG Q
 I PAR(2)="board" D NBOARD Q
;; ^MESG("M",board,mesg id,"SUBJECT")
;;                        ,"USER")=USER
;;                        ,"TIME")=horolog
;;			  ,"THREAD")=thread id
;; ^MESG("T",board,thread id,mesg id)=""
NMESG N S,T,I,H S H=$H I BOARD="NONE" W $$MSG(48),! Q
 W $$MSG(39)," " R S W !
 S:'$D(^DISCUSS("BOARDS",BOARD,"ID")) ^DISCUSS("BOARDS",BOARD,"ID")=0
 S:'$D(^DISCUSS("BOARDS",BOARD,"TID")) ^DISCUSS("BOARDS",BOARD,"TID")=0
 S I=$I(^DISCUSS("BOARDS",BOARD,"ID")),T=$I(^DISCUSS("BOARDS",BOARD,"TID"))
 S POSTFILE="/home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_I_".DMS" 
 ZSYSTEM "cp /home/discuss/DISCUSS/templates/MESSAGE.TPL "_POSTFILE
 ZSYSTEM "rnano "_POSTFILE
 TSTART
 S ^MESG("M",BOARD,I,"SUBJECT")=S
 S ^("USER")=USER
 S ^("TIME")=H
 S ^("THREAD")=T
 S ^MESG("T",BOARD,T,I)=""
 S ^MESG("I",BOARD,I,T)=""
 TCOMMIT  
 I $D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")) W !,$$MSG(73),!
 S:'$D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")) ^MESG("M",BOARD,I,"APPROVED")=""
 Q
REPLY I (PARL<2)!('$D(^MESG("M",BOARD,$G(PAR(2))))) W $$MSG(51),! Q
 I ($D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")))&('$D(^MESG("M",BOARD,PAR(2),"APPROVED"))) W $$MSG(51),! Q
 S OI=PAR(2) M OM=^MESG("M",BOARD,OI)
 K M S H=$H,M("USER")=USER,M("TIME")=H,M("SUBJECT")=$$REIFY(OM("SUBJECT")),M("THREAD")=OM("THREAD"),I=$I(^DISCUSS("BOARDS",BOARD,"ID"))
 S OPF="/home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_OI_".DMS"
 S NPF="/home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_I_".DMS"
 ZSYSTEM "cat "_OPF_" | mkreply > "_NPF
 ZSYSTEM "rnano "_NPF
 TS
 M ^MESG("M",BOARD,I)=M
 TC
 Q
REIFY(TXT) I $E(TXT,1,3)="Re:" Q TXT
 Q "Re: "_TXT
NBOARD N NB,SC W $$MSG(38)," " R NB W !,$$MSG(40)," " U $P:CONV R SC#8 U $P:NOCONV W ! S:'$D(^DISCUSS("BOARDS",SC)) ^DISCUSS("BOARDS",SC,"NAME")=NB,^("MOD")=USER 
 W !,$$MSG(55)," " R RM#1 
 S:$$UCASE(RM)="Y" ^("MOD","ENFORCED")="" W !
 ZSYSTEM "mkdir -p /home/discuss/DISCUSS/boards/"_SC_"/posts > /dev/null 2>&1" 
 ZSYSTEM "cp /home/discuss/DISCUSS/templates/BOARDWLC.DTP /home/discuss/DISCUSS/boards/"_SC_"/.message"
 ZSYSTEM "rnano /home/discuss/DISCUSS/boards/"_SC_"/.message"
 S PAR(2)=SC D GO
 Q
LIST I PARL=1 W $$MSG(37),! Q
 I (PAR(2)'="post")&(PAR(2)'="board") W $$MSG(37),! Q
 I PAR(2)="post" D LMESG Q
 I PAR(2)="board" D LBOARD Q 
VIEWCNT(B,M) Q:'$D(^MESG("M",B,M,"READ")) 0 N VC,S S VC=0,S="" F  S S=$O(^MESG("M",B,M,"READ",S)) Q:S=""  S VC=VC+1
 Q VC
;; ^MESG("M",board,mesg id,"SUBJECT")
;;                        ,"USER")=USER
;;                        ,"TIME")=horolog
;;			  ,"THREAD")=thread id
;; ^MESG("T",board,thread id,mesg id)=""
;; AUG 24 2017 01:00AM
LMESG N ID,WC S ID="",WC=0,ENF=0 I BOARD="NONE" W $$MSG(49),! Q
 S:$D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")) ENF=1
 W "ID",?12,"DATE",?35,"USER",?45,"VIEWS",?52,"SUBJECT",!
 W "--",?12,"----",?35,"----",?45,"-----",?52,"-------",!
 N S,U,H,R
 F  S ID=$O(^MESG("M",BOARD,ID)) Q:ID=""  D
 . S S=^MESG("M",BOARD,ID,"SUBJECT")
 . S U=^MESG("M",BOARD,ID,"USER")
 . S H=$ZD(^MESG("M",BOARD,ID,"TIME"),DF)
 . S READ="  " S:$D(^MESG("M",BOARD,ID,"READ",USER)) READ="R "
 . I (ENF=0)!($D(^MESG("M",BOARD,ID,"APPROVED"))) W READ,ID,?12,H,?35,U,?45,$$VIEWCNT(BOARD,ID),?52,S,!
 . I WC>23 S WC=0 W $$MSG(50)," " R R#1 Q:$$UCASE(R)="Q"
 Q
MOD I BOARD="NONE" W $$MSG(66),! Q 
 I ^DISCUSS("BOARDS",BOARD,"MOD")'=USER W $$MSG(62),! Q
 I '$D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")) W $$MSG(67),! Q
 S ID="" 
 F  S ID=$O(^MESG("M",BOARD,ID)) Q:ID=""  D
 . I '$D(^MESG("M",BOARD,ID,"APPROVED")) D
 . . S SUBJECT=^MESG("M",BOARD,ID,"SUBJECT"),AUTHOR=^("USER")
 . . W "SUBJECT: ",?20,^MESG("M",BOARD,ID,"SUBJECT"),!
 . . W "AUTHOR:  ",?20,^MESG("M",BOARD,ID,"USER"),!
 . . W "TIME:    ",?20,^MESG("M",BOARD,ID,"TIME"),!
 . . S POSTFILE="/home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_ID_".DMS"
 . . ZSYSTEM "cat "_POSTFILE
 . . W !,!,$$MSG(68)," " R R#1 S R=$$UCASE(R) W !
 . . I R="A" D
 . . . S NOTIFY="[MODERATOR]: Your message '"_SUBJECT_"' in board '"_BOARD_"' has been approved by the board moderator."
 . . . S ^MESG("M",BOARD,ID,"APPROVED")="" W $$MSG(69),!
 . . . D WUSER(AUTHOR,NOTIFY)
 . . I R="R" D
 . . . S NOTIFY="[MODERATOR]: Your message '"_SUBJECT_"' in board '"_BOARD_"' has been rejected by the board moderator."
 . . . K ^MESG("M",BOARD,ID) ZSYSTEM "rm "_POSTFILE W $$MSG(70),!
 . . . D WUSER(AUTHOR,NOTIFY)
 . . I R="P" W $$MSG(71),!
 Q
LBOARD W $J("ID",15),$J("MODERATOR",15),$J("BOARD NAME",60),! S SC="" F  S SC=$O(^DISCUSS("BOARDS",SC)) Q:SC=""  S NB=^DISCUSS("BOARDS",SC,"NAME"),MOD=^("MOD") W $J(SC,15),$J(MOD,15),$J(NB,60) W:$D(^DISCUSS("BOARDS",SC,"MOD","ENFORCED")) "*" W !
 W !,"* = ",$$MSG(72),!
 Q
DELETE I (PARL<2)!('$D(^MESG("M",BOARD,$G(PAR(2))))) W $$MSG(51),! Q
 S ID=PARL(2),AUTH=^MESG("M",BOARD,ID,"USER"),MOD=^DISCUSS("BOARDS",BOARD,"MOD") I (USER'=AUTH)&(USER'=MOD) W $$MSG(75),! Q
 S POSTFILE="/home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_ID_".DMS" K ^MESG("M",BOARD,ID) ZSY "rm "_POSTFILE W $$MSG(79),! Q
READ I (PARL<2)!('$D(^MESG("M",BOARD,$G(PAR(2))))) W $$MSG(51),! Q
 I ($D(^DISCUSS("BOARDS",BOARD,"MOD","ENFORCED")))&('$D(^MESG("M",BOARD,PAR(2),"APPROVED"))) W $$MSG(51),! Q
 S I=PAR(2) M M=^MESG("M",BOARD,I) W $$MSG(52),?12,M("SUBJECT"),!,$$MSG(53),?12,M("USER"),!
 S ^MESG("M",BOARD,PAR(2),"READ",USER)=""
 ZSYSTEM "cat /home/discuss/DISCUSS/boards/"_BOARD_"/posts/"_I_".DMS"
 W $$MSG(54)," " R R#1 W ! I $$UCASE(R)="R" S PAR(2)=I D REPLY Q
 Q
GO 
 N TB S TB=$$UCASE(PAR(2)) 
 I $D(^DISCUSS("BOARDS",TB)) S BOARD=TB D WELCOME(TB) Q
 N B,PROP,L S B="",PROP=1,L=$L(TB)
 F  S B=$O(^DISCUSS("BOARDS",B)) Q:B=""  D
 . I $E(B,1,L)=TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME"),PROP=PROP+1
 . I B[TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME")
 . I $$UCASE(^DISCUSS("BOARDS",B,"NAME"))[TB S PROP(B,"NAME")=^DISCUSS("BOARDS",B,"NAME") 
 S PROP=PROP-1,B=""
 I PROP=1 S B=$O(PROP(B)),BOARD=B W $$MSG(43)," ",B," (",PROP(B,"NAME"),")",! D WELCOME(B) Q
 I PROP<1 W $$MSG(44),! Q
 S B=""
 W $$MSG(45),!
 F  S B=$O(PROP(B)) Q:B=""  D
 . W " ",B,":  ",?15,PROP(B,"NAME")," (",$$MSG(46),": 'go ",$$LCASE(B),"')",!
 W ! Q
WELCOME(B) W $$MSG(47)," '",^DISCUSS("BOARDS",B,"NAME"),"'",! S ^USERS(USER,"BOARD")=B
 ZSYSTEM "cat /home/discuss/DISCUSS/boards/"_B_"/.message 2>/dev/null" Q
WHO W "USER",?18,"NAME",?40,"CURRENT BOARD",! 
 S U="" F  S U=$O(^SESS(U)) Q:U=""  W U,?18,^USERS(U,"NAME"),?40,^USERS(U,"BOARD"),!
 Q
UCASE(I) Q $TR(I,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LCASE(I) Q $TR(I,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")