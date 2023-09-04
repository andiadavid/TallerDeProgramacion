program pI1;
const dF=6; //cant de materias a lo sumo 6(36)
type
    vector=array[1..dF]of integer;
    alumno=record
        ape:string[30];
        codAlu:integer;
        anioIng:integer;
        DLmatAp:Integer;
        materias:vector;
    end;
    lista=^nodo;
    nodo=record
        dato:alumno;
        sig:lista;
    end;       

//PROCESOS--------------------------
//cargar A---------
procedure cargarL(var l:lista);
    procedure cargarVecRec(var v:vector; var dl:integer);
        var nota:Integer;
        begin
            if(dl<dF)then begin
                write('nota mayor a 4: ');read(nota);
                if(nota>=4)then begin
                    dl:=dl+1;
                    v[dl]:=nota;
                    cargarVecRec(v,dl);
                end;    
            end;
        end;
    procedure leerAlu(var alu:alumno);
    begin
        write('ingrese codigoAlumno distinto de 1111: ');
        read(alu.codAlu);
        if(alu.codAlu<>1111)then begin
            ReadLn();//inst para poder leer apellido
            write('ingrese apellido: ');read(alu.ape);
            write('ingrese anioIngreso: ');read(alu.anioIng);
            WriteLn('ingrese las 6notas de materias aprobadas: ');
            alu.DLmatAp:=0;
            cargarVecRec(alu.materias,alu.DLmatAp);
        end;
    end;
    procedure agregarAdelante(var l:lista; alu:alumno);
    var nue:lista;
    begin
        new(nue); 
        nue^.dato:=alu;
        nue^.sig:=l;
        l:=nue;
    end;

var alu:alumno;
begin
    leerAlu(alu);
    while (alu.codAlu<>1111) do begin
        agregarAdelante(l,alu);
        leerAlu(alu);
    end;
end;
//imprimir lista y vector recursivamente------------
procedure impListaRec(l:lista);
    procedure impVecRec(v:vector; dl:Integer; i:Integer);
    begin
        if(i<=dl)then begin
            writeln('la nota',i,' es: ',v[i]);
            i:=i+1;
            impVecRec(v,dl,i);
        end;
    end;
    procedure impAlu(alu:alumno);
    var i:Integer;
    begin
        writeln('COD Alumno: ',alu.codAlu);   
        writeln('apellido: ',alu.ape);
        writeln('anio Ingreso: ',alu.anioIng);
        if(alu.DLmatAp<>0)then begin
            i:=1;
            writeln('materias aprobadas: ');
            impVecRec(alu.materias, alu.DLmatAp, i);
        end else WriteLn('sin materias aprob.');
    end;
begin
    if(l<>nil)then begin
        impAlu(l^.dato);
        l:=l^.sig;
        impListaRec(l);
    end;
end;
//B.recorrer-------------------
procedure recorrerL(l:lista);
    function calcularProm(v:vector; dl:Integer):Real;
    var i,cont:Integer;
    begin
        cont:=0;
        for i:=1 to dl do 
            cont:=cont+v[i];           
        calcularProm:=cont/dl; 
    end;

begin
    if(l<>nil)then begin
        write('codAlu: ',l^.dato.codAlu);
        if(l^.dato.DLmatAp<>0)then begin 
            writeln(', el promedio es: ',calcularProm(l^.dato.materias,l^.dato.DLmatAp):4);
        end else writeln(', el promedio es: 0');    
        l:=l^.sig;
        recorrerL(l);  
    end;
end;

//PP--------------------------------
var l:lista;
begin
    l:=nil;
    cargarL(l); //A.generar estructura para guardar informacion
                        //yo no guardo el cod de corte
    WriteLn('promedio de los alumnos--------------------- ');
    recorrerL(l); //B.recorrer y retornar: codAlumno, promedio Notas                    
    writeln('LISTA---------------------------: ');
    impListaRec(l);
    write('FINAL DEL PROGRAMA');
end.