unit Main;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ComCtrls, ToolWin, Menus, ExtCtrls, StdCtrls, ImgList;

const
	SleepTime = 400;
	clChessboard = $0000C0C0;
	clClockBorder = $000000C0;

type
	TChessman = (cmNone, cmBlack, cmWhite, cmBorder);
	TBackgroundMode = (bkTile, bkCenter, bkStretch);
	TBackgroundType = (bkNone, bkDefault, bkUserDefine);
	TChessboard = array[-1..8, -1..8] of TChessman;
	TDropChessboard = array[0..7, 0..7] of Integer;
	TGameTime = array[TChessman] of Integer;
	TInput = (idMouse, idDirection, idLetter, idComputer);
	TInputDevice = array[TChessman] of TInput;
	TLevel = array[TChessman] of Integer;
	TPlayerName = array[TChessman] of WideString;
	TShowHintPart = set of (shTool, shStatus, shTitle, shName, shClock);
	TShowPart = set of (spTool, spStatus, spTitle, spName, spClock, spRowCol);
	TMainForm = class(TForm)
		CoolBar: TCoolBar;
		ImageBlackClock: TImage;
		ImageBlackName: TImage;
		ImageListTool: TImageList;
		ImageListToolHot: TImageList;
		ImageListToolDisabled: TImageList;
		ImageTitle: TImage;
		ImageWhiteClock: TImage;
		ImageWhiteName: TImage;
		MainMenu: TMainMenu;
		MenuFile: TMenuItem;
		MenuFileAbout: TMenuItem;
		MenuFileExit: TMenuItem;
		MenuFileNew: TMenuItem;
		MenuFileOption: TMenuItem;
		MenuFileSeparator1: TMenuItem;
		MenuFileSeparator2: TMenuItem;
		MenuFileStopGame: TMenuItem;
		MenuView: TMenuItem;
		MenuViewClock: TMenuItem;
		MenuViewHistory: TMenuItem;
		MenuViewName: TMenuItem;
		MenuViewTool: TMenuItem;
		MenuViewSeparator1: TMenuItem;
		MenuViewStatus: TMenuItem;
		MenuViewTitle: TMenuItem;
		PaintBoxBackground: TPaintBox;
		PaintBoxChessboard: TPaintBox;
		PopupClock: TPopupMenu;
		PopupClockChangeTime: TMenuItem;
		PopupClockHide: TMenuItem;
		PopupClockSeparator1: TMenuItem;
		PopupClockSeparator2: TMenuItem;
		PopupClockShowHint: TMenuItem;
		PopupName: TPopupMenu;
		PopupNameChangeName: TMenuItem;
		PopupNameFont: TMenuItem;
		PopupNameHide: TMenuItem;
		PopupNameSeparator1: TMenuItem;
		PopupNameSeparator2: TMenuItem;
		PopupNameShowHint: TMenuItem;
		PopupStatus: TPopupMenu;
		PopupStatusHide: TMenuItem;
		PopupStatusSeparator1: TMenuItem;
		PopupStatusShowHint: TMenuItem;
		PopupTitle: TPopupMenu;
		PopupTitleAbout: TMenuItem;
		PopupTitleFont: TMenuItem;
		PopupTitleHide: TMenuItem;
		PopupTitleSeparator1: TMenuItem;
		PopupTitleSeparator2: TMenuItem;
		PopupTitleShowHint: TMenuItem;
		PopupTool: TPopupMenu;
		PopupToolHide: TMenuItem;
		PopupToolSeparator1: TMenuItem;
		PopupToolShowHint: TMenuItem;
		TimerClock: TTimer;
		TimerComputerMove: TTimer;
		ToolBar: TToolBar;
		ToolButtonExit: TToolButton;
		ToolButtonHistory: TToolButton;
		ToolButtonNew: TToolButton;
		ToolButtonOption: TToolButton;
		ToolButtonSeparator1: TToolButton;
		ScrollBox: TScrollBox;
		StatusBar: TStatusBar;
		procedure ShowHint(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure ExitGame(Sender: TObject);
		procedure ScrollBoxResize(Sender: TObject);
		procedure ShowAboutBox(Sender: TObject);
		procedure GetPlayerName(Sender: TObject);
		procedure GetTimeLimit(Sender: TObject);
		procedure PaintBoxBackgroundPaint(Sender: TObject);
		procedure ShowOptionBox(Sender: TObject);
		procedure MenuViewToolClick(Sender: TObject);
		procedure PopupToolHideClick(Sender: TObject);
		procedure PopupToolShowHintClick(Sender: TObject);
		procedure MenuViewStatusClick(Sender: TObject);
		procedure PopupStatusHideClick(Sender: TObject);
		procedure PopupStatusShowHintClick(Sender: TObject);
		procedure MenuViewTitleClick(Sender: TObject);
		procedure PopupTitleHideClick(Sender: TObject);
		procedure PopupTitleShowHintClick(Sender: TObject);
		procedure MenuViewNameClick(Sender: TObject);
		procedure PopupNameHideClick(Sender: TObject);
		procedure PopupNameShowHintClick(Sender: TObject);
		procedure MenuViewClockClick(Sender: TObject);
		procedure PopupClockHideClick(Sender: TObject);
		procedure PopupClockShowHintClick(Sender: TObject);
		procedure PaintBoxBackgroundDblClick(Sender: TObject);
		procedure ChangeFont(Sender: TObject);
		procedure NewGame(Sender: TObject);
		procedure PaintBoxChessboardPaint(Sender: TObject);
		procedure PaintBoxChessboardMouseDown(Sender: TObject;
			Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure TimerClockTimer(Sender: TObject);
		procedure Delay(DelayTime: Integer);
		procedure FormKeyDown(Sender: TObject; var Key: Word;
			Shift: TShiftState);
		procedure FormDestroy(Sender: TObject);
		procedure MenuFileStopGameClick(Sender: TObject);
		procedure ToolButtonHistoryClick(Sender: TObject);
		procedure MenuViewHistoryClick(Sender: TObject);
		procedure TimerComputerMoveTimer(Sender: TObject);
	private
		{ Private declarations }
		GameTime: TGameTime;
		PlayingFlag: Boolean;
		DoEventsFlag: Boolean;
		MessageFlag: Boolean;
		Chessboard: TChessboard;
		ChessboardImage: TBitmap;
		KeyboardX: Integer;
		KeyboardY: Integer;
		IsExistKeyboardCursor: Boolean;
		function ComputerMove(MaxDepth: Integer): TPoint;
		procedure DrawBorder(W, H: Integer; DrawCanvas: TCanvas);
		function Value(X, Y: Integer): Integer;
		procedure StartGame;
		procedure CloseGame;
		procedure DrawChessman(X, Y: Integer);
		procedure DropChessman(X, Y: Integer);
		procedure ReverseChessman(X, Y: Integer);
		function CanDrop(X, Y: Integer; Chessman: TChessman): Integer;
		function InverseChessman(Chessman: TChessman): TChessman;
		procedure FinishGame;
		procedure DrawTimer(TimerImage: TImage; CurTime: Integer);
		procedure DrawKeyboardCursor(X, Y: Integer);
		procedure SaveHistory(WinPlayer: TChessman; BlackCount, WhiteCount: Integer);
		procedure ShowHistory;
		procedure WMWinIniChange(var Msg: TWMWinIniChange); message WM_WININICHANGE;
	public
		{ Public declarations }
		PlayerGo: TChessman;
		BackgroundType: TBackgroundType;
		BackgroundBitmap: string;
		BackgroundMode: TBackgroundMode;
		ShowPart: TShowPart;
		ShowHintPart: TShowHintPart;
		TitleFont: string;
		NameFont: string;
		PlayerName: TPlayerName;
		InputDevice: TInputDevice;
		Level: TLevel;
		TimeLimit: Integer;
		procedure DoEvents;
		procedure LoadSetting;
		procedure SaveSetting;
		procedure UpdateSetting;
		procedure DrawChessboard;
		procedure DrawTitle;
		procedure DrawName;
		procedure DrawClock;
		procedure UpdateChessboard;
		procedure UpdateTool;
		procedure UpdateStatus;
		procedure UpdateTitle;
		procedure UpdateName;
		procedure UpdateClock;
	end;

var
	MainForm: TMainForm;
	Direction: array[0..7] of TPoint;

implementation

uses
	Registry, About, Option, History, Search;

{$R *.DFM}
{$R RESOURCE.RES}

procedure TMainForm.ShowHint(Sender: TObject);
begin
	if Length(Application.Hint) > 0 then
	begin
		StatusBar.SimplePanel := True;
		StatusBar.SimpleText := Application.Hint
	end
	else
	begin
		StatusBar.SimplePanel := False
	end;
	StatusBar.Repaint
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
	I: Integer;
begin
	Application.MessageBox('警告：本版本为本软件的测试版，某些部分尚未完成，详见“关于黑白棋”。', '黑白棋', MB_OK or MB_ICONINFORMATION);
	Randomize;
	Application.OnHint := ShowHint;
	FillChar(Chessboard, SizeOf(Chessboard), 0);
	for I := -1 to 8 do
	begin
		Chessboard[I, -1] := cmBorder;
		Chessboard[I, 8] := cmBorder;
		Chessboard[-1, I] := cmBorder;
		Chessboard[8, I] := cmBorder
	end;
	Direction[0].X := 1;
	Direction[0].Y := 0;
	Direction[1].X := 1;
	Direction[1].Y := 1;
	Direction[2].X := 0;
	Direction[2].Y := 1;
	Direction[3].X := -1;
	Direction[3].Y := 1;
	Direction[4].X := -1;
	Direction[4].Y := 0;
	Direction[5].X := -1;
	Direction[5].Y := -1;
	Direction[6].X := 0;
	Direction[6].Y := -1;
	Direction[7].X := 1;
	Direction[7].Y := -1;
	PlayingFlag := False;
	DoEventsFlag := False;
	MessageFlag := False;
	ChessboardImage := TBitmap.Create;
	ChessboardImage.Width := 232;
	ChessboardImage.Height := 232;
	LoadSetting;
	UpdateSetting;
	UpdateChessboard;
	DrawChessboard;
	DrawTitle;
	DrawName;
	DrawClock;
	DrawTimer(ImageBlackClock, 0);
	DrawTimer(ImageWhiteClock, 0)
end;

procedure TMainForm.ExitGame(Sender: TObject);
begin
	Close
end;

procedure TMainForm.ScrollBoxResize(Sender: TObject);
begin
	UpdateChessboard
end;

procedure TMainForm.ShowAboutBox(Sender: TObject);
var
	TimerFlag: Boolean;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	AboutBox := TAboutBox.Create(Self);
	AboutBox.ShowModal;
	AboutBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.GetPlayerName(Sender: TObject);
var
	TimerFlag: Boolean;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.PageControl.ActivePage := OptionBox.TabSheetGame;
	OptionBox.PageControl.Pages[0].TabVisible := False;
	OptionBox.GroupBoxTime.Enabled := False;
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.GetTimeLimit(Sender: TObject);
var
	LastFlag, TimerFlag: Boolean;
begin
	if PlayingFlag then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox('不能在比赛中更改时间限制。', '黑白棋', MB_OK);
		DoEventsFlag := LastFlag;
		Exit
	end;
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.PageControl.ActivePage := OptionBox.TabSheetGame;
	OptionBox.PageControl.Pages[0].TabVisible := False;
	OptionBox.GroupBoxBlack.Enabled := False;
	OptionBox.GroupBoxWhite.Enabled := False;
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.PaintBoxBackgroundPaint(Sender: TObject);
var
	I, BitmapWidth: Integer;
	Rect: TRect;
	Image: TBitmap;
begin
	if (BackgroundType = bkNone) or ((BackgroundType = bkUserDefine) and (BackgroundBitmap = '')) then Exit;
	Image := TBitmap.Create;
	try
		case BackgroundType of
			bkDefault: Image.LoadFromResourceName(HInstance, 'Circles');
			bkUserDefine: Image.LoadFromFile(BackgroundBitmap)
		end
	except
		Image.Canvas.Font.Name := '宋体';
		Image.Canvas.Font.Height := -64;
		Image.Width := Image.Canvas.TextWidth('错误：背景图片无效。');
		Image.Height := Image.Canvas.TextHeight('错误：背景图片无效。');
		Rect.Left := 0;
		Rect.Top := 0;
		Rect.Right := Image.Width;
		Rect.Bottom := Image.Height;
		Image.Canvas.Brush.Color := ScrollBox.Color;
		Image.Canvas.FillRect(Rect);
		Image.Canvas.TextOut(0, 0, '错误：背景图片无效。')
	end;
	case BackgroundMode of
		bkTile:
		begin
			BitmapWidth := Image.Width;
			Image.Width := PaintBoxBackground.Width;
			for I := 1 to (Image.Width - 1) div BitmapWidth do
				Image.Canvas.Draw(I * BitmapWidth, 0, Image);
			for I := (PaintBoxBackground.Height - 1) div Image.Height downto 0 do
				PaintBoxBackground.Canvas.Draw(0, I * Image.Height, Image)
		end;
		bkCenter: PaintBoxBackground.Canvas.Draw((PaintBoxBackground.Width - Image.Width) div 2, (PaintBoxBackground.Height - Image.Height) div 2, Image);
		bkStretch:
		begin
			Rect.Left := PaintBoxBackground.Left;
			Rect.Top := PaintBoxBackground.Top;
			Rect.Right := PaintBoxBackground.Width;
			Rect.Bottom := PaintBoxBackground.Height;
			PaintBoxBackground.Canvas.StretchDraw(Rect, Image)
		end
	end;
	Image.Free
end;

procedure TMainForm.ShowOptionBox(Sender: TObject);
var
	TimerFlag: Boolean;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.MenuViewToolClick(Sender: TObject);
begin
	if spTool in ShowPart then
		ShowPart := ShowPart - [spTool]
	else
		ShowPart := ShowPart + [spTool];
	UpdateTool
end;

procedure TMainForm.PopupToolHideClick(Sender: TObject);
begin
	ShowPart := ShowPart - [spTool];
	UpdateTool
end;

procedure TMainForm.PopupToolShowHintClick(Sender: TObject);
begin
	if shTool in ShowHintPart then
		ShowHintPart := ShowHintPart - [shTool]
	else
		ShowHintPart := ShowHintPart + [shTool];
	UpdateTool
end;

procedure TMainForm.MenuViewStatusClick(Sender: TObject);
begin
	if spStatus in ShowPart then
		ShowPart := ShowPart - [spStatus]
	else
		ShowPart := ShowPart + [spStatus];
	UpdateStatus
end;

procedure TMainForm.PopupStatusHideClick(Sender: TObject);
begin
	ShowPart := ShowPart - [spStatus];
	UpdateStatus
end;

procedure TMainForm.PopupStatusShowHintClick(Sender: TObject);
begin
	if shStatus in ShowHintPart then
		ShowHintPart := ShowHintPart - [shStatus]
	else
		ShowHintPart := ShowHintPart + [shStatus];
	UpdateStatus
end;

procedure TMainForm.MenuViewTitleClick(Sender: TObject);
begin
	if spTitle in ShowPart then
		ShowPart := ShowPart - [spTitle]
	else
		ShowPart := ShowPart + [spTitle];
	UpdateTitle;
	UpdateChessboard
end;

procedure TMainForm.PopupTitleHideClick(Sender: TObject);
begin
	ShowPart := ShowPart - [spTitle];
	UpdateTitle;
	UpdateChessboard
end;

procedure TMainForm.PopupTitleShowHintClick(Sender: TObject);
begin
	if shTitle in ShowHintPart then
		ShowHintPart := ShowHintPart - [shTitle]
	else
		ShowHintPart := ShowHintPart + [shTitle];
	UpdateTitle
end;

procedure TMainForm.MenuViewNameClick(Sender: TObject);
begin
	if spName in ShowPart then
		ShowPart := ShowPart - [spName]
	else
		ShowPart := ShowPart + [spName];
	UpdateName;
	UpdateChessboard
end;

procedure TMainForm.PopupNameHideClick(Sender: TObject);
begin
	ShowPart := ShowPart - [spName];
	UpdateName;
	UpdateChessboard
end;

procedure TMainForm.PopupNameShowHintClick(Sender: TObject);
begin
	if shName in ShowHintPart then
		ShowHintPart := ShowHintPart - [shName]
	else
		ShowHintPart := ShowHintPart + [shName];
	UpdateName
end;

procedure TMainForm.MenuViewClockClick(Sender: TObject);
begin
	if spClock in ShowPart then
		ShowPart := ShowPart - [spClock]
	else
		ShowPart := ShowPart + [spClock];
	UpdateClock;
	UpdateChessboard
end;

procedure TMainForm.PopupClockHideClick(Sender: TObject);
begin
	ShowPart := ShowPart - [spClock];
	UpdateClock;
	UpdateChessboard
end;

procedure TMainForm.PopupClockShowHintClick(Sender: TObject);
begin
	if shClock in ShowHintPart then
		ShowHintPart := ShowHintPart - [shClock]
	else
		ShowHintPart := ShowHintPart + [shClock];
	UpdateClock
end;

procedure TMainForm.DoEvents;
begin
	if DoEventsFlag then Exit;
	DoEventsFlag := True;
	Application.ProcessMessages;
	DoEventsFlag := False
end;

procedure TMainForm.Delay(DelayTime: Integer);
var
	StopDateTime: TDateTime;
begin
	StopDateTime := Now + EncodeTime(0, 0, DelayTime div 1000, DelayTime mod 1000);
	repeat
		DoEvents
	until Now >= StopDateTime
end;

procedure TMainForm.LoadSetting;
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey('\Software\WC\黑白棋', True);
	BackgroundType := bkDefault;
	BackgroundBitmap := '';
	BackgroundMode := bkTile;
	ShowPart := [spTool, spStatus, spTitle, spName, spClock, spRowCol];
	ShowHintPart := [shTitle, shName, shClock, shTool, shStatus];
	TitleFont := '黑体';
	NameFont := '宋体';
	InputDevice[cmBlack] := idMouse;
	InputDevice[cmWhite] := idComputer;
	Level[cmBlack] := 2;
	Level[cmWhite] := 2;
	TimeLimit := 5;
	if Reg.ValueExists('背景类型') then
		try BackgroundType := TBackgroundType(Reg.ReadInteger('背景类型')) except end;
	if Reg.ValueExists('背景位图') then
		try BackgroundBitmap := Reg.ReadString('背景位图') except end;
	if Reg.ValueExists('背景显示方式') then
		try BackgroundMode := TBackgroundMode(Reg.ReadInteger('背景显示方式')) except end;
	if Reg.ValueExists('显示部件') then
		try Reg.ReadBinaryData('显示部件', ShowPart, SizeOf(ShowPart)) except end;
	if Reg.ValueExists('显示提示信息') then
		try Reg.ReadBinaryData('显示提示信息', ShowHintPart, SizeOf(ShowHintPart)) except end;
	if Reg.ValueExists('标题字体') then
		try TitleFont := Reg.ReadString('标题字体') except end;
	if Reg.ValueExists('姓名字体') then
		try NameFont := Reg.ReadString('姓名字体') except end;
	if Reg.ValueExists('黑方输入方式') then
		try InputDevice[cmBlack] := TInput(Reg.ReadInteger('黑方输入方式')) except end;
	if Reg.ValueExists('白方输入方式') then
		try InputDevice[cmWhite] := TInput(Reg.ReadInteger('白方输入方式')) except end;
	if Reg.ValueExists('黑方级别') then
		try Level[cmBlack] := Reg.ReadInteger('黑方级别') except end;
	if Reg.ValueExists('白方级别') then
		try Level[cmWhite] := Reg.ReadInteger('白方级别') except end;
	if Reg.ValueExists('比赛时间限制') then
		try TimeLimit := Reg.ReadInteger('比赛时间限制') except end;
	Reg.CloseKey;
	Reg.Free;
	if InputDevice[cmBlack] = idComputer then
		PlayerName[cmBlack] := '计算机'
	else
		PlayerName[cmBlack] := '黑方';
	if InputDevice[cmWhite] = idComputer then
		PlayerName[cmWhite] := '计算机'
	else
		PlayerName[cmWhite] := '白方'
end;

procedure TMainForm.SaveSetting;
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey('\Software\WC\黑白棋', True);
	Reg.WriteInteger('背景类型', Integer(BackgroundType));
	Reg.WriteString('背景位图', BackgroundBitmap);
	Reg.WriteInteger('背景显示方式', Integer(BackgroundMode));
	Reg.WriteBinaryData('显示部件', ShowPart, SizeOf(ShowPart));
	Reg.WriteBinaryData('显示提示信息', ShowHintPart, SizeOf(ShowHintPart));
	Reg.WriteString('标题字体', TitleFont);
	Reg.WriteString('姓名字体', NameFont);
	Reg.WriteInteger('黑方输入方式', Integer(InputDevice[cmBlack]));
	Reg.WriteInteger('白方输入方式', Integer(InputDevice[cmWhite]));
	Reg.WriteInteger('黑方级别', Level[cmBlack]);
	Reg.WriteInteger('白方级别', Level[cmWhite]);
	Reg.WriteInteger('比赛时间限制', TimeLimit);
	Reg.CloseKey;
	Reg.Free
end;

procedure TMainForm.UpdateSetting;
begin
	PaintBoxBackground.Refresh;
	UpdateTool;
	UpdateStatus;
	UpdateTitle;
	UpdateName;
	UpdateClock;
	ImageTitle.Canvas.Font.Name := TitleFont;
	ImageBlackName.Canvas.Font.Name := NameFont;
	ImageWhiteName.Canvas.Font.Name := NameFont;
	DrawChessboard;
	DrawTitle;
	DrawName
end;

procedure TMainForm.DrawBorder(W, H: Integer; DrawCanvas: TCanvas);
begin
	with DrawCanvas do
	begin
		Pen.Width := 1;
		Brush.Style := bsSolid;
		Pen.Color := clGray;
		Brush.Color := clWhite;
		Rectangle(0, 0, W, H);
		Brush.Color := clChessboard;
		Rectangle(4, 4, W - 4, H - 4);
		Pen.Color := clGray;
		MoveTo(W - 2, 1);
		LineTo(W - 5, 4);
		MoveTo(1, H - 2);
		LineTo(4, H - 5);
		Brush.Color := clYellow;
		FloodFill(1, 1, Pixels[1, 1], fsSurface);
		Brush.Color := clOlive;
		FloodFill(W - 2, H - 2, Pixels[W - 2, H - 2], fsSurface);
		MoveTo(1, 1);
		LineTo(4, 4);
		MoveTo(W - 2, H - 2);
		LineTo(W - 5, H - 5)
	end
end;

procedure TMainForm.DrawChessboard;
var
	I, X, Y: Integer;
	ImageBlack, ImageWhite, ImageMask: TBitmap;
begin
	ImageBlack := TBitmap.Create;
	ImageWhite := TBitmap.Create;
	ImageMask := TBitmap.Create;
	ImageBlack.LoadFromResourceName(HInstance, 'Black');
	ImageWhite.LoadFromResourceName(HInstance, 'White');
	ImageMask.LoadFromResourceName(HInstance, 'Mask');
	with ChessboardImage.Canvas do
	begin
		DrawBorder(232, 232, ChessboardImage.Canvas);
		Pen.Width := 3;
		Pen.Color := clBlack;
		Brush.Style := bsClear;
		for I := 0 to 7 do
		begin
			MoveTo(28, I * 25 + 28);
			LineTo(203, I * 25 + 28);
			MoveTo(I * 25 + 28, 28);
			LineTo(I * 25 + 28, 203);
			if spRowCol in ShowPart then
			begin
				TextOut(12 - TextWidth(IntToStr(I + 1)) div 2, I * 25 + 28 - TextHeight(IntToStr(I + 1)) div 2, IntToStr(I + 1));
				TextOut(I * 25 + 28 - TextWidth(Chr(I + 65)) div 2, 219 - TextHeight(Chr(I + 65)) div 2, Chr(I + 65))
			end
		end;
		for X := 0 to 7 do
			for Y := 0 to 7 do
				if Chessboard[X, Y] <> cmNone then
				begin
					CopyMode := cmSrcAnd;
					Draw(X * 25 + 20, Y * 25 + 20, ImageMask);
					CopyMode := cmSrcPaint;
					case Chessboard[X, Y] of
						cmBlack: Draw(X * 25 + 20, Y * 25 + 20, ImageBlack);
						cmWhite: Draw(X * 25 + 20, Y * 25 + 20, ImageWhite)
					end;
					CopyMode := cmSrcCopy
				end
	end;
	PaintBoxChessboard.Canvas.Draw(0, 0, ChessboardImage);
	ImageBlack.Free;
	ImageWhite.Free;
	ImageMask.Free
end;

procedure TMainForm.DrawTitle;
begin
	with ImageTitle.Canvas do
	begin
		DrawBorder(ImageTitle.Width, ImageTitle.Height, ImageTitle.Canvas);
		Brush.Style := bsClear;
		TextOut(116 - TextWidth('黑白棋') div 2, 5, '黑白棋')
	end
end;

procedure TMainForm.DrawName;
var
	S: WideString;
begin
	S := PlayerName[cmBlack];
	with ImageBlackName.Canvas do
	begin
		DrawBorder(ImageBlackName.Width, ImageBlackName.Height, ImageBlackName.Canvas);
		Brush.Style := bsClear;
		case Length(S) of
			2:
			begin
				TextOut(25 - TextWidth('黑') div 2, 25, S[1]);
				TextOut(25 - TextWidth('黑') div 2, 105, S[2])
			end;
			3:
			begin
				TextOut(25 - TextWidth('黑') div 2, 5, S[1]);
				TextOut(25 - TextWidth('黑') div 2, 65, S[2]);
				TextOut(25 - TextWidth('黑') div 2, 125, S[3])
			end;
			4:
			begin
				TextOut(25 - TextWidth('黑') div 2, 5, S[1]);
				TextOut(25 - TextWidth('黑') div 2, 45, S[2]);
				TextOut(25 - TextWidth('黑') div 2, 85, S[3]);
				TextOut(25 - TextWidth('黑') div 2, 125, S[4])
			end
		end
	end;
	ImageBlackName.Hint := S + '|双击可更改姓名，按鼠标右键可弹出快捷菜单';
	S := PlayerName[cmWhite];
	with ImageWhiteName.Canvas do
	begin
		DrawBorder(ImageWhiteName.Width, ImageWhiteName.Height, ImageWhiteName.Canvas);
		Brush.Style := bsClear;
		case Length(S) of
			2:
			begin
				TextOut(25 - TextWidth('白') div 2, 25, S[1]);
				TextOut(25 - TextWidth('白') div 2, 105, S[2])
			end;
			3:
			begin
				TextOut(25 - TextWidth('白') div 2, 5, S[1]);
				TextOut(25 - TextWidth('白') div 2, 65, S[2]);
				TextOut(25 - TextWidth('白') div 2, 125, S[3])
			end;
			4:
			begin
				TextOut(25 - TextWidth('白') div 2, 5, S[1]);
				TextOut(25 - TextWidth('白') div 2, 45, S[2]);
				TextOut(25 - TextWidth('白') div 2, 85, S[3]);
				TextOut(25 - TextWidth('白') div 2, 125, S[4])
			end
		end
	end;
	ImageWhiteName.Hint := S + '|双击可更改姓名，按鼠标右键可弹出快捷菜单'
end;

procedure TMainForm.DrawClock;
var
	I, X, Y: Integer;
	Rect: TRect;
begin
	with ImageBlackClock.Canvas do
	begin
		Brush.Color := clLtGray;
		Rect.Left := 0;
		Rect.Top := 0;
		Rect.Right := 50;
		Rect.Bottom := 50;
		FillRect(Rect);
		Pen.Color := clRed;
		MoveTo(0, 49);
		LineTo(0, 0);
		LineTo(49, 0);
		MoveTo(47, 2);
		LineTo(47, 47);
		LineTo(2, 47);
		Pen.Color := clMaroon;
		MoveTo(49, 0);
		LineTo(49, 49);
		LineTo(0, 49);
		MoveTo(2, 47);
		LineTo(2, 2);
		LineTo(47, 2);
		Rect.Left := 1;
		Rect.Top := 1;
		Rect.Right := 49;
		Rect.Bottom := 49;
		Brush.Color := clClockBorder;
		FrameRect(Rect)
	end;
	with ImageWhiteClock.Canvas do
	begin
		Brush.Color := clLtGray;
		Rect.Left := 0;
		Rect.Top := 0;
		Rect.Right := 50;
		Rect.Bottom := 50;
		FillRect(Rect);
		Pen.Color := clRed;
		MoveTo(0, 49);
		LineTo(0, 0);
		LineTo(49, 0);
		MoveTo(47, 2);
		LineTo(47, 47);
		LineTo(2, 47);
		Pen.Color := clMaroon;
		MoveTo(49, 0);
		LineTo(49, 49);
		LineTo(0, 49);
		MoveTo(2, 47);
		LineTo(2, 2);
		LineTo(47, 2);
		Rect.Left := 1;
		Rect.Top := 1;
		Rect.Right := 49;
		Rect.Bottom := 49;
		Brush.Color := clClockBorder;
		FrameRect(Rect)
	end;
	for I := 0 to 11 do
	begin
		X := Round(Sin(I * Pi / 6) * 20) + 25;
		Y := Round(Cos(I * Pi / 6) * 20) + 25;
		with ImageBlackClock.Canvas do
		begin
			Pixels[X - 1, Y] := clWhite;
			Pixels[X - 1, Y - 1] := clWhite;
			Pixels[X, Y - 1] := clWhite;
			Pixels[X + 1, Y] := clGray;
			Pixels[X + 1, Y + 1] := clGray;
			Pixels[X, Y + 1] := clGray
		end;
		with ImageWhiteClock.Canvas do
		begin
			Pixels[X - 1, Y] := clWhite;
			Pixels[X - 1, Y - 1] := clWhite;
			Pixels[X, Y - 1] := clWhite;
			Pixels[X + 1, Y] := clGray;
			Pixels[X + 1, Y + 1] := clGray;
			Pixels[X, Y + 1] := clGray
		end
	end
end;

procedure TMainForm.UpdateChessboard;
var
	X, Y: Integer;
begin
	X := (ScrollBox.ClientWidth - 232) div 2;
	if spTitle in ShowPart then
		Y := (ScrollBox.ClientHeight - 152) div 2
	else
		Y := (ScrollBox.ClientHeight - 232) div 2;
	if (spTitle in ShowPart) and (Y < 80) then Y := 80;
	if ((spName in ShowPart) or (spClock in ShowPart)) and (X < 80) then X := 80;
	if X < 0 then X := 0;
	if Y < 0 then Y := 0;
	PaintBoxChessboard.SetBounds(X, Y, 232, 232);
	ImageTitle.SetBounds(X, Y - 80, 232, 50);
	ImageBlackName.SetBounds(X - 80, Y, 50, 170);
	ImageWhiteName.SetBounds(X + 262, Y, 50, 170);
	if spTitle in ShowPart then
	begin
		ImageBlackClock.SetBounds(X - 80, Y - 80, 50, 50);
		ImageWhiteClock.SetBounds(X + 262, Y - 80, 50, 50)
	end
	else
	begin
		if spName in ShowPart then
		begin
			ImageBlackClock.SetBounds(X - 80, Y + 182, 50, 50);
			ImageWhiteClock.SetBounds(X + 262, Y + 182, 50, 50)
		end
		else
		begin
			ImageBlackClock.SetBounds(X - 80, Y, 50, 50);
			ImageWhiteClock.SetBounds(X + 262, Y, 50, 50)
		end
	end;
	PaintBoxChessboard.Canvas.Font.Height := -12;
	ImageTitle.Canvas.Font.Height := -40;
	ImageBlackName.Canvas.Font.Height := -40;
	ImageWhiteName.Canvas.Font.Height := -40
end;

procedure TMainForm.UpdateTool;
begin
	CoolBar.Visible := spTool in ShowPart;
	CoolBar.ShowHint := shTool in ShowHintPart;
	MenuViewTool.Checked := spTool in ShowPart;
	PopupToolShowHint.Checked := shTool in ShowHintPart
end;

procedure TMainForm.UpdateStatus;
begin
	StatusBar.Visible := spStatus in ShowPart;
	StatusBar.ShowHint := shStatus in ShowHintPart;
	MenuViewStatus.Checked := spStatus in ShowPart;
	PopupStatusShowHint.Checked := shStatus in ShowHintPart
end;

procedure TMainForm.UpdateTitle;
begin
	ImageTitle.Visible := spTitle in ShowPart;
	ImageTitle.ShowHint := shTitle in ShowHintPart;
	MenuViewTitle.Checked := spTitle in ShowPart;
	PopupTitleShowHint.Checked := shTitle in ShowHintPart
end;

procedure TMainForm.UpdateName;
begin
	ImageBlackName.Visible := spName in ShowPart;
	ImageWhiteName.Visible := spName in ShowPart;
	ImageBlackName.ShowHint := shName in ShowHintPart;
	ImageWhiteName.ShowHint := shName in ShowHintPart;
	MenuViewName.Checked := spName in ShowPart;
	PopupNameShowHint.Checked := shName in ShowHintPart
end;

procedure TMainForm.UpdateClock;
begin
	ImageBlackClock.Visible := spClock in ShowPart;
	ImageWhiteClock.Visible := spClock in ShowPart;
	ImageBlackClock.ShowHint := shClock in ShowHintPart;
	ImageWhiteClock.ShowHint := shClock in ShowHintPart;
	MenuViewClock.Checked := spClock in ShowPart;
	PopupClockShowHint.Checked := shClock in ShowHintPart
end;

procedure TMainForm.WMWinIniChange(var Msg: TWMWinIniChange);
begin
	inherited;
	UpdateChessboard;
	Msg.Result := 0
end;

procedure TMainForm.ChangeFont(Sender: TObject);
var
	TimerFlag: Boolean;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.PageControl.ActivePage := OptionBox.TabSheetView;
	OptionBox.PageControl.Pages[1].TabVisible := False;
	OptionBox.GroupBoxBackground.Enabled := False;
	OptionBox.GroupBoxDisplay.Enabled := False;
	OptionBox.GroupBoxShowHint.Enabled := False;
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag
end;

function TMainForm.InverseChessman(Chessman: TChessman): TChessman;
begin
	case Chessman of
		cmBlack: InverseChessman := cmWhite;
		cmWhite: InverseChessman := cmBlack;
		else InverseChessman := Chessman
	end
end;

procedure TMainForm.DrawTimer(TimerImage: TImage; CurTime: Integer);
var
	SinAngle, CosAngle: Real;
begin
	if CurTime = 0 then
	begin
		TimerImage.Hint := '时钟|双击可更改比赛时间，按鼠标右键可弹出快捷菜单。'
	end
	else
	begin
		if CurTime >= 3600 then
			TimerImage.Hint := IntToStr(CurTime div 3600) + '时' + IntToStr(CurTime mod 3600 div 60) + '分' + IntToStr(CurTime mod 60) + '秒' + '|双击可更改比赛时间，按鼠标右键可弹出快捷菜单。'
		else
			TimerImage.Hint := IntToStr(CurTime div 60) + '分' + IntToStr(CurTime mod 60) + '秒' + '|双击可更改比赛时间，按鼠标右键可弹出快捷菜单。'
	end;
	with TimerImage.Canvas do
	begin
		Brush.Color := clLtGray;
		Pen.Color := clLtGray;
		Ellipse(9, 9, 41, 41);
		Pen.Color := clGray;
		Brush.Color := clGreen;
		SinAngle := Sin(CurTime * Pi / 21600);
		CosAngle := Cos(CurTime * Pi / 21600);
		MoveTo(Round(SinAngle * 12) + 25, -Round(CosAngle * 12) + 25);
		LineTo(Round(CosAngle * 2) + 25, Round(SinAngle * 2) + 25);
		LineTo(-Round(SinAngle * 3) + 25, Round(CosAngle * 3) + 25);
		LineTo(-Round(CosAngle * 2) + 25, -Round(SinAngle * 2) + 25);
		LineTo(Round(SinAngle * 12) + 25, -Round(CosAngle * 12) + 25);
		FloodFill(25, 25, Pixels[25, 25], fsSurface);
		SinAngle := Sin(CurTime * Pi / 1800);
		CosAngle := Cos(CurTime * Pi / 1800);
		MoveTo(Round(SinAngle * 14) + 25, -Round(CosAngle * 14) + 25);
		LineTo(Round(CosAngle * 2) + 25, Round(SinAngle * 2) + 25);
		LineTo(-Round(SinAngle * 3) + 25, Round(CosAngle * 3) + 25);
		LineTo(-Round(CosAngle * 2) + 25, -Round(SinAngle * 2) + 25);
		LineTo(Round(SinAngle * 14) + 25, -Round(CosAngle * 14) + 25);
		FloodFill(25, 25, Pixels[25, 25], fsSurface);
		Pen.Color := clWhite;
		SinAngle := Sin(CurTime * Pi / 30);
		CosAngle := Cos(CurTime * Pi / 30);
		MoveTo(Round(SinAngle * 14) + 25, -Round(CosAngle * 14) + 25);
		LineTo(25, 25)
	end
end;

procedure TMainForm.ReverseChessman(X, Y: Integer);
var
	TimerFlag: Boolean;
	I, J, N, CX, CY: Integer;
	Chessman, Inverse: TChessman;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	Chessman := Chessboard[X, Y];
	Inverse := InverseChessman(Chessman);
	for I := 0 to 7 do
	begin
		CX := X + Direction[I].X;
		CY := Y + Direction[I].Y;
		if Chessboard[CX, CY] = Inverse then
		begin
			N := 0;
			repeat
				CX := CX + Direction[I].X;
				CY := CY + Direction[I].Y;
				Inc(N)
			until Chessboard[CX, CY] <> Inverse;
			if Chessboard[CX, CY] = Chessman then
			begin
				CX := X;
				CY := Y;
				for J := 1 to N do
				begin
					Delay(SleepTime);
					CX := CX + Direction[I].X;
					CY := CY + Direction[I].Y;
					Chessboard[CX, CY] := Chessman;
					DrawChessman(CX, CY)
				end
			end
		end
	end;
	TimerClock.Enabled := TimerFlag
end;

function TMainForm.CanDrop(X, Y: Integer; Chessman: TChessman): Integer;
var
	I, N, CX, CY, ResultCount: Integer;
	Inverse: TChessman;
begin
	CanDrop := 0;
	if Chessboard[X, Y] <> cmNone then Exit;
	ResultCount := 0;
	Inverse := InverseChessman(Chessman);
	for I := 0 to 7 do
	begin
		N := 0;
		CX := X + Direction[I].X;
		CY := Y + Direction[I].Y;
		if Chessboard[CX, CY] = Inverse then
		begin
			repeat
				Inc(CX, Direction[I].X);
				Inc(CY, Direction[I].Y);
				Inc(N)
			until Chessboard[CX, CY] <> Inverse;
			if Chessboard[CX, CY] = Chessman then
				Inc(ResultCount, N)
		end
	end;
	CanDrop := ResultCount
end;

procedure TMainForm.DrawChessman(X, Y: Integer);
var
	ImageChessman, ImageMask: TBitmap;
begin
	ImageChessman := TBitmap.Create;
	ImageMask := TBitmap.Create;
	case Chessboard[X, Y] of
		cmBlack: ImageChessman.LoadFromResourceName(HInstance, 'Black');
		cmWhite: ImageChessman.LoadFromResourceName(HInstance, 'White')
	end;
	ImageMask.LoadFromResourceName(HInstance, 'Mask');
	if Chessboard[X, Y] in [cmBlack, cmWhite] then
	begin
		ChessboardImage.Canvas.CopyMode := cmSrcAnd;
		ChessboardImage.Canvas.Draw(X * 25 + 20, Y * 25 + 20, ImageMask);
		ChessboardImage.Canvas.CopyMode := cmSrcPaint;
		ChessboardImage.Canvas.Draw(X * 25 + 20, Y * 25 + 20, ImageChessman);
		ChessboardImage.Canvas.CopyMode := cmSrcCopy;
		PaintBoxChessboard.Canvas.CopyMode := cmSrcAnd;
		PaintBoxChessboard.Canvas.Draw(X * 25 + 20, Y * 25 + 20, ImageMask);
		PaintBoxChessboard.Canvas.CopyMode := cmSrcPaint;
		PaintBoxChessboard.Canvas.Draw(X * 25 + 20, Y * 25 + 20, ImageChessman);
		PaintBoxChessboard.Canvas.CopyMode := cmSrcCopy
	end;
	ImageChessman.Free;
	ImageMask.Free
end;

procedure TMainForm.PaintBoxChessboardPaint(Sender: TObject);
begin
	PaintBoxChessboard.Canvas.Draw(0, 0, ChessboardImage)
end;

procedure TMainForm.PaintBoxChessboardMouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
	I, J: Integer;
begin
	if DoEventsFlag or (not PlayingFlag) then Exit;
	if InputDevice[PlayerGo] = idMouse then
	begin
		I := Round((X - 28) / 25);
		J := Round((Y - 28) / 25);
		if CanDrop(I, J, PlayerGo) <> 0 then DropChessman(I, J)
	end
end;

procedure TMainForm.PaintBoxBackgroundDblClick(Sender: TObject);
var
	TimerFlag: Boolean;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.PageControl.ActivePage := OptionBox.TabSheetView;
	OptionBox.PageControl.Pages[1].TabVisible := False;
	OptionBox.GroupBoxDisplay.Enabled := False;
	OptionBox.GroupBoxShowHint.Enabled := False;
	OptionBox.GroupBoxFont.Enabled := False;
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
	LastFlag, TimerFlag: Boolean;
begin
	CanClose := False;
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	if DoEventsFlag then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox('不能在这个时候退出。', '黑白棋', MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		TimerClock.Enabled := TimerFlag;
		Exit
	end;
	if PlayingFlag then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		if Application.MessageBox(PChar('游戏尚未结束。' + #13#10#13#10 + '真要退出吗？'), '黑白棋', MB_YESNO or MB_ICONQUESTION) = IDNO then
		begin
			DoEventsFlag := LastFlag;
			TimerClock.Enabled := TimerFlag;
			Exit
		end;
		DoEventsFlag := LastFlag
	end;
	CanClose := True
end;

procedure TMainForm.NewGame(Sender: TObject);
var
	LastFlag, TimerFlag: Boolean;
begin
	LastFlag := DoEventsFlag;
	DoEventsFlag := True;
	if PlayingFlag then
		if Application.MessageBox(PChar('游戏尚未结束。' + #13#10#13#10 + '想结束当前游戏吗？'), '黑白棋', MB_YESNO or MB_ICONQUESTION) = IDNO then
		begin
			DoEventsFlag := LastFlag;
			Exit
		end;
	DoEventsFlag := LastFlag;
	CloseGame;
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	OptionBox := TOptionBox.Create(Self);
	OptionBox.PageControl.ActivePage := OptionBox.TabSheetGame;
	OptionBox.ShowModal;
	OptionBox.Release;
	TimerClock.Enabled := TimerFlag;
	StartGame
end;

procedure TMainForm.StartGame;
begin
	PlayerGo := cmBlack;
	PlayingFlag := True;
	GameTime[cmBlack] := 0;
	GameTime[cmWhite] := 0;
	ToolButtonOption.Enabled := False;
	MenuFileOption.Enabled := False;
	MenuFileStopGame.Enabled := True;
	Chessboard[3, 3] := cmWhite;
	DrawChessman(3, 3);
	Chessboard[3, 4] := cmBlack;
	DrawChessman(3, 4);
	Chessboard[4, 3] := cmBlack;
	DrawChessman(4, 3);
	Chessboard[4, 4] := cmWhite;
	DrawChessman(4, 4);
	KeyboardX := 0;
	KeyboardY := 0;
	StatusBar.SimplePanel := False;
	StatusBar.Panels.Items[0].Text := PlayerName[cmBlack] + '：2';
	StatusBar.Panels.Items[1].Text := PlayerName[cmWhite] + '：2';
	StatusBar.Panels.Items[2].Text := PlayerName[cmBlack] + '走棋。';
	if InputDevice[cmBlack] in [idLetter, idDirection] then DrawKeyboardCursor(0, 0);
	TimerComputerMove.Enabled := True;
	TimerClock.Enabled := True
end;

procedure TMainForm.DropChessman(X, Y: Integer);
var
	I, J, BlackCount, WhiteCount: Integer;
	LastFlag, Flag: Boolean;
	Inverse: TChessman;
	MousePos, ChessmanPos: TPoint;
begin
	ToolButtonNew.Enabled := False;
	ToolButtonHistory.Enabled := False;
	ToolButtonExit.Enabled := False;
	MenuFileNew.Enabled := False;
	MenuFileExit.Enabled := False;
	MenuFileStopGame.Enabled := False;
	MenuViewHistory.Enabled := False;
	if InputDevice[PlayerGo] = idComputer then
	begin
		Flag := TimerClock.Enabled;
		TimerClock.Enabled := False;
		repeat
			Delay(50);
			GetCursorPos(MousePos);
			ChessmanPos.X := X * 25 + 28;
			ChessmanPos.Y := Y * 25 + 28;
			ChessmanPos := PaintBoxChessboard.ClientToScreen(ChessmanPos);
			if Abs(ChessmanPos.X - MousePos.X) > 5 then
			begin
				if ChessmanPos.X > MousePos.X then Inc(MousePos.X, 10) else Dec(MousePos.X, 10)
			end;
			if Abs(ChessmanPos.Y - MousePos.Y) > 5 then
			begin
				if ChessmanPos.Y > MousePos.Y then Inc(MousePos.Y, 10) else Dec(MousePos.Y, 10)
			end;
			SetCursorPos(MousePos.X, MousePos.Y)
		until (Abs(MousePos.X - ChessmanPos.X) <= 5) and (Abs(MousePos.Y - ChessmanPos.Y) <= 5);
		TimerClock.Enabled := Flag
	end;
	Chessboard[X, Y] := PlayerGo;
	DrawChessman(X, Y);
	ReverseChessman(X, Y);
	Inverse := InverseChessman(PlayerGo);
	if (GameTime[PlayerGo] > TimeLimit * 60) and (TimeLimit > 0) and (not DoEventsFlag) then
	begin
		TimerClock.Enabled := False;
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox(PChar(PlayerName[PlayerGo] + '超时，' + PlayerName[InverseChessman(PlayerGo)] + '赢了。'), '黑白棋', MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		SaveHistory(InverseChessman(PlayerGo), 0, 0);
		PlayingFlag := False;
		ShowHistory;
		CloseGame
	end;
	Flag := True;
	for I := 0 to 7 do
		for J := 0 to 7 do
			if Chessboard[I, J] = cmNone then
			begin
				Flag := False;
				Break
			end;
	if Flag then
	begin
		FinishGame;
		ToolButtonNew.Enabled := True;
		ToolButtonHistory.Enabled := True;
		ToolButtonExit.Enabled := True;
		MenuFileNew.Enabled := True;
		MenuFileExit.Enabled := True;
		MenuFileStopGame.Enabled := True;
		MenuViewHistory.Enabled := True;
		Exit
	end;
	Flag := True;
	for I := 0 to 7 do
		for J := 0 to 7 do
			if Chessboard[I, J] = Inverse then
			begin
				Flag := False;
				Break
			end;
	if Flag then
	begin
		FinishGame;
		ToolButtonNew.Enabled := True;
		ToolButtonHistory.Enabled := True;
		ToolButtonExit.Enabled := True;
		MenuFileNew.Enabled := True;
		MenuFileExit.Enabled := True;
		MenuFileStopGame.Enabled := True;
		MenuViewHistory.Enabled := True;
		Exit
	end;
	Flag := True;
	for I := 0 to 7 do
		for J := 0 to 7 do
			if CanDrop(I, J, Inverse) <> 0 then
			begin
				Flag := False;
				Break
			end;
	if Flag then
	begin
		for I := 0 to 7 do
			for J := 0 to 7 do
				if CanDrop(I, J, PlayerGo) <> 0 then
				begin
					Flag := False;
					Break
				end;
		if Flag then
		begin
			FinishGame;
			ToolButtonNew.Enabled := True;
			ToolButtonHistory.Enabled := True;
			ToolButtonExit.Enabled := True;
			MenuFileNew.Enabled := True;
			MenuFileExit.Enabled := True;
			MenuFileStopGame.Enabled := True;
			MenuViewHistory.Enabled := True;
			Exit
		end;
		BlackCount := 0;
		WhiteCount := 0;
		for I := 0 to 7 do
			for J := 0 to 7 do
				case Chessboard[I, J] of
					cmBlack: Inc(BlackCount);
					cmWhite: Inc(WhiteCount)
				end;
		StatusBar.Panels.Items[0].Text := PlayerName[cmBlack] + '：' + IntToStr(BlackCount);
		StatusBar.Panels.Items[1].Text := PlayerName[cmWhite] + '：' + IntToStr(WhiteCount);
		StatusBar.Panels.Items[2].Text := PlayerName[PlayerGo] + '继续走棋。'
	end
	else
	begin
		case PlayerGo of
			cmBlack: PlayerGo := cmWhite;
			cmWhite: PlayerGo := cmBlack
		end;
		BlackCount := 0;
		WhiteCount := 0;
		for I := 0 to 7 do
			for J := 0 to 7 do
				case Chessboard[I, J] of
					cmBlack: Inc(BlackCount);
					cmWhite: Inc(WhiteCount)
				end;
		StatusBar.Panels.Items[0].Text := PlayerName[cmBlack] + '：' + IntToStr(BlackCount);
		StatusBar.Panels.Items[1].Text := PlayerName[cmWhite] + '：' + IntToStr(WhiteCount);
		StatusBar.Panels.Items[2].Text := PlayerName[PlayerGo] + '走棋。'
	end;
	if InputDevice[PlayerGo] in [idLetter, idDirection] then
	begin
		KeyboardX := X;
		KeyboardY := Y;
		DrawKeyboardCursor(X, Y)
	end;
	ToolButtonNew.Enabled := True;
	ToolButtonHistory.Enabled := True;
	ToolButtonExit.Enabled := True;
	MenuFileNew.Enabled := True;
	MenuFileExit.Enabled := True;
	MenuFileStopGame.Enabled := True;
	MenuViewHistory.Enabled := True
end;

procedure TMainForm.TimerClockTimer(Sender: TObject);
var
	LastFlag: Boolean;
begin
	case PlayerGo of
		cmBlack: DrawTimer(ImageBlackClock, GameTime[cmBlack]);
		cmWhite: DrawTimer(ImageWhiteClock, GameTime[cmWhite])
	end;
	Inc(GameTime[PlayerGo]);
	if (GameTime[PlayerGo] > TimeLimit * 60) and (TimeLimit > 0) and (not DoEventsFlag) then
	begin
		TimerClock.Enabled := False;
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox(PChar(PlayerName[PlayerGo] + '超时，' + PlayerName[InverseChessman(PlayerGo)] + '赢了。'), '黑白棋', MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		SaveHistory(InverseChessman(PlayerGo), 0, 0);
		ShowHistory;
		CloseGame
	end;
end;

procedure TMainForm.FinishGame;
var
	LastFlag: Boolean;
	I, J, BlackX, BlackY, WhiteX, WhiteY, BlackCount, WhiteCount: Integer;
begin
	StatusBar.Panels.Items[2].Text := '比赛结束。';
	TimerComputerMove.Enabled := False;
	TimerClock.Enabled := False;
	LastFlag := DoEventsFlag;
	DoEventsFlag := True;
	Application.MessageBox('比赛结束。', '黑白棋', MB_OK);
	DoEventsFlag := LastFlag;
	BlackCount := 0;
	WhiteCount := 0;
	for I := 0 to 7 do
		for J := 0 to 7 do
		begin
			case Chessboard[I, J] of
				cmBlack: Inc(BlackCount);
				cmWhite: Inc(WhiteCount)
			end;
			Chessboard[I, J] := cmNone
		end;
	DrawChessboard;
	BlackX := 0;
	BlackY := 0;
	WhiteX := 7;
	WhiteY := 7;
	I := 0;
	J := 0;
	repeat
		if I < BlackCount then
		begin
			Chessboard[BlackX, BlackY] := cmBlack;
			DrawChessman(BlackX, BlackY);
			Inc(BlackX);
			if BlackX >= 8 then
			begin
				BlackX := 0;
				Inc(BlackY)
			end;
			Inc(I)
		end;
		if J < WhiteCount then
		begin
			Chessboard[WhiteX, WhiteY] := cmWhite;
			DrawChessman(WhiteX, WhiteY);
			Dec(WhiteX);
			if WhiteX < 0 then
			begin
				WhiteX := 7;
				Dec(WhiteY)
			end;
			Inc(J)
		end;
		StatusBar.Panels.Items[0].Text := PlayerName[cmBlack] + '：' + IntToStr(I);
		StatusBar.Panels.Items[1].Text := PlayerName[cmWhite] + '：' + IntToStr(J);
		StatusBar.Panels.Items[2].Text := '正在统计双方棋子数。';
		Delay(SleepTime)
	until I + J >= BlackCount + WhiteCount;
	if BlackCount > WhiteCount then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox(PChar(PlayerName[cmBlack] + '赢了！'), '黑白棋', MB_OK or MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		SaveHistory(cmBlack, BlackCount, WhiteCount);
	end;
	if BlackCount < WhiteCount then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox(PChar(PlayerName[cmWhite] + '赢了！'), '黑白棋', MB_OK or MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		SaveHistory(cmWhite, BlackCount, WhiteCount)
	end;
	if BlackCount = WhiteCount then
	begin
		LastFlag := DoEventsFlag;
		DoEventsFlag := True;
		Application.MessageBox('平局！', '黑白棋', MB_OK or MB_ICONINFORMATION);
		DoEventsFlag := LastFlag;
		SaveHistory(cmNone, BlackCount, WhiteCount)
	end;
	ShowHistory;
	CloseGame
end;

procedure TMainForm.CloseGame;
var
	I, J: Integer;
begin
	PlayingFlag := False;
	GameTime[cmBlack] := 0;
	GameTime[cmWhite] := 0;
	ToolButtonOption.Enabled := True;
	MenuFileOption.Enabled := True;
	MenuFileStopGame.Enabled := False;
	StatusBar.Panels.Items[0].Text := '';
	StatusBar.Panels.Items[1].Text := '';
	StatusBar.Panels.Items[2].Text := '';
	for I := 0 to 7 do
		for J := 0 to 7 do
			Chessboard[I, J] := cmNone;
	DrawChessboard;
	DrawTimer(ImageBlackClock, 0);
	DrawTimer(ImageWhiteClock, 0)
end;

procedure TMainForm.ShowHistory;
var
	TimerFlag: Boolean;
	I, J, Mark, Place, Win, Fail, Draw, WinCount, TotalTime: Integer;
	S: string;
	CurItem: TListItem;
	Reg: TRegistry;
begin
	TimerFlag := TimerClock.Enabled;
	TimerClock.Enabled := False;
	HistoryBox := THistoryBox.Create(Self);
	HistoryBox.ListView.Items.Add;
	Reg := TRegistry.Create;
	Reg.OpenKey('\Software\WC\黑白棋\历史记录', True);
	Reg.GetKeyNames(HistoryBox.ListView.Items[0].SubItems);
	for I := 0 to HistoryBox.ListView.Items[0].SubItems.Count - 1 do
	begin
		Win := 0;
		Fail := 0;
		Draw := 0;
		WinCount := 0;
		TotalTime := 0;
		Reg.OpenKey('\Software\WC\黑白棋\历史记录\' + HistoryBox.ListView.Items[0].SubItems.Strings[I], True);
		if Reg.ValueExists('胜') then
			try Win := Reg.ReadInteger('胜') except end;
		if Reg.ValueExists('败') then
			try Fail := Reg.ReadInteger('败') except end;
		if Reg.ValueExists('平') then
			try Draw := Reg.ReadInteger('平') except end;
		if Reg.ValueExists('净胜子数') then
			try WinCount := Reg.ReadInteger('净胜子数') except end;
		if Reg.ValueExists('比赛总时间') then
			try TotalTime := Reg.ReadInteger('比赛总时间') except end;
		Reg.CloseKey;
		CurItem := HistoryBox.ListView.Items.Add;
		with CurItem.SubItems do
		begin
			if TotalTime >= 3600 then
				S := IntToStr(TotalTime div 3600) + '时' + IntToStr(TotalTime mod 3600 div 60) + '分' + IntToStr(TotalTime mod 60) + '秒'
			else
				S := IntToStr(TotalTime div 60) + '分' + IntToStr(TotalTime mod 60) + '秒';
			Add(HistoryBox.ListView.Items.Item[0].SubItems.Strings[I]);
			Add(IntToStr(Win));
			Add(IntToStr(Fail));
			Add(IntToStr(Draw));
			Add(IntToStr(WinCount));
			Add(S);
			Add(IntToStr(Win * 3 + Draw))
		end
	end;
	HistoryBox.ListView.Items.Delete(0);
	Reg.CloseKey;
	Reg.Free;
	for I := 0 to HistoryBox.ListView.Items.Count - 1 do
	begin
		Place := 1;
		Mark := StrToInt(HistoryBox.ListView.Items.Item[I].SubItems.Strings[6]);
		WinCount := StrToInt(HistoryBox.ListView.Items.Item[I].SubItems.Strings[4]);
		for J := 0 to HistoryBox.ListView.Items.Count - 1 do
			if StrToInt(HistoryBox.ListView.Items.Item[J].SubItems.Strings[6]) > Mark then
			begin
				Inc(Place)
			end
			else
			begin
				if StrToInt(HistoryBox.ListView.Items.Item[J].SubItems.Strings[6]) = Mark then
					if StrToInt(HistoryBox.ListView.Items.Item[J].SubItems.Strings[4]) > WinCount then
						Inc(Place)
			end;
		J := Length(IntToStr(HistoryBox.ListView.Items.Count));
		Str(Place:J, S);
		HistoryBox.ListView.Items.Item[I].Caption := S
	end;
	HistoryBox.ListView.SortType := stText;
	HistoryBox.ShowModal;
	HistoryBox.Release;
	TimerClock.Enabled := TimerFlag
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if DoEventsFlag or (not PlayingFlag) then Exit;
	case InputDevice[PlayerGo] of
		idLetter:
		begin
			case Key of
				$57:
				if KeyboardY > 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Dec(KeyboardY);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				$53:
				if KeyboardY < 7 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Inc(KeyboardY);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				$41:
				if KeyboardX > 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Dec(KeyboardX);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				$44:
				if KeyboardX < 7 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Inc(KeyboardX);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				VK_SPACE:
				if CanDrop(KeyboardX, KeyboardY, PlayerGo) <> 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					DropChessman(KeyboardX, KeyboardY)
				end
			end
		end;
		idDirection:
		begin
			case Key of
				VK_UP:
				if KeyboardY > 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Dec(KeyboardY);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				VK_DOWN:
				if KeyboardY < 7 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Inc(KeyboardY);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				VK_LEFT:
				if KeyboardX > 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Dec(KeyboardX);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				VK_RIGHT:
				if KeyboardX < 7 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					Inc(KeyboardX);
					DrawKeyboardCursor(KeyboardX, KeyboardY)
				end;
				VK_RETURN:
				if CanDrop(KeyboardX, KeyboardY, PlayerGo) <> 0 then
				begin
					DrawKeyboardCursor(KeyboardX, KeyboardY);
					DropChessman(KeyboardX, KeyboardY)
				end
			end
		end
	end
end;

procedure TMainForm.DrawKeyboardCursor(X, Y: Integer);
begin
	if DoEventsFlag then Exit;
	IsExistKeyboardCursor := not IsExistKeyboardCursor;
	with ChessboardImage.Canvas do
	begin
		Pen.Color := clWhite;
		Pen.Mode := pmXor;
		Pen.Width := 2;
		MoveTo(X * 25 + 33, Y * 25 + 18);
		LineTo(X * 25 + 38, Y * 25 + 18);
		LineTo(X * 25 + 38, Y * 25 + 23);
		MoveTo(X * 25 + 38, Y * 25 + 33);
		LineTo(X * 25 + 38, Y * 25 + 38);
		LineTo(X * 25 + 33, Y * 25 + 38);
		MoveTo(X * 25 + 23, Y * 25 + 38);
		LineTo(X * 25 + 18, Y * 25 + 38);
		LineTo(X * 25 + 18, Y * 25 + 33);
		MoveTo(X * 25 + 18, Y * 25 + 23);
		LineTo(X * 25 + 18, Y * 25 + 18);
		LineTo(X * 25 + 23, Y * 25 + 18);
		Pen.Width := 1;
		Pen.Mode := pmCopy
	end;
	with PaintBoxChessboard.Canvas do
	begin
		Pen.Color := clWhite;
		Pen.Mode := pmXor;
		Pen.Width := 2;
		MoveTo(X * 25 + 33, Y * 25 + 18);
		LineTo(X * 25 + 38, Y * 25 + 18);
		LineTo(X * 25 + 38, Y * 25 + 23);
		MoveTo(X * 25 + 38, Y * 25 + 33);
		LineTo(X * 25 + 38, Y * 25 + 38);
		LineTo(X * 25 + 33, Y * 25 + 38);
		MoveTo(X * 25 + 23, Y * 25 + 38);
		LineTo(X * 25 + 18, Y * 25 + 38);
		LineTo(X * 25 + 18, Y * 25 + 33);
		MoveTo(X * 25 + 18, Y * 25 + 23);
		LineTo(X * 25 + 18, Y * 25 + 18);
		LineTo(X * 25 + 23, Y * 25 + 18);
		Pen.Width := 1;
		Pen.Mode := pmCopy
	end
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	CloseGame;
	ChessboardImage.Free
end;

procedure TMainForm.MenuFileStopGameClick(Sender: TObject);
var
	LastFlag: Boolean;
begin
	LastFlag := DoEventsFlag;
	DoEventsFlag := True;
	if Application.MessageBox('真要结束当前游戏吗？', '黑白棋', MB_YESNO or MB_ICONQUESTION) = IDYES then
	begin
		DoEventsFlag := LastFlag;
		CloseGame
	end
end;

procedure TMainForm.SaveHistory(WinPlayer: TChessman; BlackCount, WhiteCount: Integer);
var
	Win, Fail, Draw, WinCount, TotalTime: Integer;
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey('\Software\WC\黑白棋\历史记录\' + PlayerName[cmBlack], True);
	Win := 0;
	Fail := 0;
	Draw := 0;
	WinCount := 0;
	TotalTime := 0;
	if Reg.ValueExists('胜') then
		try Win := Reg.ReadInteger('胜') except end;
	if Reg.ValueExists('败') then
		try Fail := Reg.ReadInteger('败') except end;
	if Reg.ValueExists('平') then
		try Draw := Reg.ReadInteger('平') except end;
	if Reg.ValueExists('净胜子数') then
		try WinCount := Reg.ReadInteger('净胜子数') except end;
	if Reg.ValueExists('比赛总时间') then
		try TotalTime := Reg.ReadInteger('比赛总时间') except end;
	case WinPlayer of
		cmBlack: Inc(Win);
		cmWhite: Inc(Fail);
		cmNone: Inc(Draw)
	end;
	if BlackCount - WhiteCount > 0 then Inc(WinCount, BlackCount - WhiteCount);
	Inc(TotalTime, GameTime[cmBlack]);
	Reg.WriteInteger('胜', Win);
	Reg.WriteInteger('败', Fail);
	Reg.WriteInteger('平', Draw);
	Reg.WriteInteger('净胜子数', WinCount);
	Reg.WriteInteger('比赛总时间', TotalTime);
	Reg.CloseKey;
	Reg.OpenKey('\Software\WC\黑白棋\历史记录\' + PlayerName[cmWhite], True);
	Win := 0;
	Fail := 0;
	Draw := 0;
	WinCount := 0;
	TotalTime := 0;
	if Reg.ValueExists('胜') then
		try Win := Reg.ReadInteger('胜') except end;
	if Reg.ValueExists('败') then
		try Fail := Reg.ReadInteger('败') except end;
	if Reg.ValueExists('平') then
		try Draw := Reg.ReadInteger('平') except end;
	if Reg.ValueExists('净胜子数') then
		try WinCount := Reg.ReadInteger('净胜子数') except end;
	if Reg.ValueExists('比赛总时间') then
		try TotalTime := Reg.ReadInteger('比赛总时间') except end;
	case WinPlayer of
		cmWhite: Inc(Win);
		cmBlack: Inc(Fail);
		cmNone: Inc(Draw)
	end;
	if WhiteCount - BlackCount > 0 then Inc(WinCount, WhiteCount - BlackCount);
	Inc(TotalTime, GameTime[cmWhite]);
	Reg.WriteInteger('胜', Win);
	Reg.WriteInteger('败', Fail);
	Reg.WriteInteger('平', Draw);
	Reg.WriteInteger('净胜子数', WinCount);
	Reg.WriteInteger('比赛总时间', TotalTime);
	Reg.CloseKey;
	Reg.Free
end;

procedure TMainForm.ToolButtonHistoryClick(Sender: TObject);
begin
	ShowHistory
end;

procedure TMainForm.MenuViewHistoryClick(Sender: TObject);
begin
	ShowHistory
end;

procedure TMainForm.TimerComputerMoveTimer(Sender: TObject);
var
	Flag: Boolean;
	I, J, N, BestWinCount: Integer;
	ResultMove: TPoint;
	DropChessboard: TDropChessboard;
begin
	if (not PlayingFlag) or DoEventsFlag or (InputDevice[PlayerGo] <> idComputer) then Exit;
	MenuFileStopGame.Enabled := False;
	FillChar(DropChessboard, SizeOf(DropChessboard), 0);
	for I := 0 to 7 do
		for J := 0 to 7 do
			DropChessboard[I, J] := CanDrop(I, J, PlayerGo);
	case Level[PlayerGo] of
		0:
		repeat
			DoEvents;
			ResultMove.X := Random(8);
			ResultMove.Y := Random(8)
		until DropChessboard[ResultMove.X, ResultMove.Y] <> 0;
		1:
		begin
			Flag := True;
			if CanDrop(0, 0, PlayerGo) <> 0 then
			begin
				ResultMove.X := 0;
				ResultMove.Y := 0;
				Flag := False
			end;
			if CanDrop(0, 7, PlayerGo) <> 0 then
			begin
				ResultMove.X := 0;
				ResultMove.Y := 7;
				Flag := False
			end;
			if CanDrop(7, 0, PlayerGo) <> 0 then
			begin
				ResultMove.X := 7;
				ResultMove.Y := 0;
				Flag := False
			end;
			if CanDrop(7, 7, PlayerGo) <> 0 then
			begin
				ResultMove.X := 7;
				ResultMove.Y := 7;
				Flag := False
			end;
			if Flag then
			begin
				BestWinCount := 0;
				for I := 0 to 7 do
					for J := 0 to 7 do
					begin
						DoEvents;
						if DropChessboard[I, J] <> 0 then
						begin
							N := DropChessboard[I, J] + Value(I, J);
							if N > BestWinCount then BestWinCount := N
						end
					end;
				repeat
					DoEvents;
					ResultMove.X := Random(8);
					ResultMove.Y := Random(8)
				until (DropChessboard[ResultMove.X, ResultMove.Y] + Value(ResultMove.X, ResultMove.Y) = BestWinCount) and (DropChessboard[ResultMove.X, ResultMove.Y] <> 0)
			end
		end;
		2:
		begin
			ResultMove := ComputerMove(4)
		end
	end;
	DropChessman(ResultMove.X, ResultMove.Y);
	MenuFileStopGame.Enabled := True
end;

function TMainForm.Value(X, Y: Integer): Integer;
var
	ResultValue: Integer;
begin
	ResultValue := 0;
	if (X = 0) and (Y = 0) then Inc(ResultValue, 5);
	if (X = 7) and (Y = 0) then Inc(ResultValue, 5);
	if (X = 0) and (Y = 7) then Inc(ResultValue, 5);
	if (X = 7) and (Y = 7) then Inc(ResultValue, 5);
	if (X = 0) or (X = 7) or (Y = 0) or (Y = 7) then Inc(ResultValue, 1);
	Value := ResultValue
end;

function TMainForm.ComputerMove(MaxDepth: Integer): TPoint;
var
	I, J, MaxValue: Integer;
	ResultMove: TPoint;
	RootNode: TSearchNode;
	DropChessboard: TDropChessboard;
begin
	if CanDrop(0, 0, PlayerGo) <> 0 then
	begin
		ComputerMove.X := 0;
		ComputerMove.Y := 0;
		Exit
	end;
	if CanDrop(0, 7, PlayerGo) <> 0 then
	begin
		ComputerMove.X := 0;
		ComputerMove.Y := 7;
		Exit
	end;
	if CanDrop(7, 0, PlayerGo) <> 0 then
	begin
		ComputerMove.X := 7;
		ComputerMove.Y := 0;
		Exit
	end;
	if CanDrop(7, 7, PlayerGo) <> 0 then
	begin
		ComputerMove.X := 7;
		ComputerMove.Y := 7;
		Exit
	end;
	RootNode := TSearchNode.Create(nil, 0, 0, MaxDepth, InverseChessman(PlayerGo), Chessboard);
	MaxValue := -1000;
	for I := 0 to 7 do
		for J := 0 to 7 do
			if Assigned(RootNode.Children[I, J]) then
			begin
				DropChessboard[I, J] := RootNode.Children[I, J].Value;
				if DropChessboard[I, J] > MaxValue then
					MaxValue := DropChessboard[I, J]
			end
			else
			begin
				DropChessboard[I, J] := -1000
			end;
	repeat
		DoEvents;
		ResultMove.X := Random(8);
		ResultMove.Y := Random(8)
	until DropChessboard[ResultMove.X, ResultMove.Y] = MaxValue;
	ComputerMove := ResultMove
end;

end.
