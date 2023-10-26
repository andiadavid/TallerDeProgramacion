program parcial5;
type 

    final=record
        codAlu:integer;
        codMat:integer;
        nota:integer;
    end;

    lista=^nodoL;
    nodoL=record
        nota:integer;
        sig:lista;
    end;    
    arbol=^nodo;
    nodo=record
        codAlu:integer;
        finales:lista;
        hi:arbol;
        hd:arbol;
    end;         

    regL=record
        codA:integer;
        prom:real;
    end;    
    listaB=^nodoB;
    nodoB=record
        dato:regL;
        sig:listaB;
    end;    
    
//procesos---------------------

procedure generarA(var a:arbol);
    procedure leer(var f:final);
    begin
      write('codAlu:');read(f.codAlu);
      if(f.codAlu<>0)then begin
        write('codMat:');read(f.codMat);
        write('nota:');read(f.nota);
      end;
    end;
    procedure agregarAdelante(var l:lista; nota:integer);
    var nue:lista;
    begin
      new(nue);
      nue^.nota:=nota;
      nue^.sig:=l;
      l:=nue;
    end;
    procedure insertarA(var a:arbol; f:final);
    begin
      if(a=nil)then begin
        new(a);
        a^.codAlu:=f.codAlu;
        a^.finales:=nil;
        agregarAdelante(a^.finales,f.nota);
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(a^.codAlu= f.codAlu)then
                agregarAdelante(a^.finales,f.nota)
            else if(f.codAlu< a^.codAlu)then 
                    insertarA(a^.hi,f)
                 else    
                    insertarA(a^.hd,f);
    end;

var f:final;
begin
    leer(f);
    while(f.codAlu<>0)do begin
        insertarA(a,f);
        leer(f);
    end;
end;
//B----------------------------------
procedure promedio(a:arbol; var lb:listaB);
    procedure agregarAdelante(var l:listaB; cod:integer; p:real);
    var nue:listaB;
    begin
      new(nue);
      nue^.dato.codA:=cod;
      nue^.dato.prom:=p;
      nue^.sig:=l;
      l:=nue;
    end;
    procedure calcularP(l:lista; var cant:integer; var suma:integer);
    begin
      if(l<>nil)then begin
        cant:=cant+ 1;
        suma:=suma+ l^.nota;
        calcularP(l^.sig,cant,suma);
      end;  
    end;
var suma,cant:integer;
    p:real;
begin 
    if(a<>nil)then begin
      promedio(a^.hi,lb);
      cant:=0;
      suma:=0;
      calcularP(a^.finales,cant,suma);
      writeln('suma',suma);
      p:=suma/cant;
      agregarAdelante(lb,a^.codAlu,p);
      promedio(a^.hd,lb);
    end;
end;
//----------------------------c
procedure generarOrd(var lc:listaB; lb:listaB);
    procedure insertarOrden(var lc:listaB; reg:regL);
    var ant,nue,act:listaB;
    begin
        new(nue);
        nue^.dato:=reg;
        ant:=lc;
        act:=lc;
        while(act<>nil)and(act^.dato.prom<reg.prom)do begin
            ant:=act;
            act:=act^.sig;
        end;
        if(ant=act)then
          lc:=nue
        else
          ant^.sig:=nue;
        nue^.sig:=act;
    end;
begin
  if(lb<>nil)then begin
    insertarOrden(lc,lb^.dato);
    generarOrd(lc,lb^.sig);
  end;
end;
//imprimir arbol, lista----
procedure imprimirL(l:listaB);
begin
  if(l<>nil)then begin
    Write('codAlu:',l^.dato.codA);
    WriteLn(' prom:',l^.dato.prom:2:2);
    imprimirL(l^.sig);
  end;
end;
procedure imprimirLA(l:lista);
begin
  if(l<>nil)then begin
    WriteLn('nota:',l^.nota);
    imprimirLA(l^.sig);
  end;
end;
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    imprimirA(a^.hi);
    WriteLn('--codAlu:',a^.codAlu);
    imprimirLA(a^.finales);
    imprimirA(a^.hd);
  end;
end;  
//pp------------------------------

var a:arbol;
    lb:listaB;
    lc:listaB;
begin
    writeln('generar');
    generarA(a);
    writeln('----arbol');
    imprimirA(a);
    lb:=nil;
    promedio(a,lb);
    writeln('--lista de promedios');
    imprimirL(lb);
    lc:=nil;
    generarOrd(lc,lb);
    writeln('listaordenada');
    imprimirL(lc);
    writeln('fin pp');
end.