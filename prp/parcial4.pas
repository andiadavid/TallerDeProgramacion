program parcial4;
const df=12;
type
    sub_dia=1..31;
    sub_mes=1..df;
    compra=record
        codJuego:integer;
        codCliente:integer;
        dia:sub_dia;
        mes:sub_mes;
    end;

    regL=record //AI-arbol con lista ord por codCliente
        codJuego:integer;
        dia:sub_dia;
        mes:sub_mes;
    end;
    lista=^nodoL;
    nodoL=record
        dato:regL;
        sig:lista;
    end;    
    arbol=^nodo;
    nodo=record
        codCliente:integer;
        compras:lista;
        hi:arbol;
        hd:arbol;
    end;        

    vector=array[1..df]of integer;//AII-vector de meses despues se ordena 


//PROCESOS--------------------------------------------------
procedure generar(var a:arbol; var v:vector);
    procedure leerC(var c:compra);
    begin
      write('codClieente<>0:');read(c.codCliente);
      if(c.codCliente<>0)then begin
        write('codJuego:');read(c.codJuego);
        write('dia(1.31):');read(c.dia);
        write('mes(1.12):');read(c.mes);
      end;
    end;
    procedure asignarR(var r:regL; c:compra);
    begin
      r.codJuego:=c.codJuego;
      r.dia:=c.dia;
      r.mes:=c.mes;
    end;
    procedure agregarAdelante(var l:lista; r:regL);
    var nue:lista;
    begin
      new(nue);
      nue^.dato:=r;
      nue^.sig:=l;
      l:=nue;
    end;
    procedure insertarA(var a:arbol; c:compra);
    var r:regL;
    begin
      if(a=nil)then begin
        new(a);
        a^.codCliente:=c.codCliente;
        a^.compras:=nil;
        asignarR(r,c);
        agregarAdelante(a^.compras,r);
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(a^.codCliente=c.codCliente)then begin
                asignarR(r,c);
                agregarAdelante(a^.compras,r);
           end
           else if(c.codCliente<a^.codCliente)then 
                    insertarA(a^.hi,c)
                else 
                    insertarA(a^.hd,c);    
    end;
    procedure inicializarV(var v:vector);
    var i:integer;
    begin
      for i:=1 to df do
        v[i]:=0;
    end;
    procedure contarV(var v:vector; mes:integer);
    begin
      v[mes]:=v[mes]+ 1;
    end;
var c:compra;
begin
    a:=nil;
    inicializarV(v);
    leerC(c);
    while(c.codCliente<>0)do begin
      insertarA(a,c);
      contarV(v,c.mes);
      leerC(c);
    end;
end;
//imprimir arbol, lista y vector----
procedure imprimirL(l:lista);
begin
  if(l<>nil)then begin
    Write('codJuego:',l^.dato.codJuego);
    Write(' dia:',l^.dato.dia);
    WriteLn(' mes:',l^.dato.mes);
    imprimirL(l^.sig);
  end;
end;
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    imprimirA(a^.hi);
    WriteLn('--codCliente:',a^.codCliente);
    imprimirL(a^.compras);
    imprimirA(a^.hd);
  end;
end;
procedure imprimirV(v:vector);
var i:integer;
begin
  for i:=1 to df do
    if(v[i]<> 0)then 
        WriteLn('mes: ',i,' tiene: ',v[i]);
end;
//B- buscar las compras(lista) de un cliente(cod)--
procedure incisoB(a:arbol);
    function buscarCodCliente(a:arbol; cod:integer):arbol;
    begin
      if(a=nil)then
        buscarCodCliente:=nil
      else if(cod= a^.codCliente)then
                buscarCodCliente:=a
           else if(cod< a^.codCliente)then
                    buscarCodCliente:=buscarCodCliente(a^.hi,cod)
                else 
                    buscarCodCliente:=buscarCodCliente(a^.hd,cod);
    end;
var cod:integer;
    punt:arbol;
begin
    writeln('ingese un codCliente a buscar: ');read(cod);
    punt:=buscarCodCliente(a,cod); 
    if(punt=nil)then
        writeln('no existe el codCliente.')
    else begin
        writeln('la lista de compras de ',punt^.codCliente,' es: ');
        imprimirL(punt^.compras);
    end;    
end;
procedure ordenacionSeleccion(var v:vector);
var i,j,pos:integer;
    aux:integer;
begin
    for i:=1 to df-1 do begin
      pos:=i;
      for j:=i+1 to df do begin //busca el min y lo guarda en pos
        if(v[j]< v[pos])then
            pos:=j;
      end;
      aux:=v[pos]; //intercambio v[i] y v[p]
      v[pos]:=v[i];
      v[i]:=aux;
    end;
end;
procedure ordenacionInsercion(var v:vector);
var i,j,pos:integer;
    act:integer;
begin
  for i:=2 to df do begin
    act:=v[i];
    j:=i-1;
    while(j> 0)and(v[j]>act)do begin
      v[j+1]:=v[j];
      j:=j- 1;
    end;
    v[j+1]:=act;
  end;
end;

//PP----------------------------------------------------------

var a:arbol;
    v:vector;
begin
  writeln('------cargar estructuras: ');
    generar(a,v);//A
  writeln('------arbol: ');  
    imprimirA(a);
  writeln('------vector: ');  
    imprimirV(v);
  writeln('------incisoB: ');  
    incisoB(a);//B
  writeln('------incisoC: ');
    ordenacionSeleccion(v);//C
    //ordenacionInsercion(v);
    imprimirV(v);
  writeln('------Fin de programa. ');
end.