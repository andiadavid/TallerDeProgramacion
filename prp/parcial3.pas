program parcial3;
type
    envio=record
        codCliente:integer;
        dia:integer;
        codPostal:integer;
        peso:integer;
    end;

    envL=record
        codCliente:integer;
        dia:integer;
        peso:integer;
    end;    
    lista=^nodoL;
    nodoL=record
        dato:envL;
        sig:lista;
    end;
    arbol=^nodo;
    nodo=record
        codPostal:integer;
        envios:lista;
        hi:arbol;
        hd:arbol;
    end;    

//PROCESOS------------------------------------------------
//A-generar arbol con listas-----------------
procedure generarA(var a:arbol);
    procedure leerE(var e:envio);
    begin
      write('----peso<>0:'); read(e.peso);
      if(e.peso<>0)then begin
        write('codCliente:'); read(e.codCliente);
        write('dia:'); read(e.dia);
        write('codP=ORDEN_ABB:'); read(e.codPostal);
      end;
    end;
    procedure generarEnvL(var enl:envL; e:envio);
    begin
      enl.codCliente:=e.codCliente;
      enl.dia:=e.dia;
      enl.peso:=e.peso;
    end;
    procedure agregarAdelante(var l:lista; enl:envL);
    var nue:lista;
    begin
      new(nue);
      nue^.dato:=enl;
      nue^.sig:=l;
      l:=nue;
    end;
    procedure insertarA(var a:arbol; e:envio);
    var enL:envL;
    begin
      if(a=nil)then begin
        new(a);
        a^.codPostal:=e.codPostal;
        a^.envios:=nil;
        generarEnvL(enL,e);
        agregarAdelante(a^.envios,enL);
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(a^.codPostal=e.codPostal)then begin
              generarEnvL(enl,e);
              agregarAdelante(a^.envios,enL);
           end
           else if(e.codPostal< a^.codPostal)then
                   insertarA(a^.hi,e)
                else 
                   insertarA(a^.hd,e);  
    end;
var e:envio;
begin
    leerE(e);
    while(e.peso<>0)do begin
      insertarA(a,e);
      leerE(e);
    end;
end;
//Imprimir Arbol EnOrden y imprimir lisat Recursiva------------
procedure imprimirL(l:lista);
begin
  if(l<>nil)then begin
    write('codcliente:',l^.dato.codCliente);
    write(' dia:',l^.dato.dia);
    writeln(' peso:',l^.dato.peso);
    imprimirL(l^.sig);
  end;
end;    
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    if(a^.hi<>nil)then imprimirA(a^.hi);
    WriteLn('codP:',a^.codPostal);
    imprimirL(a^.envios);
    if(a^.hd<>nil)then imprimirA(a^.hd);
  end;
end;
//B- buscar la lista de un codP ingresado por teclado---
procedure buscarLista(a:arbol; var punt:arbol);
    function buscarCodP(a:arbol; cod:integer):arbol;
    begin
      if(a=nil)then
        buscarCodP:=nil
      else if(a^.codPostal=cod)then 
              buscarCodP:=a
           else if(cod < a^.codPostal)then   
                   buscarCodP:=buscarCodP(a^.hi,cod)
                else  
                   buscarCodP:=buscarCodP(a^.hd,cod);
    end; 
var cod:integer;
begin
  write('ingrese un CodPostal:'); read(cod);
  punt:=buscarCodP(a,cod);
  if(punt=nil)then
    writeln('no existe el cod Postal :',cod)
  else begin 
    writeln('lista de envios del cod',punt^.codPostal,' es:');
    imprimirL(punt^.envios);
  end;  
end;
//C- buscar el cliente con mayor y menor peso------
procedure buscarCodCliente(punt:arbol);
    procedure buscarMax(l:lista; var pMx,codCMax:integer);
    begin
      if(l<>nil)then begin
        if(pMx< l^.dato.peso)then begin
            pMx:=l^.dato.peso;
            codCMax:=l^.dato.codCliente;
        end;
        buscarMax(l^.sig,pMx,codCMax);
      end; 
    end;
    procedure buscarMin(l:lista; var pMn,codCMin:integer);
    begin
      if(l<>nil)then begin
        if(pMn>l^.dato.peso)then begin
            pMn:=l^.dato.peso;
            codCMin:=l^.dato.codCliente;
        end;
        buscarMin(l^.sig,pMn,codCMin);
      end; 
    end;
var codCMax:integer;
    pesoMax:integer;
    codCMin:integer;
    pesoMin:integer;
begin
  if(punt=nil)then
    writeln('no se puede calcular el maximo y minimio,no existe el cod Postal :')
  else begin 
    pesoMax:=-999;
    buscarMax(punt^.envios,pesoMax,codCMax);
    writeln('el cliente ',codCMax,' tiene el mayor peso con peso: ',pesoMax);
    pesoMin:=9999;
    buscarMin(punt^.envios,pesoMin,codCMin);
    writeln('el cliente ',codCMin,' tiene el menor peso con peso: ',pesoMin);
  end;
end;
//PP-----------------------------------------------------
var a:arbol;
    punt:arbol;
begin
    writeln('----A-----generar Arbol');
    generarA(a);
    writeln('--------imprimir Arbol');
    imprimirA(a);
    writeln('----B-----buscar la lista de un codPAux');
    buscarLista(a,punt);
    writeln('----C-----buscar en la lista de envios del incisoB');
    writeln('el cliente con mayor y menor peso:');
    buscarCodCliente(punt);
end.