# EDA-terremotos-2022

Los Datos que se utilizan en este análisis son tomados de la página del servicio Geológico de Estados Unidos. En estos se muestran  el histórico de los eventos sísmicos que han ocurrido en el 2022 alrededor del mundo. 

https://earthquake.usgs.gov/earthquakes/search/

Este conjunto de datos consta de 13726 observaciones y 22 variables. Las variables son:
-   Time (string) fecha del evento, se utiliza el formato ISO8601 fecha/hora.
-   Latitude (Decimal [-90,90] grados) latitud que se utiliza para la ubicación del evento.
-   Longitude (Decimal [-180,180] grados) longitud que se utiliza para la ubicación del evento.
-   Depth (Decimal) profundidad del evento en Km.
-   Mag  (Decimal) Magnitud del evento.
-   MagType (String) el método o algoritmo utilizado para calcular la magnitud del evento. Se tienen 6 principales mecanismos de medición. Magnitud Local (ML) es la misma escala de Richter, Magnitud de Ondas Superficiales (MS), magnitud de Ondas de Cuerpo (mb), magnitud Momento (MW), Magnitud Energía (Me), magnitud de duración (Md) .
-   Nst (Integer) número total de estaciones sísmicas utilizadas para determinar la ubicación del evento.
-   Gap (Decimal) la brecha azimutal más grande entre estaciones azimutalmente adyacentes (en grados). En general, cuanto más pequeño es este número, más confiable es la posición horizontal calculada del terremoto. Las ubicaciones de terremotos en las que la brecha azimutal supera los 180 grados suelen tener grandes incertidumbres de ubicación y profundidad.
-   Dmin (Decimal) distancia horizontal desde el epicentro hasta la estación más cercana (en grados). 1 grado son aproximadamente 111,2 kilómetros. En general, cuanto menor sea este número, más confiable es la profundidad calculada del terremoto.
-   Rms (Decimal) residual del tiempo de viaje de la raíz cuadrada media. Este parámetro proporciona una medida del ajuste de los tiempos de llegada observados a los tiempos de llegada previstos para esta ubicación. Los números más pequeños reflejan un mejor ajuste de los datos.
-   Net (String) el ID de la red de la fuente del dato.
-   Id (String) identificador del evento.
-   Updated (Integer) fecha en que se actualizó el evento por última vez.
-   Place (String) descripción textual de la región geográfica nombrada cercana al evento.
-   Type (String) tipo de evento sísmico.
-   HorizontalError (Decimal) el error de ubicación horizontal, en km, definido como la longitud de la mayor proyección de los tres errores principales en un plano horizontal.
-   DepthError (Decimal) el error de profundidad, en km, definido como la proyección más grande de los tres errores principales en una línea vertical.
-   MagError (Decimal) incertidumbre de la magnitud reportada del evento.
-   MagNst (Enter) el número total de estaciones sísmicas utilizadas para calcular la magnitud de este terremoto.
-   Status (Integer) código de estado HTTP de respuesta.
-   LocationSource (String) la red que originalmente creó la ubicación informada de este evento.
-   MagSource (String) red que originó originalmente la magnitud informada de este evento.
