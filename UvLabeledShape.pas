//Author := Irrelevant;
//License := Free;
//Email_for_bug_reports := rebekats@inbox.lv
//Ver 0.9b (12.02.2014)

unit UvLabeledShape;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms, Windows,
  ImgList, Dialogs, StrUtils, Math, Messages;

type

  TShapePoints = array of TPoint;

  EUvSubLabelListError = class(Exception);

  TUvSubLabelListItem = class;
  TUvSubLabelList = class;
  TUvLabeledShape = class;

  TUvSubLabelList = class(TCollection)
  private
    FOwner: TPersistent;
  protected
    function GetOwner: TPersistent; override;
    function GetFieldInfo(Index: Integer): TUvSubLabelListItem;
    procedure SetFieldInfo(Index: Integer; Value: TUvSubLabelListItem);
    function GetItemsByName(Index: UnicodeString): TUvSubLabelListItem;
    procedure SetItemsByName(Index: UnicodeString; Value: TUvSubLabelListItem);
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
    function Add: TUvSubLabelListItem;
    function Insert(Index: Integer): TUvSubLabelListItem;
    function Owner: TPersistent;
    function GetIndexByName(Name: UnicodeString): Integer;
    property Items[Index: Integer]: TUvSubLabelListItem read GetFieldInfo write SetFieldInfo; default;
    property ItemsByName[Index: UnicodeString]: TUvSubLabelListItem read GetItemsByName write SetItemsByName;
  end;

  TUvSubLabelListItem = class(TCollectionItem)
  private
    FTag: Integer;
    FName: UnicodeString;
    FFont: TFont;
    FParentFont: Boolean;
    FCaption: UnicodeString;
    FCaptionLeft: Integer;
    FCaptionTop: Integer;
    FCaptionMultiLine: Boolean;
    FCaptionLines: TStrings;
    FCaptionImageIndex: TImageIndex;
    FCaptionVisible: Boolean;
    procedure LinesChange(Sender: TObject);
    procedure FontChange(Sender: TObject);
    function DoWeSaveFont: Boolean;
