program parcial6;
const df=15;
type
    atencion=record 
        dni:integer;
        nMes:integer;
        cod:integer;
    end;

    regAr=record 
        dni:integer;
        cant:integer;
    end;
    arbol=^nodo;
    nodo=record
        dato:regAr;
        hi:arbol;
        hd:arbol;
    end;
    vector=array[1..15]of integer;      

//-------------------------------------------
procedure generarA(var a:arbol; var v:vector);
    procedure leer(var at:atencion);
    begin
      write('--mes<>0: ');read(at.nMes);
      if(at.nMes<>0)then begin
        write('dni(ordA): ');read(at.dni);
        write('cod(1..15): ');read(at.cod);
      end;
    end;
    procedure insertar(var a:arbol; at:atencion);
    begin
      if(a=nil)then begin
        new(a);
        a^.dato.dni:=at.dni;
        a^.dato.cant:=1;
        a^.hi:=nil;
        a^.hd:=nil;
      end
      else if(a^.dato.dni=at.dni)then
                a^.dato.cant:=a^.dato.cant+ 1
           else if(at.dni< a^.dato.dni)then
                    insertar(a^.hi,at)
                else 
                     insertar(a^.hd,at);         
    end;
    procedure inicializar(var v:vector);
    var i:integer;
    begin
        for i:=1 to df do 
            v[i]:=0;
    end;

var at:atencion;
begin
    inicializar(v);
    leer(at);
    while(at.nMes<>0)do begin
        insertar(a,at);
        v[at.cod]:=v[at.cod]+ 1;
        leer(at);
    end;
end;
//rec acotado----------------------------
procedure recorrerA(a:arbol);
    procedure recorridoAc(a:arbol; inf,sup,x:integer; var cumple:integer);
    begin
      if(a<>nil)then begin
        if(inf<a^.dato.dni)then
            if(a^.dato.dni<sup)then begin
                if(a^.dato.cant> x)then
                    cumple:=cumple+ 1;
                recorridoAc(a^.hi,inf,sup,x,cumple);
                recorridoAc(a^.hd,inf,sup,x,cumple);
            end 
            else recorridoAc(a^.hi,inf,sup,x,cumple)
        else recorridoAc(a^.hd,inf,sup,x,cumple);    
      end;
    end;

var dniInf,dniSup,cantX:integer;
    cumple:integer;
begin
    Write('inf');read(dniInf);
    Write('sup');read(dniSup);
    Write('cantX');read(cantX);
    cumple:=0;
    recorridoAc(a,dniInf,dniSup,cantX,cumple);
    WriteLn('la cant q cumple es: ',cumple);
end;
//imprmir-------------------------
procedure imprimirA(a:arbol);
begin
  if(a<>nil)then begin
    imprimirA(a^.hi);
    Write('--dni:',a^.dato.dni);
    WriteLn('cantAtenciones:',a^.dato.cant);
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
procedure contV0(v:vector; i:integer; var cant:integer);
begin
  if(i <= df)then begin
    if(v[i]= 0)then
        cant:=cant+ 1; 
    i:=i+1;
    contV0(v,i,cant);
  end;      
end;
//----------------------------------------------
var a:arbol;
    v:vector;
    cant,i:integer;
begin
  WriteLn('--generar');
  generarA(a,v);
  WriteLn('---------Arbol');
  imprimirA(a);
  WriteLn('-------Vector');
  imprimirV(v);
  WriteLn('------recorrido');
  recorrerA(a);
  WriteLn('------cuenta los 0');
  cant:=0; i:=1;
  contV0(v,i,cant);
  write('cant: ',cant);
end.
