//**************************************************************************//
//***                         ZZ NRP AA TT [x3]                            ***
//**************************************************************************//
#property copyright   "©  Tankk,  10  January  2017,  http://forexsystemsru.com/" 
#property link        "http://forexsystemsru.com/indikatory-foreks/76901-delyus`-graalem.html"    //http://forexsystemsru.com/indikatory-foreks-f41/
#property description "Copyright © 2008, AleksD  -->  ''Казахский Удав''  :))"
#property description " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
#property description "ZigZag предназначается для анализа движений цен с заданной амплитудой. Индикатор изображает только самые важные развороты, что значительно облегчает оценку графиков." 
#property description "Стрелки показывают БАР, на котором последний Low/High полностью сформирован."
//#property version  "3.00"
//#property strict
#property indicator_chart_window
#property indicator_buffers 7
//-----
#property indicator_color1  Green   //LightCyan   //RoyalBlue   
#property indicator_color2  White   //LightCyan   //LightSteelBlue
#property indicator_color3  Red     //OrangeRed    //Gold
#property indicator_color4  White   //
#property indicator_color5  Red     //Lime
#property indicator_color6  RoyalBlue   //
#property indicator_color7  MediumOrchid     //Lime
//---
#property indicator_width1  1
#property indicator_width6  1
#property indicator_width7  1
//#property indicator_width4  0
//#property indicator_width5  0
//---
#property indicator_style1  2
#property indicator_style6  2
#property indicator_style7  2
//**************************************************************************//
//***                   Custom indicator ENUM settings                     ***
//**************************************************************************//
enum calcZZ { CloseClose, LowHigh, KazakhBoa};
enum drawZZ { NoZigZag, zzLINE, zzARROWS, zzFULL };
//**************************************************************************//
//***                Custom indicator input parameters                     *** 
//**************************************************************************//

extern int               ZZHistory  =  864;
extern calcZZ          Calculation  =  KazakhBoa;           
extern int                 ZZSpeed  =  12;
extern ENUM_MA_METHOD     MAMethod  =  MODE_LWMA;
extern int            ChannelWidth  =  0;
extern bool            ShowChannel  =  true;
extern drawZZ           ShowZigZag  =  zzFULL;  //ARROWS;  //NoZigZag; 
extern int                   ZZGap  =  0,
                           ZZCodLO  =  168,  //218,  //233  //110
                           ZZCodUP  =  168,  //217,  //234  //111
                            ZZSize  =  2; 
extern bool             ShowArrows  =  true;                            
extern int                  ArrGap  =  0,   //Дистанция от High/Low свечи  
                          ArrCodUP  =  233,  //147,  116, 117, 234,   //226
                          ArrCodDN  =  234,   //181,  233,   //225
                           ArrSize  =  0;
extern string  ZIGZAG_ALERTS  =  "-----------------------------------------------------------------";  //
extern int               SIGNALBAR  =  0;
extern bool          AlertsMessage  =  true,   //false,    
                       AlertsSound  =  true,   //false,
                       AlertsEmail  =  false,
                      AlertsMobile  =  false;
extern string            SoundFile  =  "news.wav";   //"stops.wav"   //"alert2.wav"   //"expert.wav"