//    function GetParent: TUvLabeledShape;
  protected
    function GetDisplayName: string; override;
    procedure SetFont(Value: TFont);
    procedure SetParentFont(Value: Boolean);
    //-----------------------
    procedure SetCaption(Value: UnicodeString);
    procedure SetCaptionLeft(Value: Integer);
    procedure SetCaptionTop(Value: Integer);
    procedure SetCaptionMultiLine(Value: Boolean);
    procedure SetCaptionLines(Value: TStrings);
    procedure SetCaptionImageIndex(Value: TImageIndex);
    procedure SetCaptionVisible(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Invalidate;
  published
    property Tag: Integer read FTag write FTag;
    //-----------------------
    property Name: UnicodeString read FName write FName;
    //-----------------------
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property Font: TFont read FFont write SetFont;// stored DoWeSaveFont; //No rotation on centered or multiline text
    //-----------------------
    property Caption: UnicodeString read FCaption write SetCaption;
    property CaptionLeft: Integer read FCaptionLeft write SetCaptionLeft default -1; //-1 = centered
    property CaptionTop: Integer read FCaptionTop write SetCaptionTop default -1; //-1 = centered
    property CaptionMultiLine: Boolean read FCaptionMultiLine write SetCaptionMultiLine default False; //Use CaptionLines ignore Caption
    property CaptionLines: TStrings read FCaptionLines write SetCaptionLines;
    property CaptionImageIndex: TImageIndex read FCaptionImageIndex write SetCaptionImageIndex default -1; //Use image ignore text
    property CaptionVisible: Boolean read FCaptionVisible write SetCaptionVisible default True; //Show or hide
  end;

  TUvLabeledShape = class(TShape)
  private
    FBrushColor: TColor;
    FBorder: TPen;
    FBackground: TBrush;
//    FFont: TFont;
    FCaption: UnicodeString;
    FCaptionLeft: Integer;
    FCaptionTop: Integer;
    FCaptionMultiLine: Boolean;
    FCaptionLines: TStrings;
    FCustomLabels: TUvSubLabelList;
    FCaptionImageIndex: TImageIndex;
    FCaptionImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FCaptionVisible: Boolean;
    FCustomLabelsVisible: Boolean;
    FCustomShapeVisible: Boolean;
    FCustomShape: TStrings;
    FCustomShapePoints: TShapePoints;//array of TPoint;
    procedure VisualsChange(Sender: TObject);
//    procedure FontChange(Sender: TObject);
    procedure VisualsChangePlus(Sender: TObject);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Paint; override;
    procedure SetBorder(Value: TPen);
    procedure SetBackground(Value: TBrush);
//    procedure SetFont(Value: TFont);
    procedure SetCaption(Value: UnicodeString);
    procedure SetCaptionLeft(Value: Integer);
    procedure SetCaptionTop(Value: Integer);
    procedure SetCaptionMultiLine(Value: Boolean);
    procedure SetCaptionLines(Value: TStrings);
    procedure SetCustomLabels(Value: TUvSubLabelList);
    procedure SetCaptionImages(Value: TCustomImageList);
    procedure SetCaptionVisible(Value: Boolean);
    procedure SetCustomLabelsVisible(Value: Boolean);
    procedure SetCustomShape(Value: TStrings);
    procedure SetCustomShapeVisible(Value: Boolean);
    procedure SetCaptionImageIndex(Value: TImageIndex);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ParseCustomShape(ACustomShape: TStrings; var ACustomShapePoints: TShapePoints);
    procedure MouseEnter(var Msg : TMessage); Message cm_mouseEnter;
    Procedure MouseLeave (Var MSG: TMessage); Message cm_mouseLeave;
  published
    property Font; //No rotation on centered or multiline text
    property ParentFont;
    property OnClick;
    property OnDblClick;
    //-----------------------
    property Border: TPen read FBorder write SetBorder;
    property Background: TBrush read FBackground write SetBackground;
//    property Font read FFont write SetFont stored True;
    //-----------------------
    property Caption: UnicodeString read FCaption write SetCaption;
    property CaptionLeft: Integer read FCaptionLeft write SetCaptionLeft default -1; //-1 = centered
    property CaptionTop: Integer read FCaptionTop write SetCaptionTop default -1; //-1 = centered
    property CaptionMultiLine: Boolean read FCaptionMultiLine write SetCaptionMultiLine default False; //Use CaptionLines ignore Caption
    property CaptionLines: TStrings read FCaptionLines write SetCaptionLines;
    property CaptionImages: TCustomImageList read FCaptionImages write SetCaptionImages; //Image list for images
    property CaptionImageIndex: TImageIndex read FCaptionImageIndex write SetCaptionImageIndex default -1; //Use image ignore text, need to property editor, next version maybe
    property CaptionVisible: Boolean read FCaptionVisible write SetCaptionVisible default True; //Show or hide
    //-----------------------
    property CustomLabels: TUvSubLabelList read FCustomLabels write SetCustomLabels; //Collection of additional labels
    property CustomLabelsVisible: Boolean read FCustomLabelsVisible write SetCustomLabelsVisible default True; //Show or hide
    //-----------------------
    property CustomShape: TStrings read FCustomShape write SetCustomShape; //List of value pairs x.xxx;y.yyyy/last is shape size, minimum 4 enteries
    property CustomShapeVisible: Boolean read FCustomShapeVisible write SetCustomShapeVisible default False; //Show or hide
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('mGS', [TUvLabeledShape]);
//  RegisterPropertyEditor(TypeInfo(TImageIndex), TUvSubLabelListItem, 'ImageIndex', TComponentImageIndexPropertyEditor);
end;

{$region 'TUvSubLabelList'}
//=================================================================================================
//
//  TUvSubLabelList
//
//=================================================================================================

constructor TUvSubLabelList.Create(AOwner: TPersistent); begin inherited Create(TUvSubLabelListItem); FOwner := AOwner; end;
destructor TUvSubLabelList.Destroy; begin inherited Destroy; end;
function TUvSubLabelList.Owner: TPersistent; begin Result := FOwner; end;
function TUvSubLabelList.GetOwner: TPersistent; begin Result := FOwner; end;
function TUvSubLabelList.Add: TUvSubLabelListItem; begin Result := TUvSubLabelListItem(inherited Add); end;
function TUvSubLabelList.Insert(Index: Integer): TUvSubLabelListItem; begin Result := TUvSubLabelListItem(inherited Insert(Index)); end;
function TUvSubLabelList.GetFieldInfo(Index: Integer): TUvSubLabelListItem; begin Result := TUvSubLabelListItem(inherited GetItem(Index)); end;
procedure TUvSubLabelList.SetFieldInfo(Index: Integer; Value: TUvSubLabelListItem); begin inherited SetItem(Index, Value); end;
function TUvSubLabelList.GetItemsByName(Index: UnicodeString): TUvSubLabelListItem; begin Result := GetFieldInfo(GetIndexByName(Index)); end;
procedure TUvSubLabelList.SetItemsByName(Index: UnicodeString; Value: TUvSubLabelListItem); begin SetFieldInfo(GetIndexByName(Index), Value); end;

function TUvSubLabelList.GetIndexByName(Name: UnicodeString): Integer;
var Index: integer;
begin
  for Index := 0 to Count - 1 do if UpperCase(Items[Index].FName) = UpperCase(Name) then Exit(Index);
  raise EUvSubLabelListError.Create('Name ' + Name + ' not found in list of sub labels.');
end;
{$endregion}

{$region 'TUvSubLabelListItem'}
//=================================================================================================
//
//  TUvSubLabelListItem
//
//=================================================================================================

constructor TUvSubLabelListItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTag := 0;
  FName := 'SubLabel' + IntToStr(ID);
  FFont := TFont.Create;
  SetParentFont(True);
  if FFont.Orientation <> 0 then begin
    FFont.Orientation := 0;
    FParentFont := False;
  end;
  FFont.OnChange := FontChange;
  FCaption := '';
  FCaptionLeft := -1;
  FCaptionTop := -1;
  FCaptionMultiLine := False;
  FCaptionLines := TStringList.Create;
  TStringList(FCaptionLines).OnChange := LinesChange;
  FCaptionImageIndex := -1;
  FCaptionVisible := True;
end;

destructor TUvSubLabelListItem.Destroy;
begin
  FreeAndNil(FCaptionLines);
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TUvSubLabelListItem.Assign(Source: TPersistent);
var tmp: TUvSubLabelListItem;
begin
  if Source is TUvSubLabelListItem then begin
    tmp := TUvSubLabelListItem(Source);
    //-----------------
    FTag := tmp.FTag;
    FName := tmp.FName;
    FFont.Assign(tmp.Font);
    FParentFont := tmp.FParentFont;
    FCaption := tmp.FCaption;
    FCaptionLeft := tmp.FCaptionLeft;
    FCaptionTop := tmp.FCaptionTop;
    FCaptionMultiLine := tmp.FCaptionMultiLine;
    FCaptionLines.Assign(tmp.FCaptionLines);
    //TStringList(FText).OnChange := TextChange;
    FCaptionImageIndex := tmp.FCaptionImageIndex;
    FCaptionVisible := tmp.FCaptionVisible;
  end else inherited Assign(Source);
end;

procedure TUvSubLabelListItem.Invalidate;
begin
  if Self.Collection = nil then Exit;
  if Self.Collection.Owner = nil then Exit;
  if Self.Collection.Owner.ClassType <> TUvLabeledShape then Exit; //Error with descendants ???
  TUvLabeledShape(Self.Collection.Owner).Invalidate;
end;

procedure TUvSubLabelListItem.SetParentFont(Value: Boolean);
begin
  if Value then begin
    if Self.Collection = nil then Exit;
    if Self.Collection.Owner = nil then Exit;
    if Self.Collection.Owner.ClassType <> TUvLabeledShape then Exit; //Error with descendants ???
    FFont.Assign(TUvLabeledShape(Self.Collection.Owner).Font);
    FParentFont := True;
  end else begin
    FParentFont := False;
  end;
end;

//function TUvSubLabelListItem.GetParent: TUvLabeledShape;
//begin
//  Result := nil;
//  if Self.Collection = nil then Exit;
//  if Self.Collection.Owner = nil then Exit;
//  if Self.Collection.Owner.ClassType <> TUvLabeledShape then Exit; //Error with descendants ???
//  Result := TUvLabeledShape(Self.Collection.Owner);
//end;
//-------------------------------------------------------------------------------------------------

function TUvSubLabelListItem.GetDisplayName: string; begin Result := Name; if Result = '' then Result := 'NoName' + IntToStr(ID); end;
procedure TUvSubLabelListItem.LinesChange(Sender: TObject); begin Invalidate; end;
procedure TUvSubLabelListItem.FontChange(Sender: TObject); begin FParentFont := False; Invalidate; end;
function TUvSubLabelListItem.DoWeSaveFont; begin Exit(not FParentFont); end;

procedure TUvSubLabelListItem.SetFont(Value: TFont); begin FFont.Assign(Value); FParentFont := False; Invalidate; end;
procedure TUvSubLabelListItem.SetCaptionLines(Value: TStrings); begin FCaptionLines.Assign(Value); Invalidate; end;

procedure TUvSubLabelListItem.SetCaptionMultiLine(Value: Boolean); begin if FCaptionMultiLine <> Value then begin FCaptionMultiLine := Value; Invalidate; end; end;
procedure TUvSubLabelListItem.SetCaption(Value: UnicodeString); begin if FCaption <> Value then begin FCaption := Value; Invalidate; end; end;
procedure TUvSubLabelListItem.SetCaptionLeft(Value: Integer); begin if FCaptionLeft <> Value then begin FCaptionLeft := Value; Invalidate; end; end;
procedure TUvSubLabelListItem.SetCaptionTop(Value: Integer); begin if FCaptionTop <> Value then begin FCaptionTop := Value; Invalidate; end; end;
procedure TUvSubLabelListItem.SetCaptionImageIndex(Value: TImageIndex); begin if FCaptionImageIndex <> Value then begin FCaptionImageIndex := Value; Invalidate; end; end;
procedure TUvSubLabelListItem.SetCaptionVisible(Value: Boolean); begin if FCaptionVisible <> Value then begin FCaptionVisible := Value; Invalidate; end; end;

{$endregion}

{$region 'TUvLabeledShape'}
//=================================================================================================
//
//  TUvLabeledShape
//
//=================================================================================================

constructor TUvLabeledShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //-------------------------
  Self.OnResize := VisualsChangePlus;
  //-------------------------
  FBorder := TPen.Create;
  FBorder.OnChange := VisualsChange;
  FBorder.Style := psClear;
  //-------------------------
  FBackground := TBrush.Create;
  FBackground.OnChange := VisualsChange;
  FBackground.Style := bsClear;
  //-------------------------
//  FFont := TFont.Create;
//  FFont.OnChange := FontChange;
  //Parent font  ? ? ?
  //-------------------------
  FCaptionLines := TStringList.Create;
  TStringList(FCaptionLines).OnChange := VisualsChange;
  //-------------------------
  FCustomShape := TStringList.Create;
  TStringList(FCustomShape).OnChange := VisualsChangePlus;
  //-------------------------
  FCustomLabels := TUvSubLabelList.Create(Self);
  //-------------------------
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := VisualsChange;
  //-------------------------
  FCaption := '';
  FCaptionLeft := -1;
  FCaptionTop := -1;
  FCaptionMultiLine := False;
  FCaptionImages := nil;
  FCaptionImageIndex := -1;
  FCaptionVisible := True;
  FCustomLabelsVisible := True;
  FCustomShapeVisible := False;
end;

destructor TUvLabeledShape.Destroy;
begin
  FreeAndNil(FBorder);
  FreeAndNil(FBackground);
//  FreeAndNil(FFont);
  FreeAndNil(FCaptionLines);
  FreeAndNil(FCustomShape);
  FreeAndNil(FCustomLabels);
  FreeAndNil(FImageChangeLink);
  inherited Destroy;
end;

procedure TUvLabeledShape.MouseEnter(var Msg: TMessage);
begin
  FBrushColor := Brush.Color;
  Brush.Color := Pen.Color;
  Font.Color  := FBrushColor;
end;

procedure TUvLabeledShape.MouseLeave(var MSG: TMessage);
begin
  Font.Color  := Pen.Color;
  Brush.Color := FBrushColor;
end;

//-------------------------------------------------------------------------------------------------

procedure TUvLabeledShape.VisualsChange(Sender: TObject); begin Invalidate; end;
procedure TUvLabeledShape.VisualsChangePlus(Sender: TObject); begin ParseCustomShape(FCustomShape, FCustomShapePoints); Invalidate; end;

procedure TUvLabeledShape.SetBorder(Value: TPen); begin FBorder.Assign(Value); Invalidate; end;
procedure TUvLabeledShape.SetBackground(Value: TBrush); begin FBackground.Assign(Value); Invalidate; end;
//procedure TUvLabeledShape.SetFont(Value: TFont); begin FFont.Assign(Value); Invalidate; end;
procedure TUvLabeledShape.SetCaptionLines(Value: TStrings); begin FCaptionLines.Assign(Value); Invalidate; end;
procedure TUvLabeledShape.SetCustomLabels(Value: TUvSubLabelList); begin FCustomLabels.Assign(Value); Invalidate; end;
procedure TUvLabeledShape.SetCustomShape(Value: TStrings); begin FCustomShape.Assign(Value); ParseCustomShape(FCustomShape, FCustomShapePoints); Invalidate; end;

procedure TUvLabeledShape.SetCaption(Value: UnicodeString); begin if FCaption <> Value then begin FCaption := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCaptionMultiLine(Value: Boolean); begin if FCaptionMultiLine <> Value then begin FCaptionMultiLine := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCaptionLeft(Value: Integer); begin if FCaptionLeft <> Value then begin FCaptionLeft := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCaptionTop(Value: Integer); begin if FCaptionTop <> Value then begin FCaptionTop := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCaptionVisible(Value: Boolean); begin if FCaptionVisible <> Value then begin FCaptionVisible := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCustomLabelsVisible(Value: Boolean); begin if FCustomLabelsVisible <> Value then begin FCustomLabelsVisible := Value; Invalidate; end; end;
procedure TUvLabeledShape.SetCaptionImageIndex(Value: TImageIndex); begin if FCaptionImageIndex <> Value then begin FCaptionImageIndex := Value; Invalidate; end; end;

//-------------------------------------------------------------------------------------------------

procedure TUvLabeledShape.SetCustomShapeVisible(Value: Boolean);
begin
  if FCustomShapeVisible <> Value then begin
    FCustomShapeVisible := Value;
    if FCustomShapeVisible then ParseCustomShape(FCustomShape, FCustomShapePoints);
    Invalidate;
  end;
end;

procedure TUvLabeledShape.SetCaptionImages(Value: TCustomImageList);
begin
  if FCaptionImages <> nil then FCaptionImages.UnRegisterChanges(FImageChangeLink);
  FCaptionImages := Value;
  if FCaptionImages <> nil then begin
    FCaptionImages.RegisterChanges(FImageChangeLink);
    FCaptionImages.FreeNotification(Self);
  end;
  Invalidate;
end;

procedure TUvLabeledShape.CMFontChanged(var Message: TMessage);
var q: Integer;
begin
  inherited;
  for q := 0 to FCustomLabels.Count - 1 do
    if FCustomLabels[q].FParentFont then begin
      FCustomLabels[q].FFont.Assign(Self.Font);
      FCustomLabels[q].FParentFont := True;
    end;
  Invalidate;
end;

//-------------------------------------------------------------------------------------------------

procedure TUvLabeledShape.ParseCustomShape(ACustomShape: TStrings; var ACustomShapePoints: TShapePoints); //Data format x.xxx;y.yyy
var q, DivPosition, StringCount, CurrentPoint: Integer;
    a, xx, yy: UnicodeString;
    bx, by, x, y: Double;
    mx, my: Integer;
    tmp_event: TNotifyEvent;
begin //Decimal seperator ! ! !
  if not FCustomShapeVisible then Exit;
  // if csDesigning in ComponentState then Exit;
  //---------
  tmp_event := TStringList(ACustomShape).OnChange;
  TStringList(ACustomShape).OnChange := nil;
  //---------
  bx := 100;
  by := 100;
  mx := Self.Width - Self.Pen.Width + 1;
  my := Self.Height - Self.Pen.Width + 1;
  CurrentPoint := -1;
  StringCount := ACustomShape.Count;
  SetLength(ACustomShapePoints, StringCount);
  for q := StringCount - 1 downto 0 do begin
    a := StringReplace(ACustomShape[q], ',', '.', [rfIgnoreCase, rfReplaceAll]);
    xx := '';
    yy := '';
    DivPosition := Pos(';', a);
    xx := Copy(a, 1, DivPosition - 1);
    yy := Copy(a, DivPosition + 1);
    x := StrToFloatDef(xx, -1);
    y := StrToFloatDef(yy, -1);
    if (x < 0) or (y < 0) then begin
      ACustomShape.Delete(q);
      Continue;
    end;
    ACustomShape[q] := FloatToStr(x) + ';' + FloatToStr(y);
    if CurrentPoint = -1 then begin
      bx := x; if bx < 1 then bx := 100;
      by := y; if by < 1 then by := 100;
    end else begin
      ACustomShapePoints[CurrentPoint].X := Round((mx * x) / bx) + (Self.Pen.Width div 2);
      ACustomShapePoints[CurrentPoint].Y := Round((my * y) / by) + (Self.Pen.Width div 2);
    end;
    Inc(CurrentPoint);
  end;
  SetLength(ACustomShapePoints, Max(CurrentPoint, 0));
  //---------
  TStringList(ACustomShape).OnChange := tmp_event;
end;

procedure TUvLabeledShape.Paint;
var q: Integer;
    sl: TUvSubLabelListItem;

  procedure DrawLabelShape;
  var hp: Integer;
  begin
    if (FBorder.Style <> psClear) or (FBackground.Style <> bsClear) then begin
      hp := Self.Pen.Width div 2;
      Canvas.Pen := FBorder;
      Canvas.Brush := FBackground;
      Canvas.Rectangle(hp, hp, Self.Width - hp + 1, Self.Height - hp + 1);
    end;
    if FCustomShapeVisible then begin
      if Length(FCustomShapePoints) > 2 then begin
        Canvas.Pen := Self.Pen;
        Canvas.Brush := Self.Brush;
        Canvas.Polygon(FCustomShapePoints);
      end;
    end else inherited Paint;
  end;

  procedure DrawLabelText(ALeft, ATop: Integer; AFont: TFont; AText: UnicodeString; ALines: TStrings; ML: Boolean); //Centering and multiline disables text rotation
  var TextRec, TextRecSize: TRect;
      TextOpt: Cardinal;
  begin
    if not ML and (Trim(AText) = '') then Exit;
    if ML and (Trim(ALines.Text) = '') then Exit;
    Canvas.Font := AFont;
    Canvas.Brush.Style := bsClear;
    if ML or (ALeft < 0) or (ATop < 0) then begin //Centered or multiline output
      Canvas.Font.Orientation := 0;
      TextRec := Rect(Max(0, ALeft), Max(0, ATop), Self.Width, Self.Height);
      if ML then begin
        TextOpt := DT_WORDBREAK + DT_NOPREFIX;
        if ALeft < 0 then TextOpt := TextOpt + DT_CENTER else TextOpt := TextOpt + DT_LEFT;
        if ATop < 0 then begin
          TextRecSize := TextRec;
          DrawText(Canvas.Handle, PChar(ALines.Text), Length(ALines.Text), TextRecSize, TextOpt + DT_CALCRECT);
          TextRec.Top := TextRec.Top + (((TextRec.Bottom - TextRec.Top) - TextRecSize.Bottom) div 2); //Need testing ! ! !
        end;
        DrawText(Canvas.Handle, PChar(ALines.Text), Length(ALines.Text), TextRec, TextOpt);
      end else begin
        TextOpt := DT_SINGLELINE + DT_NOPREFIX + DT_END_ELLIPSIS;
        if ALeft < 0 then TextOpt := TextOpt + DT_CENTER else TextOpt := TextOpt + DT_LEFT;
        if ATop < 0 then TextOpt := TextOpt + DT_VCENTER else TextOpt := TextOpt + DT_TOP;
        DrawText(Canvas.Handle, PChar(AText), Length(AText), TextRec, TextOpt);
      end;
    end else Canvas.TextOut(ALeft, ATop, AText); //Single line output
    //RotatedWidth := Ceil(cx*Cos(Angle)+cy*Sin(Angle));
    //RotatedHeight := Ceil(cx*Sin(Angle)+cy*Cos(Angle)); Angle = rad : Pi/180
  end;

  procedure DrawLabelImage(ALeft, ATop, AIndex: Integer);
  var x, y: Integer;
  begin
    if (FCaptionImages = nil) or (FCaptionImages.Count <= sl.CaptionImageIndex) then Exit;
    x := ALeft;
    y := ATop;
    if x < 0 then x := (Self.Width - FCaptionImages.Width) div 2;
    if y < 0 then y := (Self.Height - FCaptionImages.Height) div 2;
    FCaptionImages.Draw(Self.Canvas, x, y, AIndex);
  end;

begin
  DrawLabelShape;
  //-------------------------
  if FCaptionVisible then
    if FCaptionImageIndex < 0 then
      DrawLabelText(FCaptionLeft, FCaptionTop, Self.Font, FCaption, FCaptionLines, FCaptionMultiLine)
    else
      DrawLabelImage(FCaptionLeft, FCaptionTop, FCaptionImageIndex);
  //-------------------------
  if CustomLabelsVisible then
    for q := 0 to FCustomLabels.Count - 1 do begin
      sl := FCustomLabels[q];
      if not sl.CaptionVisible then Continue;
      if sl.CaptionImageIndex < 0 then
        DrawLabelText(sl.FCaptionLeft, sl.FCaptionTop, sl.Font, sl.FCaption, sl.FCaptionLines, sl.FCaptionMultiLine)
      else
        DrawLabelImage(sl.FCaptionLeft, sl.FCaptionTop, sl.FCaptionImageIndex);
    end;
  //-------------------------
end;
{$endregion}

end.

