#include <ctype.h> 
//Definimos el pin de interrupción
#define interrupcion 2
/*Variables para control de tiempo y contador para calculo de las RPM*/
unsigned long T = 0;
long int cont = 0;
/*Numero de pulsos por vuelta*/
const int n = 4;
/*periodo de muestreo*/
const int muestreo = 5000;
/*Variable donde se almacenara la lectura del sensor*/
int sensor;
/*Variable para calculo de RPM y velocidad*/
int RPM = 0;
float velocidad;


//Variables de la recta de regresión
float b=0.0762108262;

//Variables auxiliares
int suma;
String comando;
int contador=0;
/* Por defecto la velocidad máxima es de 30 km/h*/
int vel_max=30;

int analizar_comando(String com) {
  //La función permite analizar el comando ingresado a través del puerto serie
  //Si el comando ingresado es V, la velocidad máxima permitida cambia al valor numérico que sigue al comando.
  //Si el comando ingresado es C, se devuelve el valor de la velocidad máxima permitida.

  //En caso de que el comando ingresado sea V, la función devuelve la nueva velocidad máxima permitida.
  //En caso de un error en el formato del comando o de que el comando ingresado sea C, la función devuelve -1.
  
  bool valido=false;
  String vel_ingresada;
  int vel;
  //Serial.println(com);
  if(com[0]==':'){
    if(com[1]=='V') {
      //El comando ingresado permite cambiar la velocidad máxima permitida.
      valido=true;
      for(int i=2; i<com.length(); i++) {
        if(isdigit(com[i])) {
          vel_ingresada += com[i];         
        } else {
         valido=false;
         break;
        }
      }
    }
    else if(com[1]=='C' && com.length()==2) {
      // El comando ingresado permite consultar la velocidad máxima permitida.
      Serial.print(":C");
      Serial.println(vel_max);
      return -1;
    }
  }
  if(valido){
    vel=vel_ingresada.toInt();
    return vel;
  } else {
    Serial.println("El comando ingresado no es válido");
    return -1;
  }

}


void setup() {
  Serial.begin(9600);
  //Establecemos como entrada el pin digital del optoacoplador TCST 2103
  pinMode(2,INPUT);
  pinMode(LED_BUILTIN,OUTPUT);
  //Establecemos como entrada los 3 pines a los que se encuentran conectados los sensores CNY70
  pinMode(8, INPUT);
  pinMode(11, INPUT);
  pinMode(10, INPUT);
  //Definimos la interrupción en el pin 2, que llamará a la función sensorA() cuando el pin pasa de nivel bajo a nivel alto.
  attachInterrupt(digitalPinToInterrupt(interrupcion), sensorA, RISING);
}

void loop() {
 while (Serial.available() > 0) {
    //Mientras haya datos disponibles en el buffer serial
    delay(25);
    //Leemos carácter por carácter
    char buf = Serial.read();
    if(buf != '\n' && buf != '\r') {
      //Si todavía no encuentra el fin del comando le suma el carácter leído a la variable comando
      comando += buf;
    }
 }
 if(comando.length()>0) {
  //Si se ingresó algún comando
   Serial.println(comando); //Imprimimos el comando
   if(analizar_comando(comando) != -1) {
    //Si analizar_comando(comando) != 1 significa que se modificó la velocidad máxima permitida
     vel_max=analizar_comando(comando); //Actualizamos el valor de la velocidad máxima
     /*
     Serial.print("La nueva velocidad máxima es: ");
     Serial.print(vel_max);
     Serial.println(" km/h.");
     */
   }
   comando=""; //Reiniciamos la variable comando, haciéndola nula
 }
 
 suma=0;
 // Leemos los 3 sensores CNY70 y formamos el valor de suma como si cada sensor representara un bit
  if(digitalRead(8)) {
    suma=suma+1;
  }
  if(digitalRead(11)) {
    suma=suma+2;
  }
  if(digitalRead(10)) {
    suma=suma+4;
  }
 
 
 if (millis() >= T+muestreo){
    /*Para el calculo de las RPM, todo lo haremos en mS
    el muestreo se realizara cada segundo por tanto 1000 mS = 1S
    y un minuto es 60000mS = 60S*/
    RPM = cont*60000/(n*muestreo);
    velocidad = b*RPM; //Velocidad en km/h
    //Comenzamos a enviar el mensaje hacia la PC a través del puerto serie
    Serial.print(":");
    Serial.print(velocidad);
    Serial.print("-");
    Serial.print(RPM);
    //Serial.print("CONT: ");
    //Serial.println(cont);
    Serial.print("-");
    switch(suma) {
      case 0:
        Serial.println("Suroeste");
        break;
      case 1:
        Serial.println("Norte");
        break;
      case 2:
        Serial.println("Sur");
        break;
      case 3:
        Serial.println("Noreste");
        break;
      case 4:
        Serial.println("Oeste");
        break;
      case 5:
        Serial.println("Noroeste");
        break;
      case 6:
        Serial.println("Sureste");
        break;
      case 7:
        Serial.println("Este");
        break;
    }
    // Si la velocidad es mayor a la velocidad máxima permitida, se activa la alarma, sino se desactiva.
    if(velocidad > vel_max) {
      tone(9, 500);
    }
    else {
      noTone(9);
    }
    //Hacemos de nuevo cero al contador de pulsos.
    cont = 0;
    //Actualizamos la variable auxiliar T con el tiempo actual.
    T = millis(); 
 }
}

void sensorA(){
  sensor = digitalRead(interrupcion);
  if (sensor == 1){
    digitalWrite(LED_BUILTIN,HIGH);
    cont++; 
  }
  else{
    digitalWrite(LED_BUILTIN,LOW);
  }
}
 
