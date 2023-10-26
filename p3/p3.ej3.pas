program p3.ej3;
type 
    mat=record
        cod:integer;
        nota:Integer;
    end;    
    lista=^nodoL;
    nodoL=record
        dato:mat;
        sig:lista;
    end;   
    alu=record 
        leg:integer;
        dni:Integer;
        anioI:Integer;
        finales:lista;
    end;
    arbol=^nodoA;
    nodoA=record
        dato:alu;
        HI:arbol;
        HD:arbol;
    end;

    reg=record
        dni:integer;
        anioI:Integer;
    end;
    listaB=^nodoB;
    nodoB=record
        dato:reg;
        sig:listaB;
    end;
//PROCESOS--------------------------------------------------
//Proceso generar arbol de alumnos y dentro la lista de finales
procedure generarA(var a:arbol);
    procedure leerFinal(var f:mat);
    begin
        write('cod<>-1: ');read(f.cod);
        if(f.cod<>-1)then begin
            write('nota: ');read(f.nota);
        end;
    end;
    procedure agregarAdelante(var l:lista; f:mat);
    var nue:lista;
    begin
        new(nue);
        nue^.dato:=f;
        nue^.sig:=l;
        l:=nue;
    end;    

    procedure leerAlu(var al:alu);
    var f:mat;
    begin
        write('legajo<>0: ');read(al.leg);
        if(al.leg<>0)then begin
            write('dni: ');read(al.dni);
            write('anio: ');read(al.anioI);
            al.finales:=nil;
            writeln('inicia la carga de finales del alumno, hasta cod<>-1: ');
            leerFinal(f);
            while(f.cod<>-1)do begin
                agregarAdelante(al.finales,f);
                leerFinal(f); 
            end;
        end;
    end;
    procedure insertarA(var a:arbol; al:alu);
    begin
        if(a=nil)then begin
            New(a);
            a^.dato:=al;
            a^.HI:=nil;
            a^.HD:=nil;
        end
        else if(al.leg< a^.dato.leg)then
                insertarA(a^.HI,al)
             else if(al.leg> a^.dato.leg)then
                insertarA(a^.HD,al);    
    end;

var al:alu;
begin
    a:=nil;
    writeln('inicio la carga de alumnos, hasta legajo<>0: ');
    leerAlu(al);
    while(al.leg<>0)do begin
        insertarA(a,al);
        leerAlu(al);
    end;
end;
//Imprimir arbol---------------------------------
procedure imprimirF(l:lista);
begin
    if(l<>Nil)then begin
        write('codigo:',l^.dato.cod);
        WriteLn(' nota:',l^.dato.nota);
        l:=l^.sig;
        imprimirF(l);
    end;
end;
procedure imprmirA(a:arbol);
begin
    if(a<>nil)then begin
        imprmirA(a^.HI);
        write('legajo:',a^.dato.leg);
        write(' dni:',a^.dato.dni);
        WriteLn(' anioIngreso:',a^.dato.anioI);
        if(a^.dato.finales<>Nil)then begin
            write('finalesAp:');
            imprimirF(a^.dato.finales);
        end
        else 
            WriteLn('no hay finales aprobados:');    
        imprmirA(a^.HD);
    end;
end;

//b-----------------------------------------------------
procedure buscarB(a:arbol; leg:Integer; var lB:listaB);
    procedure agregarAdelanteB(var l:listaB; r:reg);
    var nue:listaB;
    begin
        new(nue);
        nue^.dato:=r;
        nue^.sig:=l;
        l:=nue;
    end;
var r:reg;
begin
    if(a<>nil)then begin
        if(a^.dato.leg<leg)then begin 
            buscarB(a^.HD,leg,lB);
            r.dni:= a^.dato.dni;
            r.anioI:= a^.dato.anioI;
            agregarAdelanteB(lB,r);
            buscarB(a^.HI,leg,lB);
        end
        else buscarB(a^.HI,leg,lB);    
    end;
