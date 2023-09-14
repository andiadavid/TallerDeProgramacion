program p5.ej1;
type
    reclamo=record //lectura general de reclamos
        cod:Integer;
        dni:integer;
        anio:Integer;
        tipo:integer;
    end;
//-------------------
    listaC=^nodoC; //para el inciso D, lista de codigos
    nodoC=record
        cod:Integer;
        sig:listaC;
    end;    
//-------------------
    regL=record 
        cod:Integer;
        anio:Integer;
        tipo:Integer;
    end;
    lista=^nodoL;
    nodoL=record
        dato:regL;
        sig:lista;
    end;    
    arbol=^nodo; //estructura pp arbol de dni con lista de reclamos
    nodo=record
        dni:Integer;
        reclamos:lista;
        hi:arbol;
        hd:arbol;
    end;        
//PROCESOS------------------------------------------------------
//--incisoA--generar Arbol ---------------------------------
procedure generarA(var a:arbol);
    procedure leerR(var r:reclamo);
    begin
      write('ingrese cod<>-1: ');read(r.cod);
      if(r.cod<>-1)then begin
        write('dni: ');read(r.dni);
        write('anio: ');read(r.anio);
        write('tipo: ');readln(r.tipo);
      end;
    end;
    procedure armarR(var rAux:regL; r:reclamo);
    begin
      rAux.cod:=r.cod;
      rAux.anio:=r.anio;
      rAux.tipo:=r.tipo;
    end;
    procedure agregarAdelante(var l:lista; r:regL);
    var nue:lista;
    begin
        new(nue);
        nue^.dato:=r;
        nue^.sig:=l;
        l:=nue;
    end;
    procedure insertarA(var a:arbol; r:reclamo);
    var regAux:regL;
    begin
      if(a=Nil)then begin
        new(a);
        a^.dni:=r.dni;
        a^.reclamos:=nil;
        armarR(regAux,r);
        agregarAdelante(a^.reclamos,regAux);
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(r.dni= a^.dni)then begin
            armarR(regAux,r);
            agregarAdelante(a^.reclamos,regAux);
           end
           else if(r.dni< a^.dni)then
                    insertarA(a^.hi,r)
                else      
                    insertarA(a^.hd,r);
    end;
var r:reclamo;
begin
    leerR(r);
    while(r.cod<>-1)do begin
      insertarA(a,r);
      leerR(r);
    end;
end;
//Imprimir arbol y lista----------------------------------
procedure imprimirL(l:lista);
begin
  if(l<>nil)then begin
    write('cod: ',l^.dato.cod);
    write(', anio: ',l^.dato.anio);
    WriteLn(', tipo: ',l^.dato.tipo);
    imprimirL(l^.sig);
  end;
end;
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    if(a^.hi<>nil)then imprimirA(a^.hi);
    WriteLn('--dni: ',a^.dni);
    imprimirL(a^.reclamos);
    if(a^.hd<>nil)then imprimirA(a^.hd);
  end;
end;
//B- cant de reclamos de un dni ingresado------------

function contarR(l:lista):integer;
begin
  if(l<>nil)then
    contarR:=1 + contarR(l^.sig)
  else  
    contarR:=0;
end;

procedure buscarcantR(a:arbol);    
    function buscarDni(a:arbol; dni:Integer):arbol;
    begin
        if(a=nil)then
            buscarDni:=nil
        else if(a^.dni=dni)then
                buscarDni:=a
            else if(dni< a^.dni)then
                    buscarDni:=buscarDni(a^.hi,dni)
                else           
                    buscarDni:=buscarDni(a^.hd,dni);
    end;
var dni:Integer;
    punt:arbol;
begin
    write('ingrese un dni para buscar la cant de reclamos: ');read(dni);
    punt:=buscarDni(a,dni);
    if(punt=nil)then
        WriteLn('no hay un usuario con ese dni')
    else 
        WriteLn('la cantidad de reclamos del dni ',dni,' es: ',contarR(punt^.reclamos));    
end;
//C- recorrido acotado entre dos dni leidos por teclado (inclusive)---
procedure comprendidos(a:arbol);
    procedure recorridoAc(a:arbol; Inf,Sup:Integer; var cant:Integer);
    begin
      if(a<>Nil)then begin
        if(Inf<=a^.dni)then
          if(a^.dni<=Sup)then begin
            cant:=cant+ contarR(a^.reclamos);
            recorridoAc(a^.hi,Inf,Sup,cant);
            recorridoAc(a^.hd,Inf,Sup,cant);
          end  
          else recorridoAc(a^.hi,Inf,Sup,cant)
        else recorridoAc(a^.hd,Inf,Sup,cant); 
      end;
    end;
var dniInf,dniSup,cant:Integer;
begin
    write('ingrese un dni Inferior: ');read(dniInf);
    write('ingrese un dni Superior: ');read(dniSup);
    cant:=0;
    recorridoAc(a,dniInf,dniSup,cant);
    if(cant=0)then
        WriteLn('no hay reclamos entre los valores')
    else 
        WriteLn('cant reclamos entre dniInf ',dniInf,' y dniSup ',dniSup,' es: ',cant);    
end;
//D- genero una lista de codigos de reclamos de un año recibido
//para esto recorro cada nodo del arbol y recorro la lista de reclamos  
//y si coincide el año de algun reclamo guardo el codigo en una lista(listaR)
procedure generarLR(a:arbol);
    procedure imprimirlc(lc:listaC);
    begin
        if(lc<>nil)then begin
            write(' cod:',lc^.cod);
            imprimirlc(lc^.sig);
        end;
    end;
    procedure agregarAd(var lc:listaC; cod:Integer);
    var nue:listaC;
    begin
      new (nue);
      nue^.cod:=cod;
      nue^.sig:=lc;
      lc:=nue;
    end;
    procedure recorrerL(l:lista; anio:Integer; var lc:listaC);
    begin
        if(l<>nil)then begin   
            if(l^.dato.anio=anio)then 
                agregarAd(lc,l^.dato.cod);
            recorrerL(l^.sig,anio,lc);    
        end;
    end;    
    procedure buscarAnio(a:arbol; anio:Integer; var lc:listaC);
    begin
        if(a<>nil)then begin
            if(a^.hi<>nil)then buscarAnio(a^.hi,anio,lc);
            recorrerL(a^.reclamos,anio,lc);
            if(a^.hd<>nil)then buscarAnio(a^.hd,anio,lc);
        end;
    end;

var lc:listaC;
    anio:Integer;
begin
  Write('ingrese el anio a buscar');read(anio);
  lc:=nil;
  buscarAnio(a,anio,lc);
  if(lc<>nil)then begin
    WriteLn('lista de cod de reclamos del anio ',anio);
    imprimirlc(lc);
    WriteLn;
  end  
  else Write('no hay elementos reclamos en el anio ingresado');
end;
//PP------------------------------------------------------------

var a:arbol;
begin
    WriteLn('----(A)-----generar Arbol');
    generarA(a);
    WriteLn('---------imprimir Arbol');
    imprimirA(a);
    WriteLn('----(B)-----cant de reclamos de un dni');
    buscarcantR(a);
    WriteLn('----(C)-----cant de reclamos comprendidos entre dniInf y dniSup');
    comprendidos(a);
    WriteLn('----(D)-----genero lista de codigos de reclamos');
    generarLR(a);
    write('fin de programa.');    
end.
