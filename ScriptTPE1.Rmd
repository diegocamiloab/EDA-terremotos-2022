---
title: "Proyecto 1 Taller de programacion"
author: "Diego Camilo Araque Barrera"
date: "2022-10-25"
output:
  pdf_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# **TALLER DE PROGRAMACIÓN** 

### Maestria en Métodos Cuantitativos para la Gestión y Análisis de Datos en Organizaciones 

### FACULTAD DE CIENCIAS ECONÓMICAS 

### UNIVERSIDAD DE BUENOS AIRES

### Asignatura: TALLER DE PROGRAMACIÓN Año Lectivo: 2022 

### Docentes: Rodrigo Del Rosso/Patricia Girimonte 

### Estudiante: Araque Barrera Diego Camilo

El dataset del análisis es tomado de la pagina del servicio Geológico de Estados Unidos USGS. Para ello se realizó una query de los eventos sisimicos que han ocurrido en el transcurso del 2022 al rededor del mundo

<https://earthquake.usgs.gov/earthquakes/search/>

```{r}
df=read.csv("query.csv",stringsAsFactors = TRUE)
```

## LIBRERÍAS

```{r}
#install.packages('stats') paquete con funciones estadisticas
library(stats)
#install.packages('NbClust') libreria para determinar el mejor numero de clusters de un DF
library(NbClust)
#install.packages('tidyverse') paquete con librerias disenadas para analis de datos como ggplot2, dplyr, tidyr, readr, purr, tibble, stringr y forcast
library(tidyverse)
#install.packages('factoextra') paquete para hacer analisis de PCA
library(factoextra)
#install.packages('clValid') paquete de R para realizar validacion de cluster
library(clValid)
#nstall.packages('corrplot') paquete de R para realizar correlaciones de variables
library(corrplot)
#install.packages('leaflet') paquete de R paraintegrar mapas interactivos de R
library(leaflet)
#install.packages('ggthemes') paquete de R graficar
library(ggthemes)
```

## DF DE TRABAJO

Se realiza como primera medida una visualización de los datos del DF

```{r}
head(df)
```

```{r}
str(df)
```

Las variables de la base de datos son

-   time = (string) fecha del evento, se utiliza el formato ISO8601 fecha/hora.

-   latitude =(Decimal [-90,90] grados) latitud que se utiliza para la ubicación del evento.

-   longitude = (Decimal [-180,180] grados)Longitud que se utiliza para la ubicación del evento.

-   depth =(Decimal) profundidad del evento en Km.

-   mag = (Decimal) Magnitud del evento.

-   magType = (String) El método o algoritmo utilizado para calcular la magnitud del evento.

-   nst = (Integer) número total de estaciones sísmicas utilizadas para determinar la ubicación del evento.

-   gap = (Decimal) La brecha azimutal más grande entre estaciones azimutalmente adyacentes (en grados). En general, cuanto más pequeño es este número, más confiable es la posición horizontal calculada del terremoto. Las ubicaciones de terremotos en las que la brecha azimutal supera los 180 grados suelen tener grandes incertidumbres de ubicación y profundidad.

-   dmin =(Decimal) Distancia horizontal desde el epicentro hasta la estación más cercana (en grados). 1 grado son aproximadamente 111,2 kilómetros. En general, cuanto menor sea este número, más confiable es la profundidad calculada del terremoto.

-   rms = (Decimal) Residual del tiempo de viaje de la raíz cuadrada media. Este parámetro proporciona una medida del ajuste de los tiempos de llegada observados a los tiempos de llegada previstos para esta ubicación. Los números más pequeños reflejan un mejor ajuste de los datos.

-   net =(String) El ID de la red de la fuente del dato.

-   id = (String) identificador del evento.

-   updated = (Integer) Hora en que se actualizó el evento por última vez.

-   place = (String) Descripción textual de la región geográfica nombrada cercana al evento.

-   type = (String) Tipo de evento sísmico.

-   horizontalError = (Decimal) El error de ubicación horizontal, en km, definido como la longitud de la mayor proyección de los tres errores principales en un plano horizontal.

-   depthError = (Decimal) El error de profundidad, en km, definido como la proyección más grande de los tres errores principales en una línea vertical.

-   magError = (Decimal) Incertidumbre de la magnitud reportada del evento.

-   magNst = (Enter) El número total de estaciones sísmicas utilizadas para calcular la magnitud de este terremoto.

-   status = (Integer) Código de estado HTTP de respuesta.

-   locationSource = (String) La red que originalmente creó la ubicación informada de este evento.

