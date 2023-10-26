{Implementar un programa modularizado para una librería que:
a. Almacene los productos vendidos en una estructura eficiente para la búsqueda por código de producto. De cada producto deben quedar almacenados la cantidad total 
de unidades vendidas y el monto total. De cada venta se lee código de venta, código del producto vendido, cantidad de unidades vendidas y precio unitario. 
El ingreso de las ventas finaliza cuando se lee el código de venta -1.
b. Imprima el contenido del árbol ordenado por código de producto.
c. Contenga un módulo que reciba la estructura generada en el punto a y retorne el código de producto con mayor cantidad de unidades vendidas.
d. Contenga un módulo que reciba la estructura generada en el punto a y un código de producto y retorne la cantidad de códigos menores que él que hay en la 
estructura.
e. Contenga un módulo que reciba la estructura generada en el punto a y dos códigos de producto y retorne el monto total entre todos los códigos de productos 
comprendidos entre los dos valores recibidos (sin incluir).
}

Program p4.ej1;
type rangoEdad = 12..100;
     cadena15 = string [15];
     venta = record
               codigoVenta: integer;
               codigoProducto: integer;
               cantUnidades: integer;
               precioUnitario: real;
             end;
     productoVendido = record
                         codigo: integer;
                         cantTotalUnidades: integer;
                         montoTotal: real;
                       end;
     arbol = ^nodoArbol;
     nodoArbol = record
                    dato: productoVendido;
                    HI: arbol;
                    HD: arbol;
                 end;
//PROCESOS-------------------------------------------------
//generar A---------------------------------
procedure ModuloA (var a: arbol);
{ Almacene los productos vendidos en una estructura eficiente para la búsqueda por código de producto. De cada producto deben quedar almacenados la cantidad total 
de unidades vendidas y el monto total. }
    Procedure LeerVenta (var v: venta);
    begin
      write ('Ingrese codigo de venta <>-1: ');
      readln (v.codigoVenta);
      If(v.codigoVenta<> -1)then begin
          write ('Ingrese codProducto: ');
          readln (v.codigoProducto);
          write ('Ingrese cantUnidades: ');
          readln (v.cantUnidades);
          write ('Ingrese precioUnitario: ');
          readln (v.precioUnitario);
      end;
    end;      
    Procedure InsertarElemento (var a: arbol; elem: venta);
      Procedure ArmarProducto (var p: productoVendido; v: venta);
      begin
        p.codigo:= v.codigoProducto;
        p.cantTotalUnidades:= v.cantUnidades;
        p.montoTotal:= v.cantUnidades * v.precioUnitario;
      end;
    var p: productoVendido;
    Begin
      if(a= nil)then begin
          new(a);
          ArmarProducto (p, elem);
          a^.dato:= p; 
          a^.HI:= nil; 
          a^.HD:= nil;
      end
      else if (elem.codigoProducto= a^.dato.codigo)then begin
              a^.dato.cantTotalUnidades:=a^.dato.cantTotalUnidades+ elem.cantUnidades;
              a^.dato.montoTotal:=a^.dato.montoTotal+(elem.cantUnidades* elem.precioUnitario);
          end
          else if(elem.codigoProducto< a^.dato.codigo)then 
                  InsertarElemento(a^.HI, elem)
               else 
                  InsertarElemento(a^.HD, elem); 
    End;
var unaVenta: venta;  
Begin
  writeln ('Ingreso de ventas y armado de arbol de productos.');
  a:= nil;
  LeerVenta(unaVenta);
  while(unaVenta.codigoVenta<> -1)do begin
      InsertarElemento(a,unaVenta);
      LeerVenta (unaVenta);
  end;
end;
//imprimir B---------------------------------------------
procedure ModuloB (a: arbol);
{ Imprima el contenido del árbol ordenado por código de producto.}
    procedure ImprimirArbol (a: arbol);
    begin
      if(a<> nil)then begin
        if (a^.HI <> nil) then ImprimirArbol (a^.HI);
        writeln ('Codigo producto: ',a^.dato.codigo,
                ' cantidad unidades: ',a^.dato.cantTotalUnidades,
                ' monto: ',a^.dato.montoTotal:2:2);
        if (a^.HD <> nil) then ImprimirArbol (a^.HD);
      end;
    end;
