//+------------------------------------------------------------------+
//|                                            cxxHorizontalLine.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Controls\Button.mqh>

#define ARRAY_LENGTH(array) (sizeof(array) / sizeof(array[0]))

struct hlButton {
   string name;
   color clr;
};


// =======================================================
//                    数値弄っていい場所
// =======================================================

input int BUTTON_WIDTH        = 34; // ボタンの横幅
input int BUTTON_HEIGHT       = 20; // ボタンの縦幅
input int INDENT_WIDTH_PER    = 20; // 表示位置x%
input int INDENT_HEIGHT_PER   = 2;  // 表示位置y%


// ボタンの色
// hlColor5,6,7 と追加したら
// hlButtonsにも追加すること
input color hlColor1   = clrLightGray;
input color hlColor2   = clrHotPink;
input color hlColor3   = clrGold;
input color hlColor4   = clrSlateBlue;

hlButton hlButtons[] = {
      { "HLine1", hlColor1 },
      { "HLine2", hlColor2 },
      { "HLine3", hlColor3 },
      { "HLine4", hlColor4 }
};

// =======================================================
// =======================================================


int numHL = 0;
int step = 0;


int OnInit() {
   
   int x = int(ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0) * INDENT_WIDTH_PER / 100.f);
   int y = int(ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0) * INDENT_HEIGHT_PER / 100.f);
   
   for (int i = 0; i < ARRAY_LENGTH(hlButtons); i++) {
      MakeButton(hlButtons[i].name, hlButtons[i].clr, x, y);
      x += BUTTON_WIDTH+2;
   }

   ChartSetInteger(0, CHART_EVENT_OBJECT_CREATE,  true);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE,     true);
   ChartRedraw();
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
   for (int i = 0; i < ARRAY_LENGTH(hlButtons); i++) {
      ObjectDelete(0, hlButtons[i].name);
      ObjectFind(0, hlButtons[i].name);
   }
   ChartRedraw();
}

//+------------------------------------------------------------------+

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
  
   return(rates_total);
}

//+------------------------------------------------------------------+

void MakeButton(string name,
                color hlColor,
                int x,
                int y) {
   
   ObjectCreate    (0, name, OBJ_BUTTON , 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, hlColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_RAISED);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);
   ObjectSetString (0, name, OBJPROP_FONT, "Arial");
   ObjectSetString (0, name, OBJPROP_TEXT, name);
}

//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
                  
   if (id == CHARTEVENT_CLICK) {
      if (step == 0) {
         for (int i = 0; i < ARRAY_LENGTH(hlButtons); i++) {
            if (ObjectGetInteger(0, hlButtons[i].name, OBJPROP_STATE)) {
               step = 1;
               return;
            }
         }
         return;
      }
      if (step == 1) {
         for (int i = 0; i < ARRAY_LENGTH(hlButtons); i++) {
            if (ObjectGetInteger(0, hlButtons[i].name, OBJPROP_STATE)) {
         
               int x = (int)lparam;
               int y = (int)dparam;
      
               datetime time;
               double   price;
               int      subwindow;
      
               ChartXYToTimePrice(0, x, y, subwindow, time, price);
            
               string objName = "HolLine" + numHL;
               
               ObjectCreate    (0, objName, OBJ_HLINE, 0, 0, price);
               ObjectSetInteger(0, objName, OBJPROP_COLOR, hlButtons[i].clr);
               ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
               ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
               ObjectSetInteger(0, objName, OBJPROP_BACK, false);
               ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, true);
               ObjectSetInteger(0, objName, OBJPROP_SELECTED, false);
               ObjectSetInteger(0, objName, OBJPROP_HIDDEN, false);
               ObjectSetInteger(0, objName, OBJPROP_ZORDER, 0);
               
               ChartRedraw(0);
               
               step = 0;
               numHL++;
               for (int i = 0; i < ARRAY_LENGTH(hlButtons); i++) {
                  ObjectSetInteger(0, hlButtons[i].name, OBJPROP_STATE, false);
               }
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
