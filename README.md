# Motor de Evaluación Comparativa para el Problema de Localización de Microhubs y Asignación Peatonal (TMLPA)

Este repositorio contiene un entorno de evaluación académica completamente reproducible, diseñado para optimizar la localización y la asignación peatonal de microhubs temporales en operaciones de logística de última milla. 
El proyecto evalúa el rendimiento de una variante avanzada del **Algoritmo de la Morsa Binario (BWO)** frente a una línea base tradicional de **Optimización por Enjambre de Partículas Binario (BPSO)**[cite: 580]. [cite_start]Ambas metaheurísticas son validadas exhaustivamente mediante la comparación directa con los límites matemáticos exactos globales recopilados a través del motor de programación lineal entera mixta (MILP) **HiGHS** en la plataforma MiniZinc.

---

## Estructura del Directorio del Repositorio

```text
.
├── README.md                                 # Manual operativo y guía de replicación
├── TMLPA_Optimization.ipynb                  # Notebook Jupyter principal con los solucionadores y el motor ejecutor
├── results_summary.txt                       # Registro central de datos consolidados (Descriptivos e Inferenciales)
├── execution_results/                        # Logs de ejecución en bruto y figuras de calidad de publicación
│   ├── instance_small.txt                    # Resumen de ejecuciones metaheurísticas (Escala 3x5)
│   ├── instance_medium.txt                   # Resumen de ejecuciones metaheurísticas (Escala 10x25)
│   ├── instance_large.txt                    # Resumen de ejecuciones metaheurísticas (Escala 20x50)
│   ├── minizinc_small.txt                    # Log de verificación del solucionador HiGHS (Óptimo Global: 84.20)
│   ├── minizinc_medium.txt                   # Log de verificación del solucionador HiGHS (Óptimo Global: 452.00)
│   ├── minizinc_large.txt                    # Log de verificación del solucionador HiGHS (Óptimo Global: 915.20)
│   ├── convergence_analysis_instance_*.png   # Gráficos de curvas de convergencia estructurados para LaTeX
│   └── cost_metric_dispersion_instance_*.png # Diagramas de caja (boxplots) de dispersión no paramétrica
├── minizinc/                                 # Artefactos del modelamiento matemático formal
│   ├── tmlpa_model.mzn                       # Modelo definitivo de formulación de restricciones del sistema
│   ├── tmlpa_integer.mzn                     # Script de procesamiento numérico entero con límites forzados
│   ├── instance_small.dzn                    # Parámetros de escala de datos: 3 Microhubs x 5 Clientes
│   ├── instance_medium.dzn                   # Parámetros de escala de datos: 10 Microhubs x 25 Clientes
│   └── instance_large.dzn                    # Parámetros de escala de datos: 20 Microhubs x 50 Clientes
└── report-latex-source/                      # Manuscritos de publicación académica en formato LaTeX
    ├── main.tex                              # Código fuente del documento principal en LaTeX
    ├── refs.bib                              # Entradas bibliográficas estructuradas en BibTeX
    ├── elsarticle.cls                        # Plantilla de diagramación para revistas de Elsevier
    ├── elsarticle-num.bst                    # Estilo bibliográfico de citación numérica
    └── execution_results/                    # Enlaces de imágenes vectoriales integradas al reporte

```

---

## Dependencias y Configuración del Entorno

El entorno de pruebas requiere de un intérprete Python (versión 3.8 o superior) junto con una instalación nativa de MiniZinc vinculada y expuesta globalmente al motor de optimización HiGHS.

### 1. Dependencias de Python

Instale las librerías estándares para computación científica, manipulación de datos y visualización avanzada:

```bash
pip install numpy pandas scipy matplotlib jupyter

```

### 2. Motor Base de MiniZinc CLI

Asegúrese de que el ejecutable de `minizinc` se encuentre correctamente configurado en la variable de entorno PATH de su sistema operativo.