begin
   writeln ('imprimir arbol-----------------------');
  if(a= nil)then 
      writeln ('Arbol vacio')
  else 
      ImprimirArbol (a);
end;
//mayor cant de unidades vendidas C---------------------
procedure ModuloC (a: arbol);
{Contenga un módulo que reciba la estructura generada en el punto a y retorne el código de producto con mayor cantidad de unidades vendidas.}
    procedure maximo(a:arbol; var maxCant:integer; var maxCod:integer);
    begin
      if(a<> nil)then begin
        if (a^.HI <> nil) then maximo(a^.HI,maxCant,maxCod);
        if(a^.dato.cantTotalUnidades>maxCant)then begin
            maxCod:=a^.dato.codigo;
            maxCant:=a^.dato.cantTotalUnidades;
        end;    
        if (a^.HD <> nil) then maximo(a^.HD,maxCant,maxCod);
      end;
    end;   
var maxCant, maxCod: integer;
begin
    writeln ('----- Modulo C ----->'); 
    maxCant := -1;
    maximo (a, maxCant, maxCod);
    if(maxCant= -1)then 
        writeln('Arbol sin elementos')
    else begin
        writeln('CodProducto con mayor cant unidades vendidas:',maxCod);
    end;
end;
//cantidad de cod menor al ingresado D-----------------------
procedure ModuloD (a: arbol);
{ Contenga un módulo que reciba la estructura generada en el punto a y un código de producto y retorne la cantidad de códigos menores que él que hay en la 
estructura. }  
  function Menores(a:arbol; unCodigo: integer): integer;
  begin
      if(a<> nil)then begin
        //if (a^.HI <> nil) then Menores(a^.HI,unCodigo);
        if(a^.dato.codigo< unCodigo)then begin
            Menores:=Menores(a^.HI,unCodigo)+Menores(a^.HD,unCodigo)+1;
            //Menores:=Menores+ 1;
        end
        else if(a^.dato.codigo>= unCodigo)then
                Menores:=Menores(a^.HI,unCodigo);
        //if (a^.HD <> nil) then Menores(a^.HD,unCodigo);
      end
      else 
        Menores:=0;
  end;
var unCodigo, cantCodigos: integer;
begin
    writeln ('----- Modulo D ----->');
    write ('Ingrese codigo de producto para buscar los menores: ');
    readln(unCodigo);
    cantCodigos:=Menores(a,unCodigo);
    if(cantCodigos= 0)then 
        writeln('No hay codigos menores al codigo ',unCodigo)
    else begin
        writeln('La cant de codigos menores a',unCodigo,' es:',cantCodigos); 
    end;
end;
//recorrido acotado E----------------------
procedure ModuloE(a:arbol);
{ Contenga un módulo que reciba la estructura generada en el punto a y dos códigos de producto y retorne el monto total entre todos los códigos de productos 
comprendidos entre los dos valores recibidos (sin incluir). }
  function MontoTotal(a:arbol; cod1,cod2:integer):real;
  begin
    if(a<> nil)then begin
        //if (a^.HI <> nil) then Menores(a^.HI,unCodigo);
        if(a^.dato.codigo> cod1)then
            if(a^.dato.codigo< cod2)then
                MontoTotal:=MontoTotal(a^.HI,cod1,cod2)+MontoTotal(a^.HD,cod1,cod2)+a^.dato.montoTotal
            else 
                MontoTotal:=MontoTotal(a^.HI,cod1,cod2)
        else 
            MontoTotal:=MontoTotal(a^.HD,cod1,cod2);
    end
    else 
        MontoTotal:=0;
  end;
   
var codigo1,codigo2: integer;
    Total:real;
begin
  writeln ('----- Modulo E ----->');
  write ('Ingrese primer codigo de producto: ');
  readln (codigo1);
  write ('Ingrese segundo codigo de producto (mayor al primer codigo): ');
  readln (codigo2);
  Total:=MontoTotal(a,codigo1,codigo2);
  if(Total= 0)then 
      writeln ('No hay codigos entre ', codigo1, ' y ', codigo2)
  else begin
      writeln('El monto total entre ',codigo1,' y :',codigo2,' es:',Total:2:2); 
   end;
end;

//PP-------------------------------------------------------
var a: arbol; 
Begin
  ModuloA (a);
  ModuloB (a);
  ModuloC (a);
  ModuloD (a);
  ModuloE (a);  
End.
