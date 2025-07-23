program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

const usuarioAdmin: String = 'admin';
      senhaAdmin: String = 'admin';

procedure ExibirMenu(autenticado: Boolean); forward;
function LoginValido(usuario, senha: String): Boolean; forward
function RealizarLogin: Boolean; forward
procedure ChamarOpcao(op: Integer; autenticado: Boolean); forward
procedure LimparConsole; forward

procedure LimparConsole;
var
  hConsole: THandle;
  screenBufferInfo: CONSOLE_SCREEN_BUFFER_INFO;
  cellsWritten: DWORD;
  consoleSize: DWORD;
  topLeft: COORD;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(hConsole, screenBufferInfo);
  consoleSize := screenBufferInfo.dwSize.X * screenBufferInfo.dwSize.Y;
  topLeft.X := 0;
  topLeft.Y := 0;
  FillConsoleOutputCharacter(hConsole, ' ', consoleSize, topLeft, cellsWritten);
  FillConsoleOutputAttribute(hConsole, screenBufferInfo.wAttributes, consoleSize, topLeft, cellsWritten);
  SetConsoleCursorPosition(hConsole, topLeft);
end;

procedure ExibirMenu(autenticado: Boolean);
begin
  if autenticado then begin
    Writeln('|------- Menu -------|');
    Writeln('| 1 - Exibir segredo |');
    Writeln('| 2 - Deslogar       |');
    Writeln('| 9 - Sair           |');
    Writeln('|--------------------|' + sLineBreak);
  end else begin
    Writeln('|------- Menu -------|');
    Writeln('| 1 - Realizar Login |');
    Writeln('| 9 - Sair           |');
    Writeln('|--------------------|' + sLineBreak);
  end;

  Write('Digite sua opção: ');
end;

function LoginValido(usuario, senha: String): Boolean;
begin
  Result := (usuario = usuarioAdmin) and (senha = senhaAdmin);
end;

function RealizarLogin: Boolean;
var usuario, senha: String;
var tentativas: Integer;
begin
  LimparConsole;
  tentativas := 0;
  while tentativas < 3 do begin
    Write('Digite seu usuário: ');
    Readln(usuario);
    Write('Digite sua senha: ');
    Readln(senha);

    if LoginValido(usuario, senha) then begin
      Writeln('Autenticado com sucesso' + sLineBreak);
      Result := true;
      Exit;
    end else begin
      Writeln('Credenciais incorretas' + sLineBreak);
      tentativas := tentativas + 1;
      Writeln('Tentativas restantes: ', 3 - tentativas);
    end;
  end;
  Result := false;
end;

procedure ChamarOpcao(op: Integer; autenticado: Boolean);
begin
end;

var temp: String;
var op: Integer;
var autenticado: Boolean = false;
begin
  try
    while True do begin
      LimparConsole;
      ExibirMenu(autenticado);

      try
        Readln(op);      
      except
        on e: EInOutError do begin
          Writeln('Opção inválida' + sLineBreak);
          Sleep(1000);
          continue;
        end;
      end;

      case op of
        1: begin
          if autenticado then begin
            writeln(sLineBreak + 'segredo: asjfh9ashf09ka329af02u9ae02ma' + sLineBreak);
          end else begin
            autenticado := RealizarLogin;
            if not autenticado then Exit;
          end;
        end;
        2: begin
          if autenticado then begin
            autenticado := false;
            Writeln('Você foi desconectado' + sLineBreak);
          end else Writeln('Opção inválida' + sLineBreak);
        end;
        9: begin
          Writeln('Encerrando...');
          Sleep(750);
          Exit;
        end;
        else Writeln('Opção inválida' + sLineBreak);
      end;
      Sleep(1000);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
