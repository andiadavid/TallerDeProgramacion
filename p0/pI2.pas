program pI2;
const df=5;
type
    propiedad=record
        tipo:Integer;
        cod:Integer; 
        precioT:Integer;
    end;    
    lista=^nodo;
    nodo=record
        dato:propiedad;
        sig:lista;
    end;
    vector=array[1..df]of lista;    
//PROCESOS-------------------------------------------
procedure inicializarV(var v:vector);
var i:Integer;
begin
    for i:=1 to df do begin
      v[i]:=nil;
    end;
end;

//A.carga------------
procedure leeryCargar(var v:vector);
    procedure leerReg(var p:propiedad; precioM2:Integer);
    var m2:Integer;
    begin        
        if(precioM2<>-1)then begin
            Write('tipo int: '); read(p.tipo);
            Write('codigo: '); read(p.cod);
            Write('metros cuadrados: '); read(m2);  
            p.precioT:=(precioM2 * m2);
            WriteLn('el precio total es: ',p.precioT);        
        end;
        writeln('termino de cargar.-----');      
    end;
    
    procedure insertarOrd(var l:lista; p:propiedad);
    var nue,ant,act:lista;  
    begin
        writeln('insertar la prop ordenado en el vector.');
        new(nue);  
        nue^.dato:=p;
        nue^.sig:=nil;  
        ant:=l; act:=l;
        while (act<>nil)and(act^.dato.tipo < nue^.dato.tipo) do begin
            ant:=act;
            act:=act^.sig;
        end;
        if(ant=act)then
            l:=nue
        else 
            ant^.sig:=nue;
        nue^.sig:=act;    
    end;
    {
    function buscarOrLis(l:listaDZona; tip:integer):listaDZona;
    var act,punt:listaDZona;
    begin
        act:=l;
        punt:=nil;
        while (act<>nil)and(act^.dato^.dato.tipo<tip) do
            act:=act^.sig;
        if(act<>nil)and(act^.dato^.dato.tipo=tip)then 
            punt:=act;
        buscarOrLis:=punt;       
    end;
    }
var p:propiedad;
    precioM2,zona:Integer;
begin
    writeln('carga de productos:---------');
    Write('zona de 1a5: '); read(zona);
    Write('precio m2 <> -1: '); read(precioM2);
    leerReg(p,precioM2);
    while (precioM2 <> -1) do begin
        insertarOrd(v[zona],p);
        Write('zona de 1a5: '); read(zona);
        Write('precio m2 <> -1: '); read(precioM2);
        leerReg(p,precioM2);
    end;
end;

//impresion de vector y lista recursiva------
procedure imprimirProp(p:propiedad);
begin
    WriteLn('-Tipo int-: ',p.tipo);
    WriteLn('codigo: ',p.cod);
    WriteLn('metros cuadrados: ',p.precioT);
end;

procedure impVecRec(v:vector; i:Integer);
    procedure impListaRec(l:lista);
    begin
        if(l<>Nil)then begin
            imprimirProp(l^.dato);
            l:=l^.sig;
            impListaRec(l);          
        end;  
    end;
begin
    if(i<=df)then begin
        writeln('elementos de la zona: ',i,' son: ');
        if(v[i]=nil)then
            WriteLn('no hay elementos en esta lista.')  
        else
            impListaRec(v[i]);
        i:=i+1;
        impVecRec(v,i);
    end;
end;
//B.buscar en una zona y tipo todas las prop q cumplan---------
procedure buscarVec(v:vector; zona:Integer; tipo:Integer);
var ok:Boolean;
begin
    ok:=false;
    if(v[zona]=nil)then
        WriteLn('no existe la zona especificada.')  
    else
        WriteLn('las propiedades del tipo: ',tipo,' son:');
        while(v[zona]<>Nil)do begin
            if(v[zona]^.dato.tipo=tipo)then begin
                imprimirProp(v[zona]^.dato);
                ok:=true;
            end;    
            v[zona]:=v[zona]^.sig;
        end;
        if(not ok)then begin
            WriteLn('no hay prop de ese tipo.');  
        end;
end;

//PP-------------------------------------------------
var v:vector;
    i,bzona,btipo:integer;
begin
    inicializarV(v);
    leeryCargar(v); //A.cargar estructura
    i:=1;
    impVecRec(v,i);
    write('zona a buscar: ');read(bzona);
    write('tipo a buscar: ');read(btipo);
    buscarVec(v,bzona,btipo);

    write('FIN PROGRAMA');
end.