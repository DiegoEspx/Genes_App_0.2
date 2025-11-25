# GenesApp - Diagnóstico Asistido de Síndromes Genéticos

**Aplicación móvil multiplataforma para el diagnóstico asistido por IA de síndromes genéticos**

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python)](https://python.org)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-FF6F00?logo=tensorflow)](https://tensorflow.org)

---

## Tabla de Contenidos

- [Descripción](#descripción)
- [Características Principales](#características-principales)
- [Arquitectura](#arquitectura)
- [Tecnologías](#tecnologías)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [API Backend](#api-backend)
- [Modelo de Machine Learning](#modelo-de-machine-learning)
- [Autores](#autores)

---

## Descripción

GenesApp es una aplicación móvil desarrollada con Flutter que integra inteligencia artificial para asistir en el diagnóstico de síndromes genéticos. La aplicación está diseñada para profesionales de la salud y pacientes, proporcionando herramientas de evaluación basadas en características clínicas y fenotípicas.

### Síndromes Soportados

- Síndrome de Williams
- Síndrome de Down
- Mucopolisacaridosis

---

## Características Principales

### Autenticación y Gestión de Usuarios

- Inicio de sesión con email/contraseña y Google Sign-In
- Gestión de roles (Paciente, Médico, Administrador)
- Verificación de correo institucional para médicos
- Estado online/offline en tiempo real

### Predicción con IA

- Formulario interactivo de evaluación clínica con 60 características
- Modelo de Deep Learning (TensorFlow/Keras)
- Predicción de probabilidad de Síndrome de Williams
- Resultados con interpretación clínica

### Recursos Educativos

- Guías clínicas detalladas por síndrome
- Galería de imágenes de referencia
- Información sobre características fenotípicas

### Agente Doctor (Chat IA)

- Asistente virtual para consultas médicas
- Arquitectura BLoC para gestión de estado
- Persistencia de conversaciones con Hydrated BLoC

### Gestión de Documentos

- Visualizador de PDFs integrado (Syncfusion)
- Almacenamiento en Firebase Storage

---

## Arquitectura

### Frontend (Flutter)

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (UI, Widgets, Screens, BLoC)           │
├─────────────────────────────────────────┤
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
├─────────────────────────────────────────┤
│          Data Layer                     │
│  (Models, Data Sources, API Clients)    │
└─────────────────────────────────────────┘
```

### Backend (Python/Flask)

```
┌─────────────────────────────────────────┐
│          API REST (Flask)               │
├─────────────────────────────────────────┤
│     Modelo ML (TensorFlow/Keras)        │
├─────────────────────────────────────────┤
│    Preprocesamiento de Datos            │
└─────────────────────────────────────────┘
```

### Servicios Cloud

```
┌─────────────────────────────────────────┐
│        Firebase Authentication          │
├─────────────────────────────────────────┤
│        Cloud Firestore (Database)       │
├─────────────────────────────────────────┤
│        Firebase Storage (Files)         │
└─────────────────────────────────────────┘
```

---

## Tecnologías

### Frontend

- **Framework**: Flutter 3.7.2
- **Lenguaje**: Dart
- **Gestión de Estado**: `flutter_bloc` ^9.1.1, `hydrated_bloc` ^10.1.1
- **Autenticación**: `firebase_auth` ^5.5.1, `google_sign_in` ^6.3.0
- **Base de Datos**: `cloud_firestore` ^5.6.5
- **Almacenamiento**: `firebase_storage` ^12.4.4
- **HTTP Client**: `http` ^1.3.0, `dio` ^5.9.0
- **UI/UX**: `animate_do` ^4.2.0, `lottie` ^2.2.0, `syncfusion_flutter_pdfviewer` ^29.1.33

### Backend

- **Framework**: Flask
- **ML Framework**: TensorFlow/Keras
- **Procesamiento de Datos**: NumPy, Pandas, scikit-learn
- **Balanceo de Datos**: imbalanced-learn (SMOTE)

#### Servicios Backend (APIs)

| Puerto   | Servicio            | Archivo                                | Descripción                                       |
| -------- | ------------------- | -------------------------------------- | ------------------------------------------------- |
| **5000** | Predicción Williams | `bakend/williams/api-fl.py`            | API de ML para predicción de Síndrome de Williams |
| **5001** | Verificación Médica | `verificacion_api/verificacion_api.py` | Gestión de verificación de credenciales médicas   |
| **5002** | Artículos           | `articulos_api/app.py`                 | Subida y gestión de artículos médicos (PDFs)      |
| **5003** | Storage General     | `storge/app.py`                        | Almacenamiento general de archivos                |

> Ver [BACKEND_PORTS.md](BACKEND_PORTS.md) para documentación detallada de cada servicio.

### Infraestructura

- **Hosting Backend**: Railway (https://gropgenesapp-production.up.railway.app/)
- **Base de Datos**: Cloud Firestore
- **Autenticación**: Firebase Authentication
- **Storage**: Firebase Storage

---

## Requisitos Previos

### Para el Frontend (Flutter)

- Flutter SDK >= 3.7.2
- Dart SDK >= 3.7.2
- Android Studio o Xcode (para desarrollo móvil)
- Git

### Para el Backend (Python)

- Python >= 3.8
- pip (Gestor de paquetes de Python)
- Virtualenv (recomendado)

---

## Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/DiegoEspx/Genes_App_0.2.git
cd Genes_App_0.2
```

### 2. Configurar Flutter

```bash
# Instalar dependencias
flutter pub get

# Verificar instalación
flutter doctor

# Generar iconos de la app
flutter pub run flutter_launcher_icons
```

### 3. Configurar Backend

```bash
cd bakend/williams

# Crear entorno virtual (recomendado)
python -m venv venv

# Activar entorno virtual
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# Instalar dependencias
pip install flask tensorflow pandas numpy scikit-learn imbalanced-learn joblib
```

---

## Configuración

### Firebase Setup

1. **Crear proyecto en Firebase Console**

   - Ir a [Firebase Console](https://console.firebase.google.com/)
   - Crear nuevo proyecto

2. **Configurar Authentication**

   - Habilitar Email/Password
   - Habilitar Google Sign-In
   - Configurar dominios autorizados

3. **Configurar Firestore**

   - Crear base de datos en modo producción
   - Configurar reglas de seguridad

4. **Configurar Storage**

   - Habilitar Firebase Storage
   - Configurar reglas de acceso

5. **Descargar archivos de configuración**
   - Para Android: `google-services.json` → `android/app/`
   - Para iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Actualizar `lib/firebase_options.dart`

### Variables de Entorno

#### Frontend (Flutter)

Editar `lib/agente_doctor/core/config.dart`:

```dart
const apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://localhost:5000/', // URL de tu backend
);
```

#### Backend (Python)

Crear archivo `.env` en `bakend/williams/`:

```env
FLASK_ENV=development
FLASK_DEBUG=True
PORT=5000
```

### Ejecutar la Aplicación

#### Flutter

```bash
# Modo desarrollo (Android)
flutter run

# Modo desarrollo (iOS)
flutter run -d ios

# Modo desarrollo (Web)
flutter run -d chrome

# Generar APK (Android)
flutter build apk --release

# Generar IPA (iOS)
flutter build ios --release
```

#### Backend

```bash
cd bakend/williams

# Activar entorno virtual
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# Ejecutar servidor Flask
python api-fl.py
```

El servidor estará disponible en: `http://localhost:5000`

---

## Estructura del Proyecto

```
Genes_App_0.2/
├── lib/                        # Código fuente Flutter
│   ├── main.dart              # Punto de entrada
│   ├── firebase_options.dart  # Configuración Firebase
│   ├── login.dart             # Pantalla de login
│   ├── register.dart          # Pantalla de registro
│   ├── adminScreen/           # Pantallas de administrador
│   ├── medicScreen/           # Pantallas de médico
│   ├── pacientScreen/         # Pantallas de paciente
│   ├── usersScreen/           # Pantallas de usuario
│   │   ├── perfil.dart        # Perfil de usuario
│   │   ├── williamspredict.dart  # Formulario de predicción
│   │   ├── screens_guias/     # Guías de síndromes
│   │   │   ├── guias_screen.dart
│   │   │   ├── sindrome_williams/
│   │   │   ├── sindrome_down/
│   │   │   └── mucopolisacaridosis/
│   │   └── williams_predict/  # Módulo de predicción
│   ├── agente_doctor/         # Chat IA (Arquitectura Limpia)
│   │   ├── core/              # Configuración y constantes
│   │   ├── data/              # Fuentes de datos
│   │   ├── domain/            # Lógica de negocio
│   │   └── presentation/      # UI y BLoC
│   │       ├── bloc/          # Gestión de estado
│   │       ├── pages/         # Pantallas
│   │       └── widgets/       # Componentes UI
│   └── widgets/               # Widgets compartidos
│       ├── app_colors.dart    # Paleta de colores
│       ├── custom_app_bar.dart
│       └── roleBasedDrawer.dart
├── bakend/                    # Backend Python
│   └── williams/              # API de predicción Williams
│       ├── api-fl.py          # Servidor Flask
│       ├── modelvr.py         # Entrenamiento del modelo
│       ├── mod855.keras       # Modelo entrenado
│       ├── prueba.xlsx        # Dataset de entrenamiento
│       └── knn/               # Modelo KNN alternativo
├── assets/                    # Recursos estáticos
│   ├── images/                # Imágenes
│   │   ├── williams/          # Imágenes Síndrome Williams
│   │   ├── down/              # Imágenes Síndrome Down
│   │   └── muco/              # Imágenes Mucopolisacaridosis
│   └── animations/            # Animaciones Lottie
├── android/                   # Configuración Android
├── ios/                       # Configuración iOS
├── web/                       # Configuración Web
├── pubspec.yaml               # Dependencias Flutter
└── firebase.json              # Configuración Firebase
```

---

## API Backend

### POST /predict

Realiza una predicción de Síndrome de Williams basada en características clínicas.

**URL**: `http://localhost:5000/predict`

**Método**: `POST`

**Headers**:

```
Content-Type: application/json
```

**Body** (JSON con 60 características):

```json
{
  "TALLA/EDAD (ACTUAL)_0": 0,
  "TALLA/EDAD (ACTUAL)_Alto": 0,
  "TALLA/EDAD (ACTUAL)_Bajo": 1,
  "TALLA/EDAD (ACTUAL)_Normal": 0,
  "Peso al nacer/edad gestacional_0": 0,
  "Peso al nacer/edad gestacional_Adecuado": 1,
  "Peso al nacer/edad gestacional_Alto": 0,
  "Peso al nacer/edad gestacional_Bajo": 0,
  "SEXO": 1,
  "PESO": 70,
  "EDAD": 25,
  "BAJO PESO AL NACER": 0,
  "RDPM / DISCAPACIDAD INTELECTUAL": 1,
  "CARACTERISTICAS FACIALES": 1,
  ...
}
```

**Respuesta Exitosa** (200 OK):

```json
{
  "probabilidad": 0.8523,
  "diagnostico": "Positivo para Síndrome de Williams"
}
```

**Respuesta de Error** (400/500):

```json
{
  "error": "Descripción del error"
}
```

### Características del Modelo

El modelo espera **60 características** divididas en:

1. **Características Categóricas** (One-Hot Encoded):

   - `TALLA/EDAD (ACTUAL)`: 0, Alto, Bajo, Normal
   - `Peso al nacer/edad gestacional`: 0, Adecuado, Alto, Bajo

2. **Características Binarias** (0 o 1):
   - Datos demográficos (SEXO, PESO, EDAD)
   - Características físicas (faciales, corporales)
   - Características cardiovasculares
   - Características neurológicas
   - Características conductuales
   - Confirmación genética

---

## Modelo de Machine Learning

### Arquitectura del Modelo

**Tipo**: Red Neuronal Densa (Sequential)

**Capas**:

```python
Sequential([
    Dense(32, activation='relu', kernel_regularizer=l2(0.01), input_shape=(60,)),
    Dropout(0.5),
    Dense(16, activation='relu', kernel_regularizer=l2(0.01)),
    Dropout(0.5),
    Dense(1, activation='sigmoid')
])
```

### Características del Entrenamiento

- **Optimizador**: Adam
- **Función de Pérdida**: Binary Crossentropy
- **Métrica**: Accuracy
- **Regularización**: L2 (0.01)
- **Dropout**: 0.5
- **Validación Cruzada**: K-Fold (5 splits)
- **Early Stopping**: Patience=2
- **Balanceo de Datos**: SMOTE (Synthetic Minority Over-sampling)

### Preprocesamiento

1. **One-Hot Encoding** para variables categóricas
2. **SMOTE** para balancear clases
3. **Train/Test Split**: 80/20
4. **Normalización** de características numéricas

### Métricas de Rendimiento

- **Accuracy**: ~85% (mod855.keras)
- **Umbral de Clasificación**: 0.5
- **Dataset**: Datos clínicos de pacientes con/sin Síndrome de Williams

---

## Autores

- **Diego España** - [@DiegoEspx](https://github.com/DiegoEspx)
- **Sebastian Fajardo**

---
