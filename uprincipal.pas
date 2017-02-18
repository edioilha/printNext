unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, IniFiles;

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
  DM.ZQueryOrcamento.Close;
  DM.ZQueryOrcamento.SQL.Text :='select o.codorcamento as codOrc, p.dsccodfabricante, p.descricao as proDesc, u.descricao as unidDesc,'+
                                'oi.quantidade as quant, oi.pcounitario, oi.vlrdesconto, oi.codorcamento as itCod, '+
                                'o.valortotal, tc.nome, tc.endereco '+
                                'FROM tborcamento o '+
                                'left join tborcamentoitem oi on (oi.codorcamento = o.codorcamento) '+
                                'left join tbproduto p on (p.codproduto = oi.codproduto) '+
                                'left join tbunidade u on (u.codunidade = p.codunidade) '+
                                'left join tbcliente tc on (tc.codcli = o.codcli) '+
                                'where o.codorcamento = :codigoOrcamento ;';

  DM.ZQueryOrcamento.ParamByName('codigoOrcamento').AsFloat:=StrToFloat(edtOrcamento.Text);
  DM.ZQueryOrcamento.Open;
end;

procedure TfrmPrincipal.btnVisualizarClick(Sender: TObject);
begin
  DM.frReport.LoadFromFile('orcamento.lrf');
  DM.frReport.ShowReport;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  edtOrcamento.SetFocus;
end;

end.