end;
//Imprimir lista-------------------------------------------
procedure imprimirL(lB:listaB);
begin
    if(lB<>Nil)then begin
        Write('dni:',lB^.dato.dni);
        WriteLn(' anioIngreso:',lB^.dato.anioI);
        lB:=lB^.sig;
        imprimirL(lB);
    end    
end;

//C----------------------------------
function legMasGrande(a:arbol):integer;
begin
    if(a<>nil)then begin
        if(a^.HD=Nil)then
            legMasGrande:=a^.dato.leg
        else 
            legMasGrande:=legMasGrande(a^.HD);    
    end; 
end;
//D------------------------------------------
procedure buscarDniMax(a:arbol; var dni:Integer);
begin
    if(a<>Nil)then begin 
        buscarDniMax(a^.HD,dni);
        if(a^.dato.dni>=dni)then
            dni:=a^.dato.dni;
        buscarDniMax(a^.HD,dni);
    end;    
end;
//Calcular Promedio---------------------------
procedure promedio(l:lista; cant:Integer; nota:Integer; var prom:Real);
    begin
        if(l<>Nil)then begin
            cant:=cant+1;
            nota:=nota+ l^.dato.nota;
            l:=l^.sig;
            promedio(l,cant,nota,prom);
        end
        else 
            prom:=(nota/cant);
    end;
//E-------------------------------------------
procedure maxProm(a:arbol; var leg:Integer; var proM:Real);
var aux:real;
    nota:Integer;
    cant:Integer;
begin
    if(a<>Nil)then begin 
        maxProm(a^.HI,leg,proM);
        if(a^.dato.finales<>Nil)then begin
            cant:=0; nota:=0; aux:=0;
            promedio(a^.dato.finales,cant,nota,aux);
            if(aux>=proM)then begin
                proM:=aux;
                leg:=a^.dato.leg;
            end;    
        end;                    
        maxProm(a^.HI,leg,proM);
    end;    
end;
//F---------------------------------------------
procedure promedios(a:arbol; p:Integer);
var aux:real;
    nota:Integer;
    cant:Integer;
begin
    if(a<>Nil)then begin
        promedios(a^.HI,p);
        if(a^.dato.finales<>Nil)then begin
            cant:=0; nota:=0; aux:=0;
            promedio(a^.dato.finales,cant,nota,aux);
            if(aux>=p)then begin
                Write('leg:',a^.dato.leg);
                WriteLn(', promedio:',aux);    
            end;    
        end
        else begin
            writeln('el alumno no tiene finales aprobados.');    
            WriteLn('leg:',a^.dato.leg);
        end;
        promedios(a^.HD,p);
    end;    
end;
//PP-------------------------------------------------------

var a:arbol;
    lB:listaB;leg:integer;
    dniMax:Integer;
    promM:Real;
begin
    //A
    generarA(a); 
    WriteLn('----------arbol: ');
    imprmirA(a);
    //B
    WriteLn('---incisoB: ');
    WriteLn('alumnos que tengan legajo menor al ingresado:');    
    write('leg');read(leg);
    lB:=nil;
    buscarB(a,leg,lB);
    imprimirL(lB);
    if(lB=Nil)then
        WriteLn('no hay alumnos que cumplan');
    //C
    WriteLn('---incisoC: ');
    if(a<>nil)then
        WriteLn('el leg mas grande: ',legMasGrande(a));
    //D
    WriteLn('---incisoD: ');    
    dniMax:=-999;
    buscarDniMax(a,dniMax);
    WriteLn('del dni mas grande: ',dniMax);
    //E
    WriteLn('---incisoE: ');    
    promM:=-999; leg:=0;
    maxProm(a,leg,promM);
    WriteLn('el leg y prom del alum con mejor prom:');
    Write('leg:',leg);
    Write('prom:', promM);
    //F
    WriteLn('---incisoF: ');    
    WriteLn('mostrar alumnos que superan el promedio ingresado:');
    read(leg);
    promedios(a,leg);

end.