program p1.ej2;
const df=10;
type
    oficina=record
        cod:Integer;
        dni:Integer;
        valor:real;
    end;
    vec=array [1..df] of oficina;    

//procesos---------------------------------------
//A---------------------------------------
procedure cargarV(var v:vec; var dl:Integer); 
    procedure leerO(var o:oficina);
    begin
        Write('codigo <> -1: ');read(o.cod);
        if(o.cod<>-1)then begin
            Write('dni: ');read(o.dni);
            Write('valor: ');readln(o.valor);
        end;  
    end;
var o:oficina;
    i:integer;
begin 
    leerO(o);
    while(o.cod<>-1)and(dl<df)do begin
        dl:=dl+1;
        v[dl]:=o;

        leerO(o);
    end;
end;

procedure impVRec(v:vec; dl:Integer; i:Integer);
begin
    if(i<=dl)then begin
        Write('codigo:',v[i].cod);
        Write(' dni:',v[i].dni);
        WriteLn(' valor:',v[i].valor:2);
        i:=i+1;
        impVRec(v,dl,i);
    end;
end;
//PP---------------------------------------------
var v:vec;
    dl:Integer;
    i:Integer;
begin
    dl:=0;
    cargarV(v,dl);
    i:=1;
    impVRec(v,dl,i);

end.