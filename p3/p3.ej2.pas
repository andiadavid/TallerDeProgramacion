program p3.ej2;
type 
    venta=record
        cod:integer;
        fecha:integer;
        cantidad:Integer;
    end;
    arbol=^nodo;
    nodo=record 
        dato:venta;
        HI:arbol;
        HD:arbol;
    end;

//PROCESOS-------------------------------------------
procedure generarA(var a :arbol; var b:arbol);

{*Se puede generar el arbol de varias formas, en este caso con un solo 
generar defino dos registros tipo venta, el reg 'a' cargo todos los datos 
del arbol a que tiene ventas con codigo repetido y en el reg 'b' voy sumando
la cantidad y mateniedo el cod actual hasta que cambie y es cargado (la fecha 
la mantengo en 0 y a la hora de imprimir verifico con un condicional).
*Otra forma es definir dos arboles y registros e insertar de distinto
tipo los que ocuparia mas en memoria. En caso de ser un insertar para cod 
repetidos deberia preguntar ademas de si -'a'<>nil- tambien deberia preguntar 
si el cod es el mismo donde estoy parado en el arbol -a^.dato.cod=v.cod- en este 
caso sumo en la cantidad la nueva cantidad de ventas mas lo q ya habia vendido 
asi se va sumando.  }

    procedure leerVentas(var v:venta);
    begin
        Write('--Codigo-- <>0: '); read(v.cod);
        if(v.cod<>0)then begin
            Write('cantidad: '); read(v.cantidad);
            Write('fecha(int): '); read(v.fecha);
        end;
    end;
    procedure insertar(var a:arbol; v:venta; ok:Boolean);
    begin
        if(a=Nil)then begin
            new(a);
            a^.dato:=v;
            a^.HI:=nil;
            a^.HD:=nil;  
        end
        else if(ok)then begin
                    if(v.cod = a^.dato.cod)then begin
                        a^.dato.cantidad:=a^.dato.cantidad+ v.cantidad;
                        a^.dato.fecha:=0;
                    end
                    else if(v.cod < a^.dato.cod)then //los iguales se guardan e la izq
                            insertar(a^.HI,v,ok)            
                        else   
                            insertar(a^.HD,v,ok);
             end          
             else if(v.cod <= a^.dato.cod)then //los iguales se guardan e la izq
                     insertar(a^.HI,v,ok)            
                  else   
                     insertar(a^.HD,v,ok);
    end;
    
var v:venta;
    ok:Boolean;
begin
    a:=nil; b:=nil;
    writeln('comineza la carga de los arboles.');
    leerVentas(v);
    while(v.cod<>0)do begin
        ok:=false;
        insertar(a,v,ok);
        ok:=true;
        insertar(b,v,ok);
        leerVentas(v);
    end;
    writeln('');
end;

procedure imprimirA(a:arbol);
begin
    if(a<>Nil)then begin
      imprimirA(a^.HI);
      write('codigo:',a^.dato.cod,', ');
      write('cantidad: ',a^.dato.cantidad,', ');
      if(a^.dato.fecha<>0)then
        write('fecha: ',a^.dato.fecha,'.');
      WriteLn('');
      imprimirA(a^.HD);  
    end;
end;
//PP--------------------------------------------------

var a,b:arbol;
begin
    generarA(a,b);
    writeln('Arbol A con repetidos: ');
    imprimirA(a);
    writeln('Arbol B sin repetidos: ');
    imprimirA(b);
end.