-   magSource = (String) Red que originó originalmente la magnitud informada de este evento.

Para un mayor entendimiento de las variables se van a renombrar al español:

-   time se convirtió a fecha

-   latitude se convirtió a latitud

-   longitude se convirtió a longitud

-   depth se convirtió a profundidad

-   mag se convirtió a magnitud

-   magType se convirtió a tipo_magnitud

-   nst se convirtió a n_estaciones_ubic

-   gap se convirtió a incertidumbre

-   dmin se convirtió a dmin

-   rms se convirtió a rms

-   net se convirtió a net

-   id se convirtió a id

-   updated se convirtió a actualización

-   place se convirtió a lugar

-   type se convirtió a tipo_evento

-   horizontalError Se convirtió a error_horizontal

-   depthError Se convirtió a error_profunidad

-   magError Se convirtió a error_magnitud

-   magNst Se convirtió a n_estaciones_mag

-   status Se convirtió a status

-   locationSource Se convirtió a red_evento_ubic

-   magSource Se convirtió a red_evento_mag

```{r}
colnames(df) = c("fecha","latitud","longitud","profundidad", "magnitud","tipo_magnitud","n_estaciones_ubic","incertidumbre","dmin","rms","net","id","actualización","lugar","tipo_evento","error_horizontal","error_profundidad","error_magnitud","n_estaciones_mag","status","red_evento_ubic","red_evento_mag")
```

```{r}
head(df)
```

Muchas de las variables no están involucradas en en análisis que se desea plantear por ello se reajustara el DF con las variables de interés que serán:

-   latitud

-   longitud

-   profundidad

-   magnitud

-   tipo_magnitud

-   incertidumbre

-   lugar

-   tipo_evento

-   n_estaciones_ubic

-   n_estaciones_mag

-   error_magnitud

-   error_profunidad

```{r}
DF_trabajo = select(df,latitud,longitud,profundidad,magnitud,tipo_magnitud,incertidumbre,tipo_evento,n_estaciones_ubic,n_estaciones_mag,error_magnitud,error_profundidad)
```

Ahora se analizan si se tienen NA en el DF de trabajo:

```{r}
sum(is.na(DF_trabajo))
```

Se tienen 6400 elementos nulos. Al hacer una visualización de estos datos faltantes se evidencia que están asociados a variables donde el valor nulo indica 0 elementos, un ejemplo es número de estaciones o incertidumbre, por eso se decide remplazar los elementos nulos por 0.

```{r}
DF_trabajo[is.na(DF_trabajo)] = 0
```

Se verifica nuevamente que no se tengan NA

```{r}
sum(is.na(DF_trabajo))
```

## AN**Á**LISIS ESTAD**Í**STICO

Ya que no se cuentan con elementos faltantes se realizar un análisis estadístico de las variables:

-   Media

```{r}
mean_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,mean)
mean_info=as.data.frame(mean_info)
mean_info
```

-   Mínimo

```{r}
min_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,min)
min_info=as.data.frame(min_info)
min_info
```

-   Máximo

```{r}
max_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,max)
max_info=as.data.frame(max_info)
max_info
```

-   Mediana

```{r}
median_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,median)
median_info=as.data.frame(median_info)
median_info
```

-   Desviación

```{r}
sd_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,sd)
sd_info=as.data.frame(sd_info)
sd_info
```

-   Longitud

```{r}
length_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,length)
length_info=as.data.frame(length_info)
length_info
```

-   Varianza

```{r}
var_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,var)
var_info=as.data.frame(var_info)
var_info
```

-   Quantiles

```{r}
quantil_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,quantile)
quantil_info=as.data.frame(quantil_info)
quantil_info
```

-   IQR

```{r}
IQR_info=apply(DF_trabajo[c("magnitud","profundidad","incertidumbre","n_estaciones_ubic","n_estaciones_mag","error_magnitud","error_profundidad")],2,IQR)
IQR_info=as.data.frame(IQR_info)
IQR_info
```

-   Tabla

```{r}
tabla_estadistica=cbind(mean_info,min_info,max_info,median_info,sd_info,length_info,var_info,IQR_info)
tabla_estadistica
```

Ahora se exportan las tablas para el documento final

```{r}
#write.csv(tabla_estadistica, file="tabla.csv")
#write.csv(quantil_info, file="quantil.csv")
```

## **ANALISIS GRAFICO**

Para entender el conjunto de datos se hará un análisis de Sctarplot de las variables numéricas, para ver algún patrón de correlación

