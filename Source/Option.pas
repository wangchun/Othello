unit Option;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	Buttons, ComCtrls, ExtCtrls, Dialogs, ExtDlgs, Messages, Menus;

type
	TOptionBox = class(TForm)
		BitBtnApply: TBitBtn;
		BitBtnCancel: TBitBtn;
		BitBtnOK: TBitBtn;
		CheckBoxShowHintClock: TCheckBox;
		CheckBoxShowHintName: TCheckBox;
		CheckBoxShowHintStatus: TCheckBox;
		CheckBoxShowHintTitle: TCheckBox;
		CheckBoxShowHintTool: TCheckBox;
		CheckBoxDisplayClock: TCheckBox;
		CheckBoxDisplayName: TCheckBox;
		CheckBoxDisplayRowCol: TCheckBox;
		CheckBoxDisplayStatus: TCheckBox;
		CheckBoxDisplayTitle: TCheckBox;
		CheckBoxDisplayTool: TCheckBox;
		CheckBoxTimeNoLimit: TCheckBox;
		ComboBoxBlackInput: TComboBox;
		ComboBoxBlackLevel: TComboBox;
		ComboBoxFontName: TComboBox;
		ComboBoxFontTitle: TComboBox;
		ComboBoxWhiteInput: TComboBox;
		ComboBoxWhiteLevel: TComboBox;
		EditBackground: TEdit;
		EditBlackName: TEdit;
		EditWhiteName: TEdit;
		GroupBoxBlack: TGroupBox;
		GroupBoxDisplay: TGroupBox;
		GroupBoxBackground: TGroupBox;
		GroupBoxFont: TGroupBox;
		GroupBoxShowHint: TGroupBox;
		GroupBoxTime: TGroupBox;
		GroupBoxWhite: TGroupBox;
		LabelBackgroundMode: TLabel;
		LabelBlackInput: TLabel;
		LabelBlackLevel: TLabel;
		LabelBlackName: TLabel;
		LabelFontName: TLabel;
		LabelFontTitle: TLabel;
		LabelTimeLimit: TLabel;
		LabelTimeLong: TLabel;
		LabelTimeShort: TLabel;
		LabelWhiteInput: TLabel;
		LabelWhiteLevel: TLabel;
		LabelWhiteName: TLabel;
		OpenPictureDialog: TOpenPictureDialog;
		PageControl: TPageControl;
		PanelBackgroundMode: TPanel;
		PanelButton: TPanel;
		PanelPage: TPanel;
		RadioButtonBackgroundCenter: TRadioButton;
		RadioButtonBackgroundDefault: TRadioButton;
		RadioButtonBackgroundNone: TRadioButton;
		RadioButtonBackgroundStretch: TRadioButton;
		RadioButtonBackgroundTile: TRadioButton;
		RadioButtonBackgroundUserDefine: TRadioButton;
		RadioButtonBlackMan: TRadioButton;
		RadioButtonBlackComputer: TRadioButton;
		RadioButtonWhiteComputer: TRadioButton;
		RadioButtonWhiteMan: TRadioButton;
		SpeedButtonBackgroundBrowse: TSpeedButton;
		TabSheetGame: TTabSheet;
		TabSheetView: TTabSheet;
		TrackBarTime: TTrackBar;
		procedure BitBtnApplyClick(Sender: TObject);
		procedure BitBtnOKClick(Sender: TObject);
		procedure CheckBoxTimeNoLimitClick(Sender: TObject);
		procedure ComboBoxFontNameChange(Sender: TObject);
		procedure ComboBoxFontTitleChange(Sender: TObject);
		procedure EditBackgroundChange(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure RadioButtonBackgroundClick(Sender: TObject);
		procedure RadioButtonBackgroundUserDefineClick(Sender: TObject);
		procedure RadioButtonBlackComputerClick(Sender: TObject);
		procedure RadioButtonBlackManClick(Sender: TObject);
		procedure RadioButtonWhiteComputerClick(Sender: TObject);
		procedure RadioButtonWhiteManClick(Sender: TObject);
		procedure SpeedButtonBackgroundBrowseClick(Sender: TObject);
		procedure TrackBarTimeChange(Sender: TObject);
	private
		{ Private declarations }
		function ApplySetting: Boolean;
		procedure UpdateFontList;
		procedure WMFontChange(var Msg: TWMFontChange); message WM_FONTCHANGE;
	public
		{ Public declarations }
	end;

var
	OptionBox: TOptionBox;

implementation

uses
	Main;

{$R *.DFM}

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer): Integer; stdcall;
begin
	if LogFont.lfCharSet = GB2312_CHARSET then
	begin
		TOptionBox(Data).ComboBoxFontTitle.Items.Add(LogFont.lfFaceName);
		TOptionBox(Data).ComboBoxFontName.Items.Add(LogFont.lfFaceName)
	end;
	Result := 1;
