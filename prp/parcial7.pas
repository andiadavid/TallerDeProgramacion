program parcial7;
type 
    compra=record 
        codCli:integer;
        numF:integer;
        cantP:integer;
        monto:real;
    end;

    regL=record
        numF:integer;
        cantP:integer;
        monto:real;
    end;    
    lista=^nodoL;
    nodoL=record 
        dato:regL;
        sig:lista;
    end;
    arbol=^nodo;
    nodo=record 
        codCli:integer;
        compras:lista;
        hi:arbol;
        hd:arbol;
    end;        

//-------------------------------------
procedure agregarAdelante(var l:lista; r:regL);
    var nue:lista;
    begin
      new(nue);
      nue^.dato:=r;
      nue^.sig:=l;
      l:=nue;
    end;
//----------------------generar arbol    
procedure generarA(var a:arbol);
    procedure leerC(var c:compra);
    begin
      write('codCliente<>0: ');read(c.codCli);
      if(c.codCli<>0)then begin
        write('numF: ');read(c.numF);
        write('cantP: ');read(c.cantP);
        write('monto: ');read(c.monto);
      end;
    end;
    procedure asignarR(var r:regL; c:compra);
    begin
      r.numF:=c.numF;
      r.cantP:=c.cantP;
      r.monto:=c.monto;
    end;
    
    procedure insertar(var a:arbol; c:compra);
    var r:regL;
    begin
      if(a=nil)then begin
        new(a);
        a^.codCli:=c.codCli;
        a^.compras:=nil;
        asignarR(r,c);
        agregarAdelante(a^.compras,r);
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(c.codCli=a^.codCli)then begin
                asignarR(r,c);
                agregarAdelante(a^.compras,r);
           end
           else if(c.codCli<a^.codCli)then
                    insertar(a^.hi,c)
                else 
                    insertar(a^.hd,c);   
    end;

var c:compra;
begin
  leerC(c);
  while(c.codCli<>0)do begin
    insertar(a,c);
    leerC(c);
  end;
end;
//--------------------------recorrer
procedure recorrerA(a:arbol);
    function buscarA(a:arbol; cod:integer):arbol;
    begin
        if(a=nil)then
            buscarA:=nil
        else if(cod= a^.codCli)then
                buscarA:=a
             else if(cod<a^.codCli)then
                    buscarA:=buscarA(a^.hi,cod)
                  else 
                    buscarA:=buscarA(a^.hd,cod);         
    end;
    procedure calcular(l:lista; var cant:integer; var monT:real);
    begin
      if(l<>nil)then begin
        cant:=cant +1;
        monT:=monT+ l^.dato.monto;
        calcular(l^.sig,cant,monT);
      end;  
    end;
var punt:arbol;
    cod,cant:Integer;
    monT:real;
begin
    write('cod a buscar:');read(cod);
    punt:=buscarA(a,cod);
    if(punt=nil)then 
        writeln('no esxiste el cod de cliente .')
    else begin
      cant:=0; monT:=0;  
      calcular(punt^.compras, cant,monT);
      writeln('el cliente:',punt^.codCli,' tiene',cant,' compras y montoT:',monT);    
    end;
end;
//-------------------------------------imp arbol y lista
procedure imprimirL(l:lista);
begin
  if(l<>nil)then begin
    Write('nf:',l^.dato.numF);
    Write(' cantP:',l^.dato.cantP);
    WriteLn(' monto:',l^.dato.monto:2:2);
    imprimirL(l^.sig);
  end;
end;
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    imprimirA(a^.hi);
    WriteLn('--codAlu:',a^.codCli);
    imprimirL(a^.compras);
    imprimirA(a^.hd);
  end;
end;  

//--------------------------------------generar lista
procedure generarL(a:arbol);
    procedure recorrerL(l:lista; var lg:lista; x,y:integer);
    begin
      if(l<>nil)then begin
        if(l^.dato.numF>x)and(l^.dato.numF<y)then
          agregarAdelante(lg,l^.dato);
        recorrerL(l^.sig,lg,x,y);  
      end;  
    end;
    procedure busquedaNF(a:arbol; var lg:lista; x,y:integer);
    begin
      if(a<>nil)then begin
        busquedaNF(a^.hi,lg,x,y);
        recorrerL(a^.compras,lg,x,y);
        busquedaNF(a^.hd,lg,x,y);
      end;
    end;

var lg:lista;
    x,y:integer;
begin
    write('nf x:');read(x);
    write('nf y:');read(y);
    lg:=nil;
    busquedaNF(a,lg,x,y);
    imprimirL(lg);
end;
//---------------------------------
var a:arbol;
begin
    generarA(a);
    writeln('-------Arbol:');
    imprimirA(a);
    writeln('-------recorro:');
    recorrerA(a);
    writeln('-------generarL:');
    generarL(a);
    writeln('fin pp:');
end.