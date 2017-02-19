unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Printers;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    BitBtnBuscar: TBitBtn;
    btnImprimir: TBitBtn;
    btnVisualizar: TBitBtn;
    DBOrcamento: TDBText;
    DBNomeCliente: TDBText;
    DBTotal: TDBText;
    edtOrcamento: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StatusBar1: TStatusBar;
    procedure BitBtnBuscarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses uDM;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TfrmPrincipal.BitBtnBuscarClick(Sender: TObject);
begin
  if (edtOrcamento.Text = '') then
  begin
     ShowMessage('Digitar um de orçamento');
     edtOrcamento.SetFocus;
     Exit;
  end;
  try
     with DM.ZQueryOrcamento do
          begin
            close;
            SQL.Text:= 'select o.codorcamento as codOrc, p.dsccodfabricante, p.descricao as proDesc, u.descricao as unidDesc,'+
                                'oi.quantidade as quant, oi.pcounitario, oi.vlrdesconto, oi.codorcamento as itCod, '+
                                'o.valortotal, tc.nome, tc.endereco '+
                                'FROM tborcamento o '+
                                'left join tborcamentoitem oi on (oi.codorcamento = o.codorcamento) '+
                                'left join tbproduto p on (p.codproduto = oi.codproduto) '+
                                'left join tbunidade u on (u.codunidade = p.codunidade) '+
                                'left join tbcliente tc on (tc.codcli = o.codcli) '+
                                'where o.codorcamento = :codigoOrcamento ;';
            ParamByName('codigoOrcamento').AsInteger:=StrToInt(edtOrcamento.Text);
            Open;
          end;
     if DM.ZQueryOrcamento.RecordCount=0 then ShowMessage('Oçamento número "'+edtOrcamento.Text+'" não encontrado');
  except
    On E: Exception do
    ShowMessage(E.ClassName+' Erro ao consultar no banco : '+E.Message);
  end;
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
var
  FromPage, ToPage, NumberCopies: Integer;
  ind: Integer;
  Collap: Boolean;
begin
  DM.frReport.LoadFromFile('orcamento.lrf');
  ind:=Printer.PrinterIndex;
  if not DM.frReport.PrepareReport then exit;
  with DM.PrintDialog do
  begin
    Options:=[poPageNums ]; // allows selecting pages/page numbers
    Copies:=1;
    Collate:=true; // ordened copies
    FromPage:=1; // start page
    ToPage:=DM.frReport.EMFPages.Count; // last page
    MaxPage:=DM.frReport.EMFPages.Count; // maximum allowed number of pages
    if Execute then // show dialog; if succesful, process user feedback
    begin
      if (Printer.PrinterIndex <> ind ) // verify if selected printer has changed
        or DM.frReport.CanRebuild // ... only makes sense if we can reformat the report
        or DM.frReport.ChangePrinter(ind, Printer.PrinterIndex) //... then change printer
        then
        DM.frReport.PrepareReport //... and reformat for new printer
      else
        exit; // we couldn't honour the printer change

      if DM.PrintDialog.PrintRange = prPageNums then // user made page range selection
      begin
        FromPage:=DM.PrintDialog.FromPage; // first page
        ToPage:=DM.PrintDialog.ToPage;  // last page
      end;
      NumberCopies:=DM.PrintDialog.Copies; // number of copies
      // Print the report using the supplied pages & copies
      DM.frReport.PrintPreparedReport(inttostr(FromPage)+'-'+inttostr(ToPage), NumberCopies);
    end;
  end;
end;

procedure TfrmPrincipal.btnVisualizarClick(Sender: TObject);
begin
  try
     with DM.frReport do
          Begin
            LoadFromFile('orcamento.lrf');
            ShowReport;
          end;
  except
    On E: Exception do
    ShowMessage(E.ClassName+' Erro ao tentar carregar Orçamento : '+E.Message);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  edtOrcamento.SetFocus;
end;

end.

