//+------------------------------------------------------------------+
//|                                         EMA-Crossover_Signal.mq4 |
//|         Copyright © 2005, Jason Robinson (jnrtrading)            |
//|                   http://www.jnrtading.co.uk                     |
//+------------------------------------------------------------------+

/*
  +------------------------------------------------------------------+
  | Allows you to enter two ema periods and it will then show you at |
  | Which point they crossed over. It is more usful on the shorter   |
  | periods that get obscured by the bars / candlesticks and when    |
  | the zoom level is out. Also allows you then to remove the emas   |
  | from the chart. (emas are initially set at 5 and 6)              |
  +------------------------------------------------------------------+
*/   
#property copyright "Copyright © 2005, Jason Robinson (jnrtrading)"
#property link      "http://www.jnrtrading.co.uk"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 Gray

double CrossUp[];
double CrossDown[];
double ZigZag[];
//extern int FasterMode = 1; //0=sma, 1=ema, 2=smma, 3=lwma
extern int FasterMA =   13;

extern int LastN    = 300;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexEmptyValue(0, 0.0);
   //SetIndexStyle(1, DRAW_ARROW, EMPTY);
   //SetIndexArrow(1, 234);
   //SetIndexBuffer(1, CrossDown);
   //SetIndexEmptyValue(1, 0.0);
   
   SetIndexStyle(1, DRAW_SECTION, EMPTY, 2);
   SetIndexBuffer(1, CrossDown);
   SetIndexEmptyValue(1, 0.0);
   
   SetIndexStyle(2, DRAW_NONE, EMPTY, 1);
   SetIndexBuffer(2, ZigZag);
   SetIndexEmptyValue(2, 0.0);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
 //  ObjectsDeleteAll();
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit, i, x=0;
   double fasterMAnow; // slowerMAnow, fasterMAprevious, slowerMAprevious, fasterMAafter, slowerMAafter;
   double y;
   int counted_bars=IndicatorCounted();
 
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=LastN;
   
   double one_dim[], lastUp=0, lastDw=0;
   int n=0;
   
   for(i = limit; i >= 0; i--) {

      fasterMAnow = iIchimoku(NULL,0,9,FasterMA,52,MODE_KIJUNSEN,i);
    //  f1 = iMA(NULL, 0, FasterMA, ma_shift, FasterMode, FasterPrice, i+1);
      if ((Close[i]<fasterMAnow)  && x!=1 )  //&& (High[i]>=fasterMAnow) && Close[i+1]>=f1
       {
            ZigZag[i] = FindHigh(i); //Up
            RefreshRates();
            x=1;
            
            n++;
            ArrayResize(one_dim,n,LastN); 
            one_dim[n-1]=ZigZag[i];
           if ((ArraySize(one_dim)>1) && (one_dim[n-1-1]>one_dim[n-1-3]))
           {
              y=  one_dim[n-1]-one_dim[n-1-2];
              lastUp =one_dim[n-1-1]-y;
           }
        }
      if ((Close[i]>fasterMAnow)  && x!=-1)  //(Low[i]<=fasterMAnow)&& Close[i+1]<=f1
      {
            ZigZag[i] = FindLow(i); //Down; 
            RefreshRates();
            x=-1;
            
             n++;
             ArrayResize(one_dim,n,LastN); 
             one_dim[n-1]=ZigZag[i];
            if ((ArraySize(one_dim)>1) && (one_dim[n-1]<one_dim[n-1-2]))
           {
              y= one_dim[n-1-2]-one_dim[n-1];
              lastDw =one_dim[n-1-1]+y;
           }
       }
           
     // CrossDown[i]=one_dim[n-1]; 
     
      CrossDown[i] = CrossDown[i+1];
     //  CrossDown[i] = lastUp;
     
      if ((High[i]>lastUp) && (lastUp>0) && (lastDw>0))     
      {
      CrossDown[i]= one_dim[n-1-1]-(High[i]-one_dim[n-1-2]);//  lastDw;
      } 
      
      if ((Low[i]<lastDw) && (lastUp>0) && (lastDw>0))
      {
      CrossDown[i]=  one_dim[n-1-1]+(one_dim[n-1-2]-Low[i]);//   lastUp;
      }       
             
        
       
      //if ((fasterMAnow > slowerMAnow) && (fasterMAprevious < slowerMAprevious) && (fasterMAafter > slowerMAafter)) {
      //   CrossUp[i] = Low[i] - Range*0.5;
      //   ZigZag[i] = Close[i];
      //   previndex = FindPrevI(i);
      //   SetText(DoubleToStr(Close[i], Digits)+" ("+DoubleToStr((MathAbs(ZigZag[i]-ZigZag[previndex]))/Point,0)+") Bars: "+DoubleToStr(previndex-i,0), Time[i], CrossUp[i] - TextShift*Point, TextColourUpArrow);         
      //}
      //else if ((fasterMAnow < slowerMAnow) && (fasterMAprevious > slowerMAprevious) && (fasterMAafter < slowerMAafter)) {
      //   CrossDown[i] = High[i] + Range*0.5;
      //   ZigZag[i] = Close[i];
      //   previndex = FindPrevI(i);
      //   SetText(DoubleToStr(Close[i], Digits)+" ("+DoubleToStr((MathAbs(ZigZag[i]-ZigZag[previndex]))/Point,0)+") Bars: "+DoubleToStr(previndex-i,0), Time[i], CrossDown[i] + TextShift*Point, TextColourDwArrow);         
      //}
      //Last1000(i);
   }
  // limit=ArraySize(ZigZag);
  
   //for(i = n-1; i >= 0; i--) {
   //  // if (ZigZag[i]>0)
   //    {
   //   // n=n+1;
   //  //  ArrayResize(one_dim,n,LastN); 
   //   // one_dim[n-1]=ZigZag[i];
   //    Print("n"+i+"= "+one_dim[i]);
   //    }
   //}
     if (CrossDown[0]==0){
     LastN=LastN+100;
     Alert(WindowExpertName()+" - "+Symbol()+Period()+"M, Не хватает баров на истории. LastN="+LastN);
     }
   return(0);
}

double FindHigh(int currI)
{ double fasterMAnow,f1;
  double y=High[currI];
  for(int i=currI; i<currI+1000; i++)
   { 
     fasterMAnow = iIchimoku(NULL,0,9,FasterMA,52,MODE_KIJUNSEN,i);
     f1 = iIchimoku(NULL,0,9,FasterMA,52,MODE_KIJUNSEN,i+1);
     if (High[i]>y) y=High[i];
     if ((Close[i]>fasterMAnow) && (Close[i+1]<=f1))
       break;
   }
   return(y); 
}

double FindLow(int currI)
{ double fasterMAnow,f1;
  double y=Low[currI];
  for(int i=currI; i<currI+1000; i++)
   { 
     fasterMAnow = iIchimoku(NULL,0,9,FasterMA,52,MODE_KIJUNSEN,i);
     f1 = iIchimoku(NULL,0,9,FasterMA,52,MODE_KIJUNSEN,i+1);
     if (Low[i]<y) y=Low[i];
     if ((Close[i]<fasterMAnow) && (Close[i+1]>=f1))
       break;
   }
   return(y); 
}

int FindPrevI(int currI)
{
   for(int i=currI+1; i<Bars; i++)
      if(ZigZag[i]>0.0) 
   return(i);
}