end;

procedure TOptionBox.BitBtnApplyClick(Sender: TObject);
begin
	ApplySetting
end;

procedure TOptionBox.BitBtnOKClick(Sender: TObject);
begin
	if not ApplySetting then
	begin
		OptionBox.ModalResult := mrNone;
		Exit
	end;
	MainForm.SaveSetting
end;

procedure TOptionBox.CheckBoxTimeNoLimitClick(Sender: TObject);
begin
	TrackBarTime.Enabled := not CheckBoxTimeNoLimit.Checked;
	LabelTimeShort.Enabled := not CheckBoxTimeNoLimit.Checked;
	LabelTimeLong.Enabled := not CheckBoxTimeNoLimit.Checked;
	LabelTimeLimit.Enabled := not CheckBoxTimeNoLimit.Checked
end;

procedure TOptionBox.ComboBoxFontNameChange(Sender: TObject);
begin
	LabelFontName.Font.Name := ComboBoxFontName.Items.Strings[ComboBoxFontName.ItemIndex]
end;

procedure TOptionBox.ComboBoxFontTitleChange(Sender: TObject);
begin
	LabelFontTitle.Font.Name := ComboBoxFontTitle.Items.Strings[ComboBoxFontTitle.ItemIndex]
end;

procedure TOptionBox.EditBackgroundChange(Sender: TObject);
begin
	RadioButtonBackgroundUserDefine.Checked := True
end;