//**************************************************************************//
//***                     Custom indicator buffers                         ***  
//**************************************************************************//
double ZigZag[], ZZBottom[], ZZVertex[], ArrUP[], ArrDN[];  
double MAUnder[], MAOver[];  int TimeBar=0;   
string ZZNAME = "ZZ NRP AA TT ["+ZZSpeed+"]"; 
//**************************************************************************//
//***               Custom indicator initialization function               ***
//**************************************************************************//
int init()
{
  	IndicatorBuffers(7);   IndicatorDigits(Digits);  if (Digits==3 || Digits==5) IndicatorDigits(Digits-1);
//---- 7 распределенных буфера индикатора 
   SetIndexBuffer(0,ZigZag);
   SetIndexBuffer(1,ZZBottom);
   SetIndexBuffer(2,ZZVertex);
   SetIndexBuffer(3,ArrUP);
   SetIndexBuffer(4,ArrDN);
   SetIndexBuffer(5,MAUnder);
   SetIndexBuffer(6,MAOver);
//---- настройка параметров отрисовки 
   int ZZL=DRAW_NONE;  if (ShowZigZag==1 || ShowZigZag==3) ZZL=DRAW_SECTION; 
  	SetIndexStyle(0,ZZL);   	
   int ZZA=DRAW_NONE;  if (ShowZigZag==2 || ShowZigZag==3) ZZA=DRAW_ARROW; 
   SetIndexStyle(1,ZZA,0,ZZSize);   SetIndexArrow(1,ZZCodLO);
   SetIndexStyle(2,ZZA,0,ZZSize);   SetIndexArrow(2,ZZCodUP);
   int ARR=DRAW_NONE;  if (ShowArrows) ARR=DRAW_ARROW; 
   SetIndexStyle(3,ARR,0,ArrSize);   SetIndexArrow(3,ArrCodUP);  
  	SetIndexStyle(4,ARR,0,ArrSize);   SetIndexArrow(4,ArrCodDN);   	
   int LNT=DRAW_NONE;  if (ShowChannel) LNT=DRAW_LINE; 
  	SetIndexStyle(5,LNT);   	
  	SetIndexStyle(6,LNT);   	
//---- значение 0 отображаться не будет 
  	SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
//---- отображение в DataWindow 
  	SetIndexLabel(0,"ZigZag ["+IntegerToString(ZZSpeed)+"]");
   SetIndexLabel(1,"ZZ Bottom");
  	SetIndexLabel(2,"ZZ Vertex");
   SetIndexLabel(3,"Arrow BUY");
   SetIndexLabel(4,"Arrow SELL");   
   SetIndexLabel(5,"MA Under ["+IntegerToString(ZZSpeed)+"]");
   SetIndexLabel(6,"MA Over  ["+IntegerToString(ZZSpeed)+"]");   
//---- "короткое имя" для DataWindow и подокна индикатора +++ "уникальное имя индикатора"
   IndicatorShortName(ZZNAME);

//---//---//---
return(0);
}
//**************************************************************************//
//***              Custom indicator deinitialization function              ***
//**************************************************************************//
int deinit() { return(0); }
//**************************************************************************//
//***                 Custom indicator iteration function                  ***
//**************************************************************************//
int start()
{
   int  w, limit;
   int counted_bars = IndicatorCounted();   
   if (counted_bars < 0) return (-1);       //Стандарт-Вариант!!!
   if (counted_bars > 0) counted_bars--;
   limit = ZZHistory; 
   if (ZZHistory==0) limit = Bars-counted_bars;;      
//**************************************************************************//

   int ZagAA, ZagNN, zup, zdn;
   double ZZLL, ZZHH, BBHH, BBLL; 
     //---
   double MAGap=ChannelWidth*Point;   if (Digits==3 || Digits==5) MAGap=ChannelWidth*Point*10;
   double GapZZ=ZZGap*Point;   if (Digits==3 || Digits==5) GapZZ=ZZGap*Point*10;
   double GapAA=ArrGap*Point;   if (Digits==3 || Digits==5) GapAA=ArrGap*Point*10;
   //---
   for (w=limit; w>=0; w--)    //for (i=0; i<=ZZHistory; i++)   //
    { 
     ZZVertex[w]=0;  ZZBottom[w]=0;  ArrUP[w]=0;  ArrDN[w]=0;  MAUnder[w]=0;  MAOver[w]=0;   
     //---   //enum calc   { CloseClose, LowHigh, KazakhBoa};
     if (Calculation==KazakhBoa) {
         ZZLL = Low[iLowest(NULL,0,MODE_LOW,ZZSpeed,w+1)];
         ZZHH = High[iHighest(NULL,0,MODE_HIGH,ZZSpeed,w+1)];
         //---
         if (Low[w]<ZZLL && High[w]>ZZHH) { ZagAA=2; if (ZagNN==1) zup=w+1; if (ZagNN==-1) zdn=w+1; }
         else { if (Low[w]<ZZLL) ZagAA=-1; if (High[w]>ZZHH) ZagAA=1; }  }
     //---
     if (Calculation!=KazakhBoa) {
         ZZLL = iMA(NULL,0,ZZSpeed,0,MAMethod,PRICE_LOW,w) -MAGap;   MAUnder[w]=ZZLL;
         ZZHH = iMA(NULL,0,ZZSpeed,0,MAMethod,PRICE_HIGH,w) +MAGap;  MAOver[w]=ZZHH; }
     //---
     if (Calculation==1) {
         if (Low[w]<ZZLL && High[w]>ZZHH) { ZagAA=2; if (ZagNN==1) zup=w+1; if (ZagNN==-1) zdn=w+1; }
         else { if (Low[w]<ZZLL) ZagAA=-1; if (High[w]>ZZHH) ZagAA=1; }  }
     //---
     if (Calculation==0) {
         if ((Close[w]<ZZLL && Close[w+1]>ZZLL) && (Close[w]>ZZHH && Close[w+1]<ZZHH)) { ZagAA=2; if (ZagNN==1) zup=w+1; if (ZagNN==-1) zdn=w+1; }
         else { if (Close[w]<ZZLL) ZagAA=-1; if (Close[w]>ZZHH) ZagAA=1; }  }
     //**************************************************************************//
     if (ZagAA!=ZagNN && ZagNN!=0)   
      {
       if (ZagAA==2) { ZagAA=-ZagNN;  BBHH=High[w];  BBLL=Low[w]; }
       if (ZagAA==-1) { ZigZag[zup]=BBHH;   ZZVertex[zup]=BBHH+GapZZ;  ArrDN[w]=High[w]+GapAA; }  //High[zup] 
       if (ZagAA==1)   { ZigZag[zdn]=BBLL;  ZZBottom[zdn]=BBLL-GapZZ;  ArrUP[w]=Low[w] -GapAA; }  //Low[zdn]
       //---
       BBHH=High[w];  BBLL=Low[w]; 
      }
     //---
     if (ZagAA==1)  { if (High[w]>=BBHH) { BBHH=High[w];  zup=w; } } 
     if (ZagAA==-1) { if (Low[w]<=BBLL)  { BBLL=Low[w];   zdn=w; } } 
     //---
     ZagNN=ZagAA;
//**************************************************************************//
//***                         ZZ NRP AA TT [x3]                            ***
//**************************************************************************//
     
     if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
      {
       string messageDN =(ZZNAME+" - "+Symbol()+", TF ["+IntegerToString(Period())+"]  <<<  ZZ Angle at the Vertex  ==  SELL");   //SSL Channel TT  //HA CLH 4C SHLD TT  //MA 3x3 TT
       string messageUP =(ZZNAME+" - "+Symbol()+", TF ["+IntegerToString(Period())+"]  >>>  ZZ Angle at the Bottom  ==  BUY");    //SSL Channel TT  //HA CLH 4C SHLD TT  //MA 3x3 TT       
       //---
       if (TimeBar!=Time[0] && ArrDN[0+SIGNALBAR]!=0)     
        {
         if (AlertsMessage) Alert(messageDN);
         if (AlertsEmail)   SendMail(Symbol(),messageDN);
         if (AlertsMobile)  SendNotification(messageDN);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"                       
         TimeBar=Time[0];
         //return(0);
        } 
       //---
       else if (TimeBar!=Time[0] && ArrUP[0+SIGNALBAR]!=0) 
        { 
         if (AlertsMessage) Alert(messageUP);
         if (AlertsEmail)   SendMail(Symbol(),messageUP);
         if (AlertsMobile)  SendNotification(messageUP);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
         TimeBar=Time[0];
         //return(0);
        }
      }
//**************************************************************************//
    }  //*конец цикла* for (int w=ZZHistory; w>=0; w--)
//---//---//---
return(0);	
}
//**************************************************************************//
//***                         ZZ NRP AA TT [x3]                            ***
//**************************************************************************//