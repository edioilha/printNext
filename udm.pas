unit uDM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql51conn, sqldb, db, FileUtil, PrintersDlgs,
  ZConnection, ZDataset, LR_DBSet, LR_Class, LR_Desgn, IniFiles, Dialogs;

type

  { TDM }

  TDM = class(TDataModule)
    DSOrcamento: TDataSource;
    frDBDataSet: TfrDBDataSet;
    frDesigner: TfrDesigner;
    frReport: TfrReport;
    PrintDialog: TPrintDialog;
    SQLQueryOrcamentocodOrc: TLongintField;
    SQLQueryOrcamentodsccodfabricante: TStringField;
    SQLQueryOrcamentoendereco: TStringField;
    SQLQueryOrcamentoitCod: TLongintField;
    SQLQueryOrcamentonome: TStringField;
    SQLQueryOrcamentopcounitario: TBCDField;
    SQLQueryOrcamentoproDesc: TStringField;
    SQLQueryOrcamentoquantidade: TBCDField;
    SQLQueryOrcamentounidDesc: TStringField;
    SQLQueryOrcamentovalortotal: TBCDField;
    SQLQueryOrcamentovlrdesconto: TBCDField;
    ZConn: TZConnection;
    ZQueryOrcamento: TZQuery;
    ZQueryOrcamentocodOrc: TLongintField;
    ZQueryOrcamentodsccodfabricante: TStringField;
    ZQueryOrcamentoendereco: TStringField;
    ZQueryOrcamentoitCod: TLongintField;
    ZQueryOrcamentonome: TStringField;
    ZQueryOrcamentopcounitario: TFloatField;
    ZQueryOrcamentoproDesc: TStringField;
    ZQueryOrcamentoquant: TFloatField;
    ZQueryOrcamentounidDesc: TStringField;
    ZQueryOrcamentovalortotal: TFloatField;
    ZQueryOrcamentovlrdesconto: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DSOrcamentoStateChange(Sender: TObject);
  private
    { private declarations }
    var INI:TIniFile;
    var userName, pass, dbName, hostN: String;
    const C_DB_SECTION = 'DB-INFO';
  public
    { public declarations }
  end;

var
  DM: TDM;

implementation
uses uPrincipal;

{$R *.lfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  //{TODO} Criar metodo
  // Carrega as configurações do banco de dados
  INI := TIniFile.Create('DB.ini');
  Try
    userName := INI.ReadString(C_DB_SECTION, 'user', '');
    pass     := INI.ReadString(C_DB_SECTION, 'password', '$enha');
    dbName   := INI.ReadString(C_DB_SECTION, 'dbname', '');
    hostN    := INI.ReadString(C_DB_SECTION, 'hostname', '');
  finally
    INI.Free;
  end;
  //{TODO} criar um metodo
  //
  try
    if ZConn.Connected then ZConn.Connected:=False;
    with ZConn do
    Begin
      User      := userName;
      Password  := pass;
      Database  := dbName;
      HostName  := hostN;
      Connected := True;
    end;
  except
    on E : Exception do
    begin
      ShowMessage(E.ClassName+' erro ao conectar no banco : '+E.Message);
       frmPrincipal.Close;
    end
  end;
    //fim config banco
end;

procedure TDM.DSOrcamentoStateChange(Sender: TObject);
begin
  frmPrincipal.btnVisualizar.Enabled:= ZQueryOrcamento.State = dsBrowse;
  frmPrincipal.btnImprimir.Enabled:= ZQueryOrcamento.State = dsBrowse;
end;


end.