procedure TOptionBox.FormCreate(Sender: TObject);
begin
	UpdateFontList;
	case MainForm.BackgroundType of
		bkNone: RadioButtonBackgroundNone.Checked := True;
		bkDefault: RadioButtonBackgroundDefault.Checked := True;
		bkUserDefine: RadioButtonBackgroundUserDefine.Checked := True
	end;
	case MainForm.BackgroundMode of
		bkTile: RadioButtonBackgroundTile.Checked := True;
		bkCenter: RadioButtonBackgroundCenter.Checked := True;
		bkStretch: RadioButtonBackgroundStretch.Checked := True
	end;
	EditBackground.Text := MainForm.BackgroundBitmap;
	CheckBoxDisplayTool.Checked := spTool in MainForm.ShowPart;
	CheckBoxDisplayStatus.Checked := spStatus in MainForm.ShowPart;
	CheckBoxDisplayTitle.Checked := spTitle in MainForm.ShowPart;
	CheckBoxDisplayName.Checked := spName in MainForm.ShowPart;
	CheckBoxDisplayClock.Checked := spClock in MainForm.ShowPart;
	CheckBoxDisplayRowCol.Checked := spRowCol in MainForm.ShowPart;
	CheckBoxShowHintTool.Checked := shTool in MainForm.ShowHintPart;
	CheckBoxShowHintStatus.Checked := shStatus in MainForm.ShowHintPart;
	CheckBoxShowHintTitle.Checked := shTitle in MainForm.ShowHintPart;
	CheckBoxShowHintName.Checked := shName in MainForm.ShowHintPart;
	CheckBoxShowHintClock.Checked := shClock in MainForm.ShowHintPart;
	ComboBoxFontTitle.ItemIndex := ComboBoxFontTitle.Items.IndexOf(MainForm.TitleFont);
	ComboBoxFontName.ItemIndex := ComboBoxFontName.Items.IndexOf(MainForm.NameFont);
	LabelFontTitle.Font.Name := ComboBoxFontTitle.Items.Strings[ComboBoxFontTitle.ItemIndex];
	LabelFontName.Font.Name := ComboBoxFontName.Items.Strings[ComboBoxFontName.ItemIndex];
	EditBlackName.Text := MainForm.PlayerName[cmBlack];
	EditWhiteName.Text := MainForm.PlayerName[cmWhite];
	case MainForm.InputDevice[cmBlack] of
		idMouse, idDirection, idLetter: RadioButtonBlackMan.Checked := True;
		idComputer: RadioButtonBlackComputer.Checked := True
	end;
	case MainForm.InputDevice[cmWhite] of
		idMouse, idDirection, idLetter: RadioButtonWhiteMan.Checked := True;
		idComputer: RadioButtonWhiteComputer.Checked := True
	end;
	case MainForm.InputDevice[cmBlack] of
		idMouse, idComputer: ComboBoxBlackInput.ItemIndex := 0;
		idDirection: ComboBoxBlackInput.ItemIndex := 1;
		idLetter: ComboBoxBlackInput.ItemIndex := 2
	end;
	case MainForm.InputDevice[cmWhite] of
		idMouse, idComputer: ComboBoxWhiteInput.ItemIndex := 0;
		idDirection: ComboBoxWhiteInput.ItemIndex := 1;
		idLetter: ComboBoxWhiteInput.ItemIndex := 2
	end;
	ComboBoxBlackLevel.ItemIndex := MainForm.Level[cmBlack];
	ComboBoxWhiteLevel.ItemIndex := MainForm.Level[cmWhite];
	CheckBoxTimeNoLimit.Checked := MainForm.TimeLimit = 0;
	if MainForm.TimeLimit <> 0 then TrackBarTime.Position := MainForm.TimeLimit;
	LabelTimeLimit.Caption := IntToStr(TrackBarTime.Position) + ' 分钟';
	LabelTimeLimit.Hint := IntToStr(TrackBarTime.Position) + ' 分钟|调整比赛限时。'
end;

procedure TOptionBox.RadioButtonBackgroundClick(Sender: TObject);
begin
	RadioButtonBackgroundTile.Checked := True;
	EditBackground.Enabled := False;
	LabelBackgroundMode.Enabled := False;
	RadioButtonBackgroundTile.Enabled := False;
	RadioButtonBackgroundCenter.Enabled := False;
	RadioButtonBackgroundStretch.Enabled := False;
	SpeedButtonBackgroundBrowse.Enabled := False
end;

procedure TOptionBox.RadioButtonBackgroundUserDefineClick(Sender: TObject);
begin
	EditBackground.Enabled := True;
	LabelBackgroundMode.Enabled := True;
	RadioButtonBackgroundTile.Enabled := True;
	RadioButtonBackgroundCenter.Enabled := True;
	RadioButtonBackgroundStretch.Enabled := True;
	SpeedButtonBackgroundBrowse.Enabled := True;
	try ActiveControl := EditBackground except end
end;

procedure TOptionBox.RadioButtonBlackComputerClick(Sender: TObject);
begin
	EditBlackName.Enabled := False;
	ComboBoxBlackInput.Enabled := False;
	LabelBlackName.Enabled := False;
	LabelBlackInput.Enabled := False;
	ComboBoxBlackLevel.Enabled := True;
	LabelBlackLevel.Enabled := True
end;

