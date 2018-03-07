# Maquina De Turing

Maquina de Turing en Haskell.

# Desarrollo

Reutilización de funciones

Para el desarrollo del programa se utilizaron las siguientes funciones:
term: devuelve el n-ésimo de una lista
member: indica si un elemento pertenece a una lista
append: concatena 2 listas
replace: reemplaza un elemento de una lista

Creación de tipos

La creación de los tipos se realizó con la funcionalidad provista por haskell llamada type:
type Estado = String
type Caracter = Char
type Movimiento = String
type Cinta = [Char]
type Instruccion = (Estado,Caracter,Caracter,Estado,Movimiento)

Manejo de errores

El manejo de errores se realizó a través de funciones constantes:

errorInstrucionInvalida :: String
errorInstrucionInvalida = "Error: las instrucciones no son validas."

errorEstadoInicialInvalido :: String
errorEstadoInicialInvalido = "Error: el estado inicial no es valido."

Validación de instrucciones

Para la validación de las instrucciones se utilizaron funciones que validan estados y movimientos respectivamente, para luego ser llamadas por una única función que se encarga de validar ambas cosas. Adicionalmente, se utilizó una función para validar el estado inicial de la máquina.

Procesamiento de instrucciones

Si bien es algo bastante obvio, para las instrucciones se utilizó una 5-upla.
Para procesar las instrucciones, utilizamos una función para la búsqueda de instrucciones, en base al estado y carácter actual de la máquina.
Asumimos que la cinta es infinita y la tratamos como a una tupla, conteniendo una lista con la cinta propiamente dicha y la posición del cursor.
En cuanto a los cambios de estado, se utilizó una función que dada una instrucción, devolvía el nuevo estado.
Las instrucciones son procesadas por una función que recibe la instrucción propiamente dicha y la cinta en forma de tupla. Dependiendo del sentido en que se moverá la cinta, se avanzará, retrocederá o no se moverá el cursor, en cada caso se reemplazará el contenido de la cinta con lo que indique la instrucción.
Todas estas funciones serán llamadas por una función principal que de no encontrar la instrucción correspondiente, enviará la información de STOP a la máquina y la mostrará.
Por último, se contará con la función turing que debe recibir:
Lista de estados válidos
Lista de caracteres válidos
Estado inicial
Lista de instrucciones a ejecutarse
Lista de movimientos válidos
Tupla con la cinta
La que valiéndose de las funciones para validación, indicará si el estado inicial y las instrucciones son correctas, y de continuar, ejecutará la máquina.
