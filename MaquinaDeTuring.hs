{-
TP Maquina de Turing. 3ro 2da B
Grupo: Cupo Marco, Giovacchini Sofía y Kleiman Ezequiel.
-}

--Función que devuelve el n-ésimo de una lista
term::([a],Int)->a
term (x:xs,0) = x
term (x:xs,n) = term(xs,n-1)

--Función que devuelve si un elemento pertenece a una lista de elementos
member :: (Eq a) => (a,[a]) -> Bool
member (_,[]) = False
member (n,(x:xs)) = n==x || member (n, xs)

--Función que devuelve la concatenación de 2 listas
append :: ([a],[a]) -> [a]
append ([],ys) = ys
append ((x:xs), ys) = x : (append(xs,ys))

--Función que reemplaza un elemento de una lista en una posición dada y devuelve la lista resultante
replace::([a],a,Int)->[a]
replace ([],_,_) = []
replace (x:xs,q,0) = q:xs
replace (x:xs,q,n)= x:replace(xs,q,n-1)

--Creación de tipos
type Estado = String
type Caracter = Char
type Movimiento = Char
type Cinta = [Char]
type Instruccion = (Estado,Caracter,Caracter,Estado,Movimiento)

--Constantes con tipos de errores
errorInstrucionInvalida :: String
errorInstrucionInvalida = "Error: las instrucciones no son validas."

errorEstadoInicialInvalido :: String
errorEstadoInicialInvalido = "Error: el estado inicial no es valido."

{-
Función que recibe una tupla de estados y una lista de estados y devuelve un bool indicando si 
los mismos forman parte de la lista
-}
estadosValidos::((Estado,Estado), [Estado])->Bool
estadosValidos ((q,q2),y) = member(q, y) && member(q2,y)

{-
Función que recibe un movimiento y una lista de movimientos y devuelve un bool indicando si 
este forma parte de la lista
-}
movimientoValido::(Movimiento, [Movimiento])->Bool
movimientoValido (m,y) = member(m,y)

{-
Función que recibe una instrucción, una lista de estados y una lista de movimientos 
y devuelve un Bool indicando si tanto sus estados como su movimientos son validos
-}
formatoValido::(Instruccion, [Estado], [Movimiento])->Bool
formatoValido ((q1,c1,c2,q2,m),q,ms) = estadosValidos((q1,q2),q) && movimientoValido(m,ms)

{-
Fución que valida que todas las instrucciones sean correctas

Tests unitarios
Positivo:
instruccionesValidas([("q0",'a','b',"q1","D"),("q0",'b','b',"q0","D")], ["q0","q1"], ["D","I","-"])
Negativo:
instruccionesValidas([("q5",'a','b',"q1","D"),("q0",'b','b',"q0","D")], ["q0","q1"], ["D","I","-"])
-}
instruccionesValidas::([Instruccion], [Estado], [Movimiento])->Bool
instruccionesValidas ([],q,m) = True
instruccionesValidas (x,[],m) = False
instruccionesValidas (x,q,[]) = False
instruccionesValidas (x:xs,q,m) = if formatoValido(x,q,m) then instruccionesValidas(xs,q,m) else False

--Función que recibe un estado y devuelve True si el mismo forma parte de la lista recibida
estadoInicialValido::(Estado,[Estado])->Bool
estadoInicialValido ("",_) = False
estadoInicialValido (_,[]) = False
estadoInicialValido (x,y) = member(x,y)

{--
Función que obtiene la instrucción correspondiente al estado actual y al 
caracter actual
--}
buscarInstruccion::(Estado,[Instruccion], Caracter)->Instruccion
buscarInstruccion (_,[],_) = ("",' ',' ',"",'S')
buscarInstruccion (q,(q1,c1,c2,q2,m):y,ccin) = 
	if q==q1 && ccin==c1 
	then
		(q1,c1,c2,q2,m)
	else
		buscarInstruccion(q,y,ccin)

--Función que recibe una cinta y la muestra
mostrarCinta::(Cinta,Int)->Cinta
mostrarCinta ([],_) = ""
mostrarCinta (x,_) = x

--Función que devuelve el nuevo estado correspondiente a una instruccion
nuevoEstado::(Instruccion)->Estado
nuevoEstado (q1,c1,c2,q2,m) = q2

