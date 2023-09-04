program pI3;
const df=5;
type 
    prodVect=record
        precio:real;
        stock:integer;
    end;
    vec=array[1..df] of prodVect;
    
    prod=record
        codProd:integer;
        cant:integer;
        precioU:real;
    end;
    listaProd=^nodoP;
    nodoP=record
        dato:prod;
        sig:listaProd;
    end;
    listaVent=^nodoV;
    nodoV=record
        codVent:integer;
        list:listaProd;
        sig:listaVent;
    end;    
//PROCESOS------------------------------------------
procedure inicializarV(var v:vec);
var i:Integer;
begin
    WriteLn('leo ',df,' productos(precio/stock):');
   for i:=1 to df do begin
      WriteLn('producto ',i,':');
      write('precio: '); read(v[i].precio);
      Write('stock: '); read(v[i].stock);
   end;
end;

procedure cargarVent(var l:listaVent; var v:vec);
    procedure leerP(var p:prod; var v:vec);
    begin
        Write('cantidad a comprar <> 0: '); read(p.cant);
        if(p.cant<>0)then begin
            Write('cod producto: '); read(p.codProd);
            if(v[p.codProd].stock<>0)then begin 
                if(p.cant<=v[p.codProd].stock)then begin
                    v[p.codProd].stock:=v[p.codProd].stock-p.cant;
                    //pre:=p.cant * v[p.codProd].precio;
                end    
                else begin
                    WriteLn('solo hay disponible ',v[p.codProd].stock);
                    p.cant:=v[p.codProd].stock;
                    //pre:=p.cant * v[p.codProd].precio;
                    //WriteLn('precio de compra: ',pre:2);
                    v[p.codProd].stock:=0;
                end;
            end 
            else begin
                writeln('no hay stock disponible.');
                p.cant:=-1;
            end;   
            p.precioU:=v[p.codProd].precio;
            WriteLn('precio producto: ',p.precioU:2);    
        end;
    end;
    procedure cargarProd(var l:listaProd; var v:vec);
    var nue:listaProd;
        p:prod;
    begin
        leerP(p,v);
        while(p.cant<>0)do begin
            new(nue);
            if(p.cant=-1)then
              p.cant:=0;
            nue^.dato:=p;
            nue^.sig:=l;
            l:=nue;
            leerP(p,v);
        end;
    end;

var nue:listaVent; 
    codVent:integer;
begin
    write('cod de venta <> -1: '); read(codVent);
    while(codVent<>-1)do begin 
        new(nue);
        nue^.codVent:=codVent;
        nue^.list:=nil;
        cargarProd(nue^.list,v);
        nue^.sig:=l;
        l:=nue;
        write('cod de venta <> -1: '); read(codVent);    
    end;
end;

procedure imprimirV(v:vec);
var i:Integer;
begin
    for i:=1 to df do begin
        Write('PROD',i);
        write(': precio: ',v[i].precio:2);
        WriteLn(', stock: ',v[i].stock);
    end;
end;
procedure imprLRec(l:listaVent);
    procedure imprDetalleRec(l:listaProd; var tot:Real);    
    begin
        if(l<>Nil)then begin
            Write('codProd:',l^.dato.codProd);
            Write(', cantidad:',l^.dato.cant);
            Write(', precioU:',l^.dato.precioU:2);
            WriteLn('precio',(l^.dato.cant*l^.dato.precioU):4);
            tot:=tot+(l^.dato.cant*l^.dato.precioU);

            l:=l^.sig;
            imprDetalleRec(l,tot);
        end;
    end; 
var 
    total:Real;       
begin
    if(l<>Nil)then begin
        WriteLn('codVenta:',l^.codVent);
        total:=0;
        imprDetalleRec(l^.list,total);
        WriteLn('total de la compra: ',total:4);
        l:=l^.sig;
        imprLRec(l);
    end;
end;

//PP------------------------------------------------
var v:vec;
    l:listaVent;
begin
    inicializarV(v);
    imprimirV(v);
    l:=nil;
    cargarVent(l,v); //A generar estructura de ventas de prod (tikets)
    imprimirV(v);
    imprLRec(l);

end.