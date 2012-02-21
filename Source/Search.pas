unit Search;

interface

uses
	Windows, Classes, Main;

type
	PSearchNode = ^TSearchNode;
	TSearchNode = class(TPersistent)
	public
		Value: Integer;
		ExtremeValue: Integer;
		Depth: Integer;
		DepthLimit: Integer;
		ChildrenCount: Integer;
		PlayerGo: TChessman;
		InversePlayer: TChessman;
		Point: TPoint;
		Parent: PSearchNode;
		Chessboard: TChessboard;
		Children: array[0..7, 0..7] of PSearchNode;
		constructor Create(AParent: PSearchNode; X, Y, MaxDepth: Integer; CurPlayer: TChessman; var CurChessboard: TChessboard);
		function CanDrop(X, Y: Integer; CurPlayer: TChessman): Boolean;
		procedure ComputerDrop;
	end;

implementation

constructor TSearchNode.Create(AParent: PSearchNode; X, Y, MaxDepth: Integer; CurPlayer: TChessman; var CurChessboard: TChessboard);
var
	Flag: Boolean;
	I, J: Integer;
begin
	inherited Create;
	Parent := AParent;
	Point.X := X;
	Point.Y := Y;
	PlayerGo := CurPlayer;
	case PlayerGo of
		cmBlack: InversePlayer := cmWhite;
		cmWhite: InversePlayer := cmBlack;
		else InversePlayer := PlayerGo
	end;
	ExtremeValue := 0;
	DepthLimit := MaxDepth;
	FillChar(Children, SizeOf(Children), 0);
	Chessboard := CurChessboard;
	if not Assigned(Parent) then
	begin
		Depth := 1;
	end
	else
	begin
		Depth := Parent^.Depth + 1;
		ComputerDrop
	end;
	ChildrenCount := 0;
	Flag := False;
	if Depth <= DepthLimit then
	begin
		for I := 0 to 7 do
		begin
			for J := 0 to 7 do
				if CanDrop(I, J, InversePlayer) then
				begin
					Inc(ChildrenCount);
					New(Children[I, J]);
					Children[I, J]^ := TSearchNode.Create(@Self, I, J, DepthLimit, InversePlayer, Chessboard);
					//¦Á£­¦Â¼ôÖ¦
					if Assigned(Parent) then
					begin
						if Children[I, J]^.PlayerGo = MainForm.PlayerGo then
						begin
							if Children[I, J]^.Value > Parent^.ExtremeValue then
							begin
								Flag := True;
								Break
							end;
							if Children[I, J]^.Value > ExtremeValue then ExtremeValue := Children[I, J]^.Value
						end
						else
						begin
							if Children[I, J]^.Value < Parent^.ExtremeValue then
							begin
								Flag := True;
								Break
							end;
							if Children[I, J]^.Value < ExtremeValue then ExtremeValue := Children[I, J]^.Value
						end
					end
				end;
			if Flag then Break
		end;
		if ChildrenCount = 0 then
			for I := 0 to 7 do
				for J := 0 to 7 do
					if CanDrop(I, J, PlayerGo) then
					begin
						Inc(ChildrenCount);
						New(Children[I, J]);
						Children[I, J]^ := TSearchNode.Create(@Self, I, J, DepthLimit, PlayerGo, Chessboard)
					end
	end;
	if ChildrenCount = 0 then
	begin
		Value := 0;
		for I := 0 to 7 do
			for J := 0 to 7 do
			begin
				if Chessboard[I, J] = PlayerGo then
				begin
					Inc(Value, 10);
					if (I = 0) or (I = 7) or (J = 0) or (J = 7) then
					begin
						Inc(Value);
						if ((I = 0) and (J = 0)) or ((I = 0) and (J = 7)) or ((I = 7) and (J = 0)) or ((I = 7) and (J = 7)) then Inc(Value, 4)
					end
				end;
				if Chessboard[I, J] = InversePlayer then
				begin
					Dec(Value, 10);
					if (I = 0) or (I = 7) or (J = 0) or (J = 7) then
					begin
						Dec(Value);
						if ((I = 0) and (J = 0)) or ((I = 0) and (J = 7)) or ((I = 7) and (J = 0)) or ((I = 7) and (J = 7)) then Dec(Value, 4)
					end
				end
			end
	end
	else
	begin
		Value := -1000;
		for I := 0 to 7 do
			for J := 0 to 7 do
				if Assigned(Children[I, J]) then
					if Children[I, J]^.PlayerGo = PlayerGo then
					begin
						if Children[I, J]^.Value > Value then
							Value := Children[I, J]^.Value
					end
					else
					begin
						if -Children[I, J]^.Value > Value then
							Value := -Children[I, J]^.Value
					end
	end;
	if Assigned(Parent) then
		for I := 0 to 7 do
			for J := 0 to 7 do
				if Assigned(Children[I, J]) then
				begin
					Children[I, J]^.Free;
					Dispose(Children[I, J])
				end
end;

function TSearchNode.CanDrop(X, Y: Integer; CurPlayer: TChessman): Boolean;
var
	I, CX, CY: Integer;
	Inverse: TChessman;
begin
	MainForm.DoEvents;
	CanDrop := False;
	if Chessboard[X, Y] <> cmNone then Exit;
	case CurPlayer of
		cmBlack: Inverse := cmWhite;
		cmWhite: Inverse := cmBlack;
		else Inverse := CurPlayer
	end;
	for I := 0 to 7 do
	begin
		CX := X + Direction[I].X;
		CY := Y + Direction[I].Y;
		if Chessboard[CX, CY] = Inverse then
		begin
			repeat
				Inc(CX, Direction[I].X);
				Inc(CY, Direction[I].Y)
			until Chessboard[CX, CY] <> Inverse;
			if Chessboard[CX, CY] = CurPlayer then
			begin
				CanDrop := True;
				Break
			end
		end
	end
end;

procedure TSearchNode.ComputerDrop;
var
	I, J, N, CX, CY: Integer;
begin
	MainForm.DoEvents;
	Chessboard[Point.X, Point.Y] := PlayerGo;
	for I := 0 to 7 do
	begin
		CX := Point.X + Direction[I].X;
		CY := Point.Y + Direction[I].Y;
		if Chessboard[CX, CY] = InversePlayer then
		begin
			N := 0;
			repeat
				CX := CX + Direction[I].X;
				CY := CY + Direction[I].Y;
				Inc(N)
			until Chessboard[CX, CY] <> InversePlayer;
			if Chessboard[CX, CY] = PlayerGo then
			begin
				CX := Point.X;
				CY := Point.Y;
				for J := 1 to N do
				begin
					CX := CX + Direction[I].X;
					CY := CY + Direction[I].Y;
					Chessboard[CX, CY] := PlayerGo;
				end
			end
		end
	end
end;

end.