```{r}
ggplot(DF_trabajo, aes(x=latitud, y=longitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Latitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Longitud")
ggplot(DF_trabajo, aes(x=latitud, y=profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Profundidad")
ggplot(DF_trabajo, aes(x=latitud, y=magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Magnitud")
ggplot(DF_trabajo, aes(x=latitud, y=incertidumbre)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Incertidumbre")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Incertidumbre")
ggplot(DF_trabajo, aes(x=latitud, y=n_estaciones_ubic)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Número de estaciones para ubicación")
ggplot(DF_trabajo, aes(x=latitud, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Número de estaciones para determinar la magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Número de estaciones para determinar la magnitud")
ggplot(DF_trabajo, aes(x=latitud, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=latitud, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Latitud vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Latitud") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=longitud, y=profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Profundidad")
ggplot(DF_trabajo, aes(x=longitud, y=magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Magnitud")
ggplot(DF_trabajo, aes(x=longitud, y=incertidumbre)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Incertidumbre")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Incertidumbre")
ggplot(DF_trabajo, aes(x=longitud, y=n_estaciones_ubic)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Número de estaciones para ubicación")
ggplot(DF_trabajo, aes(x=longitud, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Número de estaciones para magnitud")
ggplot(DF_trabajo, aes(x=longitud, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=longitud, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Longitud vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Longitud") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=profundidad, y=magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Magnitud")
ggplot(DF_trabajo, aes(x=profundidad, y=incertidumbre)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Incertidumbre")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Incertidumbre")
ggplot(DF_trabajo, aes(x=profundidad, y=n_estaciones_ubic)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Número de estaciones para ubicación")
ggplot(DF_trabajo, aes(x=profundidad, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Número de estaciones para magnitud")
ggplot(DF_trabajo, aes(x=profundidad, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=profundidad, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=magnitud, y=incertidumbre)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Incertidumbre")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Incertidumbre")
ggplot(DF_trabajo, aes(x=magnitud, y=n_estaciones_ubic)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Número de estaciones para ubicación")
ggplot(DF_trabajo, aes(x=magnitud, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Número de estaciones para magnitud")
ggplot(DF_trabajo, aes(x=magnitud, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=magnitud, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=incertidumbre, y=n_estaciones_ubic)) + 
  geom_point(color="darksalmon")+ labs(title = "Incertidumbre vs Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Incertidumbre") + ylab("Número de estaciones para ubicación")
ggplot(DF_trabajo, aes(x=incertidumbre, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Incertidumbre vs Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Incertidumbre") + ylab("Número de estaciones para magnitud")
ggplot(DF_trabajo, aes(x=incertidumbre, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Incertidumbre vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Incertidumbre") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=incertidumbre, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Incertidumbre vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Incertidumbre") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=n_estaciones_ubic, y=n_estaciones_mag)) + 
  geom_point(color="darksalmon")+ labs(title = "Número de estaciones para ubicación vs Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Número de estaciones para ubicación") + ylab("Número de estaciones para magnitud")
ggplot(DF_trabajo, aes(x=n_estaciones_ubic, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Número de estaciones para ubicación vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Número de estaciones para ubicación") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=n_estaciones_ubic, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Número de estaciones para ubicación vs Error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Número de estaciones para ubicación") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=n_estaciones_mag, y=error_magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Número de estaciones para magnitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Número de estaciones para magnitud") + ylab("Error en magnitud")
ggplot(DF_trabajo, aes(x=n_estaciones_mag, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Número de estaciones para magnitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Número de estaciones para profundidad") + ylab("Error en profundidad")
ggplot(DF_trabajo, aes(x=error_magnitud, y=error_profundidad)) + 
  geom_point(color="darksalmon")+ labs(title = "Error en magnitud vs Error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Error en magnitud") + ylab("Error en profundidad")
```

Se descargan las gráficas para informe final

```{r}
jpeg("grafica_profundidadvsmagnitud.jpeg", quality = 100)
ggplot(DF_trabajo, aes(x=profundidad, y=magnitud)) + 
  geom_point(color="darksalmon")+ labs(title = "Profundidad vs Magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Profundidad") + ylab("Magnitud")
dev.off()
jpeg("grafica_magnitudvsincertidumbre.jpeg", quality = 100)
ggplot(DF_trabajo, aes(x=magnitud, y=incertidumbre)) + 
  geom_point(color="darksalmon")+ labs(title = "Magnitud vs Incertidumbre")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black")) + xlab("Magnitud") + ylab("Incertidumbre")
dev.off()
```

También se realiza un análisis de frecuencia de las variables numéricas con histogramas

