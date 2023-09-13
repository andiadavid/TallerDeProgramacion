program parcial2;
type
    meses=1..12;
    reg=record
        codigo:integer;
        mes:meses;
        monto:real;
    end;

    gastoMensaul = array [1..12] of real;
    compra = record
        codigo: integer;
        total: gastoMensaul;
    end;
    arbol = ^nodo;
    nodo = record
        dato: compra;
        HI:arbol;
        HD:arbol;
    end;

//-------------------------------------------
procedure cargarArbol (var a:arbol);

    procedure inicialVector (var g:gastoMensaul);
    var  i: integer;
    begin
        for i:=1 to 12 do
            g[i]:=0;
    end;
    procedure leerCompra(var c: reg);
    begin
        //Write('ingresa cod<>1: ');read(c.codigo);
        c.codigo:=Random(10);
        if(c.codigo <> 1 ) then begin
            //Write('monto: ');read(c.monto);
            c.monto:=Random(100)/(Random(10)+1);
            //Write('mes: ');read(c.mes);
            c.mes:= Random(12)+1;
        end;
    end;
    procedure armarCompra (var c:compra; r:reg);
    begin
        c.codigo:=r.codigo;
        inicialVector(c.total);
        c.total[r.mes]:= c.total[r.mes] + r.monto;
    end;
    procedure insertarElemento (var ar:arbol; r:reg);       
    var c:compra;
    begin
        if(ar= nil) then begin
            new(ar);
            armarCompra(c,r);
            ar^.dato:=c;
            ar^.HI:=nil;
            ar^.HD:=nil;
        end
        else begin
            if(ar^.dato.codigo = r.codigo)then begin
                ar^.dato.total[r.mes]:= ar^.dato.total[r.mes] + r.monto;
            end
            else begin
                if(r.codigo < ar^.dato.codigo)then
                    insertarElemento(ar^.HI, r)
                else if(r.codigo > ar^.dato.codigo)then
                    insertarElemento(ar^.HD, r);
            end;    
        end
    end;

var r:reg;
begin
    leerCompra(r);
    while(r.codigo <> 1) do begin
        insertarElemento(a,r);
        leerCompra(r);
    end;
end;
//--------------------------imprimir
procedure imprimirA(a:arbol);
    procedure imprimirV(v:gastoMensaul);
    var i:Integer;
    begin
      for i:=1 to 12 do 
        if(v[i]<>0)then
            WriteLn('mes ',i,' tiene ',v[i]:2:2,',');
    end;
begin
    if(a<>nil)then begin
        if(a^.HI<>nil)then imprimirA(a^.HI);
        WriteLn('codigo',a^.dato.codigo);
        imprimirV(a^.dato.total);
        if(a^.HD<>nil)then imprimirA(a^.HD);
    end;
end;
//inciso b. busqueda------------------
procedure incisoB(a:arbol);
    function maximo(v:gastoMensaul):Integer;
    var max:Real;
        i,imax:Integer;
    begin
        max:=-999;
        for i:=1 to 12 do begin
          if(v[i]>max)then begin
            max:=v[i];
            imax:=i;
          end;  
        end;
        maximo:=imax;      
    end;
  function buscarMes(a: arbol; cod:Integer): integer;
  begin
    if (a = nil) then 
      buscarMes:= -1
    else if (a^.dato.codigo= cod) then 
            buscarMes:= maximo(a^.dato.total)
         else if(cod<a^.dato.codigo)then
                buscarMes:= buscarMes(a^.HI,cod)
            else 
                buscarMes:= buscarMes(a^.HD,cod);
  end;
   
var max:integer;
    cod:integer;
begin
    write('codCliente: ');read(cod);
    max:=buscarMes(a,cod);
    if (max = -1) then 
        writeln ('no existe el cliente: ',cod)
    else begin
            writeln ('el mes q mas gasto el cliente ',cod,', fue: ',max);
        end;
end;
//inciso C. busqueda cant de clientes------------------
procedure incisoC(a:arbol);
    
  procedure buscarG(a: arbol; mes:integer; var cont:integer);
  begin
    if (a <> nil) then begin
        buscarG(a^.HI,mes,cont);
        if (a^.dato.total[mes]=0) then 
                cont:=cont +1;
        buscarG(a^.HD,mes,cont);
    end;            
  end;
   
var cant:integer;
    mes:integer;
begin
    write('mes: ');read(mes);
    cant:=0;
    buscarG(a,mes,cant);
    if (cant= 0) then 
        writeln ('todos los clientes gastaron el mes: ',mes)
    else begin
            writeln ('cant clientes q NO gastaron en ',mes,', fue: ',cant);
        end;
end;

//----------------------------pp
var a:arbol;
    cod:Integer;
begin
    WriteLn('----------------carga de arbol y vector');
    cargarArbol(a);
    WriteLn('----------------imprimir arbol y vector');
    imprimirA(a);
    WriteLn('---------mes de mayor gasto de un cliente:');
    incisoB(a);
    WriteLn('--------cant clientes que no gastaron un mes especifico:');
    incisoC(a);    
    Write('finPrograma');
end.