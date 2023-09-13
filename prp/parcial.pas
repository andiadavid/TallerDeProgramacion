program parcial;
type
  pedido=record //pedidos
    numC:integer;
    dia:Integer;
    cantCom:Integer;
    monto:real;
  end;

  regL=record
    dia:Integer;
    cantCom:Integer;
    monto:real;
  end;
  lista=^nodoL;
  nodoL=record
    dato:regL;
    sig:lista;
  end;  
  arbol=^nodo;
  nodo=record
    numC:integer;
    listaP:lista;
    HI:arbol;
    HD:arbol;
  end;  
//PROCESOS-------------------------------------------
//generar arbol, leer pedido numC<>0
procedure moduloA(var a:arbol);
    procedure leerP(var p:pedido);
    begin
      p.numC:=Random(10);
      writeln('numCliente <>0 :',p.numC);
      if(p.numC<>0)then begin
        p.dia:=Random(32);
        write('dia:',p.dia);
        p.cantCom:=1+ Random(20);
        write(', cantCombos:',p.cantCom);
        p.monto:=100.50+ Random(3000);
        writeln(', monto:',p.monto:2:2);
      end;
    end;
    procedure agregarAdelante(var l:lista; r:regL);
    var nue:lista;
    begin
      new(nue);
      nue^.dato:=r;
      nue^.sig:=l;
      l:=nue;
    end;
    procedure insertarA(var a:arbol; p:pedido);
        procedure generarREG(var r:regL; p:pedido);
        begin
            r.dia:=p.dia;
            r.cantCom:=p.cantCom;
            r.monto:=p.monto;
        end;
    var r:regL;
    begin
      if(a=Nil)then begin
        new(a);
        a^.numC:=p.numC;
        a^.listaP:=nil;
        generarREG(r,p);
        agregarAdelante(a^.listaP,r);
        a^.HI:=nil;
        a^.HD:=nil;
      end
      else if(p.numC= a^.numC)then begin
              generarREG(r,p);
              agregarAdelante(a^.listaP,r);
          end
          else if(p.numC< a^.numC)then
                  insertarA(a^.HI,p)
               else if(p.numC> a^.numC)then
                       insertarA(a^.HD,p);   

    end;
var p:pedido;
begin
    leerP(p);
    while(p.numC<>0)do begin
      insertarA(a,p);
      leerP(p);
    end;
end;
//imprimir --------------------
procedure imprimirL(l:lista);
  begin
    if(l<>Nil)then begin
      Write('dia:',l^.dato.dia);
      Write(', cantCombos:',l^.dato.cantCom);
      Writeln(', monto:',l^.dato.monto:2:2);
      imprimirL(l^.sig);
    end;
  end;
procedure imprimirA(a:arbol);  
begin
  if(a<>Nil)then begin
    if(a^.HI<>nil)then imprimirA(a^.HI);
    Writeln('--codCliente: ',a^.numC);
    imprimirL(a^.listaP);
    if(a^.HD<>nil)then imprimirA(a^.HD);
  end;
end;
//B buscar los pedidos del cliente con cod recibido como parametro----
function moduloB(a:arbol; cod:Integer):lista;
begin
  if(a<>Nil)then begin
    if(a^.numC= cod)then
      moduloB:=a^.listaP;
    if(a^.numC> cod)then moduloB:=moduloB(a^.HI,cod);
    if(a^.numC< cod)then moduloB:=moduloB(a^.HD,cod);
  end
  else moduloB:=nil;
end;
//C suma monto total de la lista
function moduloC(l:lista):real;
begin
  if(l<>Nil)then begin
    moduloC:=l^.dato.monto+ moduloC(l^.sig);
  end
  else moduloC:=0;
end;
{
procedure moduloC(l:lista;var aux:real);
begin
  if(l<>nil)then begin   
    Write('monto',l^.dato.monto:2:2);
    aux:=aux+ l^.dato.monto;
    l:=l^.sig;
    moduloC(l,aux);
  end;
end;
}

//PP-------------------------------------------------

var a:arbol;
    cod:Integer;
    listaPedidos:lista;
    monT:real;
begin
  WriteLn('-------------generarArbol: ');
  moduloA(a);
  WriteLn('-------------arbol y listas: ');
  imprimirA(a);
  WriteLn('-------------buscar los pedidos q realizo un cliente :');
  write('cod de cliente a buscar');read(cod);
  listaPedidos:=moduloB(a,cod);
  imprimirL(listaPedidos);
  WriteLn('-------------retornar montoTotal abonado por el cliente: ');
  monT:=0;
  //moduloC(listaPedidos,monT);
  monT:=moduloC(listaPedidos);
  WriteLn('monto total: ',monT:2:2); 
end.