```{r}
ggplot(data = DF_trabajo,aes(latitud)) + geom_histogram( binwidth = 1,alpha=0.9,
                 color="black",fill="darksalmon") + xlab("latitud") + ylab("Frecuencia")+ labs(title = "Frecuencia de latitud ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(longitud)) + geom_histogram( binwidth = 10,alpha=0.9,
                 color="black",fill="darksalmon") + xlab("longitud") + ylab("Frecuencia")+ labs(title = "Frecuencia de logitud ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(profundidad)) + geom_histogram( binwidth = 8,alpha=0.9,color="black",fill="darksalmon") + xlab("Profunidad(km)") + ylab("Frecuencia")+ labs(title = "Frecuencia de profundidad ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(magnitud)) + geom_histogram( binwidth = 0.1,alpha=0.9,color="black",fill="darksalmon") + xlab("Magnitud") + ylab("Frecuencia")+ labs(title = "Frecuencia de magnitud ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(incertidumbre)) + geom_histogram( binwidth = 10,alpha=0.9,color="black",fill="darksalmon") + xlab("incertidumbre") + ylab("Frecuencia")+ labs(title = "Frecuencia de incertidumbre ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(n_estaciones_ubic)) + geom_histogram( binwidth = 10,alpha=0.9,color="black",fill="darksalmon") + xlab("Num de estaciones para ubicación") + ylab("Frecuencia")+ labs(title = "Frecuencia de Número de estaciones para ubicación")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(n_estaciones_mag)) + geom_histogram( binwidth = 10,alpha=0.9,color="black",fill="darksalmon") + xlab("Num de estaciones para magnitud") + ylab("Frecuencia")+ labs(title = "Frecuencia de Número de estaciones para magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(error_magnitud)) + geom_histogram( binwidth = 0.01,alpha=0.9,color="black",fill="darksalmon") + xlab("Error en magnitud") + ylab("Frecuencia") + labs(title = "Frecuencia de error en magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo,aes(error_profundidad)) + geom_histogram( binwidth = 1,alpha=0.9,color="black",fill="darksalmon") + xlab("Error en profundidad") + ylab("Frecuencia") + labs(title = "Frecuencia de error en profundidad")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
```

Se descargan las gráficas para informe final

```{r}
jpeg("grafica_profundidad.jpeg", quality = 100)
ggplot(data = DF_trabajo,aes(profundidad)) + geom_histogram( binwidth = 8,alpha=0.9,color="black",fill="darksalmon") + xlab("Profunidad(km)") + ylab("Frecuencia")+ labs(title = "Frecuencia de profundidad ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
dev.off()
jpeg("grafica_magnitud.jpeg", quality = 100)
ggplot(data = DF_trabajo,aes(magnitud)) + geom_histogram( binwidth = 0.1,alpha=0.9,color="black",fill="darksalmon") + xlab("Magnitud") + ylab("Frecuencia")+ labs(title = "Frecuencia de magnitud ")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
dev.off()
```

Para las variables cualitativas se realiza un análisis de frecuencia con barplot

```{r}
g = ggplot(DF_trabajo, aes(tipo_magnitud) ) +
  labs(title = "Tipo de magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
g+geom_bar(position="dodge",alpha=0.9,color="black",fill="darksalmon")  + xlab("Tipo de Magnitud") + ylab("Frecuencia")  
g = ggplot(DF_trabajo, aes(tipo_evento) ) +
  labs(title = "Tipo evento")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
g+geom_bar(position="dodge",alpha=0.9,color="black",fill="darksalmon")  + xlab("Tipo de evento") + ylab("Frecuencia")  
```

Se descargan las gráficas para informe final

```{r}
jpeg("graficatipodemagnitud.jpeg", quality = 100)
g = ggplot(DF_trabajo, aes(tipo_magnitud) ) +
  labs(title = "Tipo de magnitud")+
  theme(plot.title = element_text(hjust = 0.5, colour = "black"))
g+geom_bar(position="dodge",alpha=0.9,color="black",fill="darksalmon")  + xlab("Tipo de Magnitud") + ylab("Frecuencia") 
dev.off()
```

Visualización de Boxplot entre las dos variables con mayor peso en el análisis (profundidad y magnitud) y la variable categórica tipo de magnitud