procedure TOptionBox.RadioButtonBlackManClick(Sender: TObject);
begin
	EditBlackName.Enabled := True;
	ComboBoxBlackInput.Enabled := True;
	LabelBlackName.Enabled := True;
	LabelBlackInput.Enabled := True;
	ComboBoxBlackLevel.Enabled := False;
	LabelBlackLevel.Enabled := False
end;

procedure TOptionBox.RadioButtonWhiteComputerClick(Sender: TObject);
begin
	EditWhiteName.Enabled := False;
	ComboBoxWhiteInput.Enabled := False;
	LabelWhiteName.Enabled := False;
	LabelWhiteInput.Enabled := False;
	ComboBoxWhiteLevel.Enabled := True;
	LabelWhiteLevel.Enabled := True
end;

procedure TOptionBox.RadioButtonWhiteManClick(Sender: TObject);
begin
	EditWhiteName.Enabled := True;
	ComboBoxWhiteInput.Enabled := True;
	LabelWhiteName.Enabled := True;
	LabelWhiteInput.Enabled := True;
	ComboBoxWhiteLevel.Enabled := False;
	LabelWhiteLevel.Enabled := False
end;

procedure TOptionBox.SpeedButtonBackgroundBrowseClick(Sender: TObject);
begin
	OpenPictureDialog.FileName := EditBackground.Text;
	OpenPictureDialog.Execute;
	EditBackground.Text := OpenPictureDialog.FileName
end;

procedure TOptionBox.TrackBarTimeChange(Sender: TObject);
begin
	LabelTimeLimit.Caption := IntToStr(TrackBarTime.Position) + ' 分钟';
	LabelTimeLimit.Hint := IntToStr(TrackBarTime.Position) + ' 分钟|调整比赛限时。'
end;

function TOptionBox.ApplySetting: Boolean;
var
	Flag: Boolean;
	I: Integer;
	PlayerName: WideString;