* **Ubuntu/Debian:** `sudo apt-get install minizinc`
* **macOS (Homebrew):** `brew install minizinc`
* **Windows:** Instale mediante el instalador oficial y añada la ruta binaria a las variables de entorno del sistema.

Verifique la correcta vinculación de la interfaz de línea de comandos mediante su terminal:

```bash
minizinc --version

```

---

## Guía de Ejecución y Replicación Empírica

### Ejecución de los Experimentos Metaheurísticos

Inicie el servidor de Jupyter Notebook y ejecute las celdas del código secuencialmente:

```bash
jupyter notebook TMLPA_Optimization.ipynb

```

El ciclo algorítmico principal encapsulado en la función `execute_benchmark_experiment("instance_name.dzn")` ejecutará de forma automatizada las siguientes subtareas:

1. Flujo de datos directo desde el archivo de asignación espacial `.dzn` correspondiente.
2. Lanzamiento de las exploraciones estocásticas independientes utilizando semillas aleatorias aisladas y desfasadas (semillas 43 a 72).
3. Aplicación de un filtro estadístico basado en el Rango Intercuartílico (IQR) al término de los bloques iterativos para identificar, descartar y reemplazar dinámicamente en caliente los valores atípicos (*outliers*) con el fin de preservar rígidamente un tamaño de muestra de $N=30$ observaciones válidas.


4. Cálculo de inferencias de significancia estadística mediante la prueba no paramétrica de Mann-Whitney-Wilcoxon.


5. Almacenamiento de matrices de gráficos con proporciones tipográficas aptas para revistas científicas en el directorio `execution_results/`.

### Verificación del Óptimo Global Exacto (Mundo Real)

Para compilar de forma independiente las fronteras óptimas del modelamiento matemático mediante las rutinas de ramificación y corte (*branch and cut*) integradas en el motor HiGHS, ejecute los siguientes comandos en su terminal:

```bash
# Instancia Pequeña
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_small.dzn -p 4

# Instancia Mediana
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_medium.dzn -p 4

# Instancia Grande
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_large.dzn -p 4

```

---

## Resumen de Rendimiento de los Núcleos Operacionales

Los resultados empíricos validados de las corridas multiescala se estructuran de la siguiente manera:

1. 
**`instance_small.dzn`**: Ambas metaheurísticas logran una estabilidad estructural absoluta, alcanzando con éxito el óptimo global matemático exacto de **`84,2000`** con una tasa de éxito perfecta (`SRate = 1,0000`).


2. 
**`instance_medium.dzn`**: El límite exacto fue fijado por HiGHS en **`452,0000`**. Ambas metaheurísticas fallaron en capturar este objetivo debido a un pozo óptimo local multimodal engañoso. El algoritmo BPSO exhibió un estancamiento prematuro absoluto perdiendo toda su diversidad ($\sigma = 0,0000$) estabilizado unánimemente en un costo de `461,0000` ($\text{Brecha} = +1,99\%$). Por el contrario, el optimizador de la morsa (BWO) sostuvo su varianza exploratoria logrando encontrar un mejor perfil de costo de **`464,8000`** ($\text{Brecha} = +2,83\%$).


3. 
**`instance_large.dzn`**: El óptimo global exacto se resolvió en **`915,2000`**. El algoritmo baseline BPSO demostró una excelente tasa de explotación en alta dimensión, aproximándose con un costo mínimo de **`920,3000`** ($\text{Brecha} = +0,56\%$). El optimizador BWO mantuvo una dispersión extendida debido a sus capas dinámicas de exploración, convergiendo en un mejor valor de **`933,1000`** ($\text{Brecha} = +1,96\%$).



Los estadísticos muestrales completos, los bloques matriciales en código LaTeX y los vectores resultantes de la disposición física de los hubs operativos ($y$) se encuentran detallados para su consulta en el archivo `results_summary.txt`.