```{r}
ggplot(data = DF_trabajo, aes(x = tipo_magnitud, y = magnitud))+ stat_boxplot(geom = "errorbar", width = 0.2) +
       geom_boxplot(fill = "darksalmon", colour = "#1F3552", # Colores
                    alpha = 0.9, outlier.colour = "red")+
scale_y_continuous(name = "Magnitud") +  
       scale_x_discrete(name = "Tipo de Magnitud") +       
       ggtitle("Analisis de magnitud vs tipo de magnitud")+theme(plot.title = element_text(hjust = 0.5, colour = "black"))
ggplot(data = DF_trabajo, aes(x = tipo_magnitud, y = profundidad))+ stat_boxplot(geom = "errorbar", width = 0.2) +
       geom_boxplot(fill = "darksalmon", colour = "#1F3552", # Colores
                    alpha = 0.9, outlier.colour = "red")+
scale_y_continuous(name = "profundidad") +  
       scale_x_discrete(name = "Tipo de Magnitud") +       
       ggtitle("Analisis de profundidad vs tipo de magnitud")+theme(plot.title = element_text(hjust = 0.5, colour = "black"))
```

Se descargan las gráficas para informe final

```{r}
jpeg("boxplot_tipo_magnitud.jpeg", quality = 100)
ggplot(data = DF_trabajo, aes(x = tipo_magnitud, y = magnitud))+ stat_boxplot(geom = "errorbar", width = 0.2) +
       geom_boxplot(fill = "darksalmon", colour = "#1F3552", # Colores
                    alpha = 0.9, outlier.colour = "red")+
scale_y_continuous(name = "Magnitud") +  
       scale_x_discrete(name = "Tipo de Magnitud") +       
       ggtitle("Analisis de magnitud vs tipo de magnitud")+theme(plot.title = element_text(hjust = 0.5, colour = "black"))
dev.off()
```

## **ANALISIS GEOESPACIAL**

Para hacer el análisis de las variables longitud y latitud se utiliza una visualización con mapa y ver la distribución de los eventos geograficamente

```{r}
mapa_mundo <- map_data("world")
mapa_mundo %>%
  ggplot() +
  geom_polygon(aes( x= long, y = lat, group = group),
               fill = "grey80",
               color = "white") +
  geom_point(data= DF_trabajo, 
             aes(x=longitud, y = latitud,  color = magnitud), 
             stroke = F) +
  
  scale_color_gradient(low= "yellow", high= "red", name= "magnitud")+
  
  ggtitle( "EVENTOS SISMICOS EN EL 2022") +theme(plot.title = element_text(hjust = 0.5, colour = "black"))
  theme_map()
```

## **ANALISIS INTERACTIVO DE LOS EVENTOS**

Para completar la visualización geográfica se utiliza un mapa interactivo para ver la relación geográfica, la magnitud y la localización registrada en el DF

```{r}
paleta=colorBin( palette="YlOrBr", domain=df$magnitud, na.color="transparent")
texto = paste(
   "Profundidad: ", df$profundidad, "<br/>", 
   "Lugar: ", df$lugar, "<br/>", 
   "Magnitud: ", df$magnitud, sep="") %>%
  lapply(htmltools::HTML)
mapa = leaflet(DF_trabajo) %>% 
  addTiles()  %>% 
  addCircleMarkers(~longitud, ~latitud, 
    fillColor = ~paleta(df$magnitud), fillOpacity = 0.9, color="black", radius=7, stroke=FALSE,
    label = texto,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) %>%
  addLegend( pal=paleta, values=~magnitud, opacity=0.9, title = "Magnitud", position = "bottomright" ) 
mapa
```

## CORRELACION DE VARIABLES **NUMÉRICAS**

Para hacer un análisis de correlación primero se debe dejar solo las variables cuantitativas

```{r}
DF_numerico = select(DF_trabajo,latitud,longitud,profundidad,magnitud,incertidumbre,n_estaciones_ubic,n_estaciones_mag,error_magnitud,error_profundidad)
```

Se realiza la visualización de las correlación entre variables numéricas

```{r}
corrplot(cor(DF_numerico),method ="shade", shade.col = NA, tl.col = "black", tl.srt = 45,diag = F,type = "lower",addCoef.col = "black" ) 
```

Ahora se realizar un análisis de PCA como complemento a los análisis de correlación

```{r}
a_pca=prcomp(DF_numerico, scale = TRUE)
a_pca
```

```{r}
summary(a_pca)
```

```{r}
fviz_eig(a_pca,barfill="darksalmon",main="Varianza explicada",xlab="Dimensiones",ylab="Porcentaje de la varianza explicada") 
```

```{r}
fviz_pca_ind(a_pca,
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = FALSE,     
             title = "Analisis de PCA de los eventos con el Cos2"
)
```

```{r}
fviz_pca_var(a_pca,
             col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,
              title = "Analisis de PCA de las variables y su contribución"
)
```