begin
	ApplySetting := False;
	PlayerName := EditBlackName.Text;
	Flag := False;
	for I := 1 to Length(PlayerName) do
		if (PlayerName[I] >= #0) and (PlayerName[I] <= #255) then Flag := True;
	if not (Length(PlayerName) in [2..4]) or Flag then
	begin
		Application.MessageBox('黑方姓名无效。' + #13#10 + '姓名必须为二到四个全角字符。', '黑白棋', MB_ICONINFORMATION);
		Exit
	end;
	if (PlayerName = '计算机') and (not RadioButtonBlackComputer.Checked) then
	begin
		Application.MessageBox('不能以“计算机”作为黑方姓名。', '黑白棋', MB_OK or MB_ICONINFORMATION);
		Exit
	end;
	PlayerName := EditWhiteName.Text;
	Flag := False;
	for I := 1 to Length(PlayerName) do
		if (PlayerName[I] >= #0) and (PlayerName[I] <= #255) then Flag := True;
	if not (Length(PlayerName) in [2..4]) or Flag then
	begin
		Application.MessageBox('白方姓名无效。' + #13#10 + '姓名必须为二到四个全角字符。', '黑白棋', MB_ICONINFORMATION);
		Exit
	end;
	if (PlayerName = '计算机') and (not RadioButtonWhiteComputer.Checked) then
	begin
		Application.MessageBox('不能以“计算机”作为白方姓名。', '黑白棋', MB_OK or MB_ICONINFORMATION);
		Exit
	end;
	ApplySetting := True;
	if RadioButtonBackgroundNone.Checked then MainForm.BackgroundType := bkNone;
	if RadioButtonBackgroundDefault.Checked then MainForm.BackgroundType := bkDefault;
	if RadioButtonBackgroundUserDefine.Checked then MainForm.BackgroundType := bkUserDefine;
	if RadioButtonBackgroundTile.Checked then MainForm.BackgroundMode := bkTile;
	if RadioButtonBackgroundCenter.Checked then MainForm.BackgroundMode := bkCenter;
	if RadioButtonBackgroundStretch.Checked then MainForm.BackgroundMode := bkStretch;
	MainForm.BackgroundBitmap := EditBackground.Text;
	MainForm.ShowPart := [];
	if CheckBoxDisplayTool.Checked then MainForm.ShowPart := MainForm.ShowPart + [spTool];
	if CheckBoxDisplayStatus.Checked then MainForm.ShowPart := MainForm.ShowPart + [spStatus];
	if CheckBoxDisplayTitle.Checked then MainForm.ShowPart := MainForm.ShowPart + [spTitle];
	if CheckBoxDisplayName.Checked then MainForm.ShowPart := MainForm.ShowPart + [spName];
	if CheckBoxDisplayClock.Checked then MainForm.ShowPart := MainForm.ShowPart + [spClock];
	if CheckBoxDisplayRowCol.Checked then MainForm.ShowPart := MainForm.ShowPart + [spRowCol];
	MainForm.ShowHintPart := [];
	if CheckBoxShowHintTool.Checked then MainForm.ShowHintPart := MainForm.ShowHintPart + [shTool];
	if CheckBoxShowHintStatus.Checked then MainForm.ShowHintPart := MainForm.ShowHintPart + [shStatus];
	if CheckBoxShowHintTitle.Checked then MainForm.ShowHintPart := MainForm.ShowHintPart + [shTitle];
	if CheckBoxShowHintName.Checked then MainForm.ShowHintPart := MainForm.ShowHintPart + [shName];
	if CheckBoxShowHintClock.Checked then MainForm.ShowHintPart := MainForm.ShowHintPart + [shClock];
	if ComboBoxFontTitle.ItemIndex >= 0 then MainForm.TitleFont := ComboBoxFontTitle.Items.Strings[ComboBoxFontTitle.ItemIndex];
	if ComboBoxFontName.ItemIndex >= 0 then MainForm.NameFont := ComboBoxFontName.Items.Strings[ComboBoxFontName.ItemIndex];
	MainForm.PlayerName[cmBlack] := EditBlackName.Text;
	MainForm.PlayerName[cmWhite] := EditWhiteName.Text;
	if RadioButtonBlackMan.Checked then
		case ComboBoxBlackInput.ItemIndex of
			0: MainForm.InputDevice[cmBlack] := idMouse;
			1: MainForm.InputDevice[cmBlack] := idDirection;
			2: MainForm.InputDevice[cmBlack] := idLetter
		end
	else
		MainForm.InputDevice[cmBlack] := idComputer;
	if RadioButtonWhiteMan.Checked then
		case ComboBoxWhiteInput.ItemIndex of
			0: MainForm.InputDevice[cmWhite] := idMouse;
			1: MainForm.InputDevice[cmWhite] := idDirection;
			2: MainForm.InputDevice[cmWhite] := idLetter
		end
	else
		MainForm.InputDevice[cmWhite] := idComputer;
	MainForm.Level[cmBlack] := ComboBoxBlackLevel.ItemIndex;
	MainForm.Level[cmWhite] := ComboBoxWhiteLevel.ItemIndex;
	if CheckBoxTimeNoLimit.Checked then
		MainForm.TimeLimit := 0
	else
		MainForm.TimeLimit := TrackBarTime.Position;
	if RadioButtonBlackComputer.Checked then MainForm.PlayerName[cmBlack] := '计算机';
	if RadioButtonWhiteComputer.Checked then MainForm.PlayerName[cmWhite] := '计算机';
	MainForm.UpdateSetting
end;

procedure TOptionBox.UpdateFontList;
var
	DC: HDC;
begin
	ComboBoxFontTitle.Clear;
	ComboBoxFontName.Clear;
	DC := GetDC(0);
	EnumFonts(DC, nil, @EnumFontsProc, Pointer(Self));
	ReleaseDC(0, DC)
end;

procedure TOptionBox.WMFontChange(var Msg: TWMFontChange);
begin
	inherited;
	UpdateFontList
end;

end.