{-
Función que recibe una instrución y una cinta, procesa dicha instrucción y 
devuelve la cinta resultante
-}
procesar::(Instruccion,(Cinta,Int))->(Cinta,Int)
procesar ((q1,c1,c2,q2,m),(cin,n)) = 
	if m=='D' 
	then 
		(replace(cin,c2,n),n+1) 
	else 
		if m=='I' 
		then 
			(replace(cin,c2,n),n-1) 
		else 
		(replace(cin,c2,n),n)

{-
Funcion que recibe un estado, una lista de instrucciones y una cinta
donde debe ejecutar dichas instrucciones
-}
ejecutar::(Estado,[Instruccion],(Cinta,Int)) -> Cinta
ejecutar (q,x,cin) = 
	if buscarInstruccion(q,x,term(cin))==("",' ',' ',"",'S') 
	then 
		mostrarCinta(cin) 
	else 
		ejecutar(nuevoEstado(buscarInstruccion(q,x,term(cin))), x, procesar(buscarInstruccion(q,x,term(cin)),cin))

{-
Función que recibe una lista de estados, caracteres válidos, estado inicial, instrucciones, 
movimientos y una Cinta, que devuelve una cinta del resultado de aplicar las instrucciones
-}
turing::([Estado],[Caracter],Estado, [Instruccion], [Movimiento], Cinta)->Cinta
turing (q,c,qi,x,m,cin) = 
	if estadoInicialValido(qi,q) 
	then 
		if instruccionesValidas(x,q,m) 
		then 
			ejecutar(qi,x,(cin,0)) 
		else 
			errorInstrucionInvalida
	else errorEstadoInicialInvalido

--Caso de prueba
--EJECUTAR
test::Cinta
test=turing(["q0","q1"],[' ','a','b'],"q0",[("q0",'a','b',"q0",'D'),("q0",'b','b',"q0",'D')],['D','I','-'],[' ', 'a','b',' '])

{-
Seguimiento

q=["q0","q1"]
c=[' ','a','b']
qi="q0"
x=[("q0",'a','b',"q0","D"),("q0",'b','b',"q0","D")]
m=["D","I","-"]
cin=['a','a',' ']

turing (q,c,qi,x,m,cin) =
		if estadoInicialValido(qi,q)=="True" DA TRUE
	then 
		if instruccionesValidas(x,q,m)=="True" DA TRUE
		then 
			ejecutar(qi,x,(cin,0)) ENTRA A LA FUNCION EJECUTAR
		...

q="q0"
x=[("q0",'a','b',"q0","D"),("q0",'b','b',"q0","D")]
cin=(['a','a',' '],0)
	
ejecutar (q,x,cin) = 
	if buscarInstruccion(q,x,term(cin))==("",' ',' ',"","S") FALSO, ENTRA POR EL ELSE
	then 
		mostrarCinta(cin) 
	else 
		ejecutar("q0", x, procesar(("q0",'a','b',"q0","D"),cin)) ENTRA A LA FUNCION PROCESAR

q1="q0"
c1='a'
c2='b'
q2="q0"
m="D"
cin=['a','a',' ']
n=0
	
procesar ((q1,c1,c2,q2,m),(cin,n)) = 
	if m=="D" DA TRUE
	then 
		(replace(cin,c2,n),n+1)
		(['b','a'],1)
	...
	
VUELVE A LA FUNCION EJECTUAR

q="q0"
x=[("q0",'a','b',"q0","D"),("q0",'b','b',"q0","D")]
cin=(['b','a',' '],1)

ejecutar (q,x,cin) = 
	if buscarInstruccion(q,x,term(cin))==("",' ',' ',"","S") FALSO, ENTRA POR EL ELSE
	then 
		mostrarCinta(cin) 
	else 
		ejecutar("q0", x, procesar(("q0",'a','b',"q0","D"),cin)) ENTRA A LA FUNCION PROCESAR
		
q1="q0"
c1='a'
c2='b'
q2="q0"
m="D"
cin=['b','a',' ']
n=1

procesar ((q1,c1,c2,q2,m),(cin,n)) = 
	if m=="D" DA TRUE
	then 
		(replace(cin,c2,n),n+1)
		(['b','b'],2)
	...
	
VUELVE A LA FUNCION EJECTUAR

q="q0"
x=[("q0",'a','b',"q0","D"),("q0",'b','b',"q0","D")]
cin=(['b','b',' '],2)

ejecutar (q,x,cin) = 
	if buscarInstruccion(q,x,term(cin))==("",' ',' ',"","S") ENTRA A LA FUNCION BUSCARINSTRUCCION Y DA TRUE
	then 
		mostrarCinta(cin) DEVUELVE LA CINTA PROCESADA
	...
-}