import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, confusion_matrix
from imblearn.over_sampling import SMOTE
import pickle
from sklearn.decomposition import PCA


# Cargar datos
data_path = "../prueba.xlsx"
dataset = pd.read_excel(data_path)

# Conversión de columnas categóricas a string
dataset['TALLA/EDAD (ACTUAL)'] = dataset['TALLA/EDAD (ACTUAL)'].astype(str)
dataset['Peso al nacer/edad gestacional'] = dataset['Peso al nacer/edad gestacional'].astype(str)

# Columnas categóricas y binarias
categorical_cols = ['TALLA/EDAD (ACTUAL)', 'Peso al nacer/edad gestacional']
binary_cols = dataset.columns.drop(['CASOS', 'TALLA/EDAD (ACTUAL)', 'Peso al nacer/edad gestacional', 'Sospecha_WS'])

# Codificación One-Hot
onehotencoder = OneHotEncoder()
categorical_data = onehotencoder.fit_transform(dataset[categorical_cols]).toarray()

with open('onehotencoder.pkl', 'wb') as f:
    pickle.dump(onehotencoder, f)

X = np.concatenate((categorical_data, dataset[binary_cols].values), axis=1)
y = dataset['Sospecha_WS'].values

# SMOTE para balanceo
smote = SMOTE(sampling_strategy='minority', random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

# Escalado
scaler = StandardScaler()
X_resampled = scaler.fit_transform(X_resampled)

# División en entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(X_resampled, y_resampled, test_size=0.2, stratify=y_resampled, random_state=42)

# Entrenamiento con KNN
knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)

# Evaluación
y_pred = knn.predict(X_test)
print("Matriz de Confusión:")
print(confusion_matrix(y_test, y_pred))
print("\nReporte de Clasificación:")
print(classification_report(y_test, y_pred))

# Guardar modelo
with open("knn_model.pkl", "wb") as f:
    pickle.dump(knn, f)

# Estadísticas del conjunto
print(f"Número total de datos (original): {X.shape[0]}")
print(f"Número total de datos (después de SMOTE): {X_resampled.shape[0]}")
print(f"Número de datos en entrenamiento: {X_train.shape[0]}")
print(f"Número de datos en prueba: {X_test.shape[0]}")

number_of_features = X.shape[1]
number_of_features2 = X_train.shape[1]
print(f"El número total de características después del preprocesamiento es: {number_of_features} , {number_of_features2}")

categorical_feature_names = onehotencoder.get_feature_names_out(categorical_cols)
total_feature_names = np.concatenate((categorical_feature_names, binary_cols))
print("Nombres de todas las características después del preprocesamiento y codificación:")
print(total_feature_names)

print(pd.Series(y).value_counts())
print("precision")

# Lista de características usadas para predicción
feature_names = total_feature_names.tolist()

# Datos de ejemplo para predicción
data = {
  "TALLA/EDAD (ACTUAL)_0": 0, "TALLA/EDAD (ACTUAL)_Alto": 0, "TALLA/EDAD (ACTUAL)_Bajo": 1, "TALLA/EDAD (ACTUAL)_Normal": 0,
  "Peso al nacer/edad gestacional_0": 0, "Peso al nacer/edad gestacional_Adecuado": 0, "Peso al nacer/edad gestacional_Alto": 1, "Peso al nacer/edad gestacional_Bajo": 0,
  "SEXO": 1, "PESO": 70, "EDAD": 25, "BAJO PESO AL NACER": 1, "TALLA/EDAD (ACTUAL).1": 1, "PESO/EDAD (ACTUAL)": 0,
  "RDPM / DISCAPACIDAD INTELECTUAL": 0, "CARACTERISTICAS FACIALES": 1, "DEPRESION BITEMPORAL": 0, "CEJAS ARQUEADAS": 1,
  "PLIEGUE EPICANTICO": 0, "PATRON ESTELAR DEL IRIS": 1, "PUENTE NASAL DEPRIMIDO": 0, "NARIZ CORTA NARINAS ANTEVERTIDAS": 1,
  "PUNTA NASAL ANCHA O BULBOSA": 1, "MEJILLAS PROMINENTES": 0, "REGION MALAR PLANA": 1, "FILTRUM LARGO": 0,
  "LABIOS GRUESOS": 1, "DIENTES PEQUEÑOS O ESPACIADOS": 0, "PALADAR ALTO Y OJIVAL": 1, "BOCA AMPLIA": 1,
  "PABELLONES AURICULARES GRANDES": 1, "CARDIOPATIA CONGENITA": 1, "ESTENOSIS SUPRAVALVULAR AORTICA": 1,
  "ESTENOSIS PULMONAR": 1, "OTRA CARDIOPATIA": 1, "OTRAS ALTERACIONES": 0, "VOZ DISFONICA": 1,
  "TRASTORNO TIROIDEO": 1, "TRASTORNO DE LA REFRACCION": 1, "HERNIA": 1, "ORQUIDOPEXIA": 1,
  "SINOSTOSIS RADIOCUBITAL": 0, "HIPERLAXITUD ARTICULAR": 1, "ANTECEDENTE DE ORQUIDOPEXIA": 0, "ESCOLIOSIS": 1,
  "HIPERCALCEMIA": 1, "RETRASO EN EL DESARROLLO PSICOMOTOR": 1, "DÉFICIT COGNITIVO": 0, "PERSONALIDAD SOCIAL EXTREMA": 1,
  "TRASTORNOS DEL APRENDIZAJE": 0, "ANSIEDAD O FOBIAS (Sonidos fuertes, lugares cerrados, separación, etc.)": 1,
  "PROBLEMAS DEL SUEÑO (Insomnio, despertares nocturnos)": 0, "GENÉTICA CONFIRMADA (Deleción 7q11.23 / Sin análisis)": 1,
  "ESTUDIO MOLECULAR CONFIRMATORIO": 1, "HIPOACUSIA": 1, "HIPERSENSIBILIDAD AUDITIVA (HIPERACUSIA)": 0,
  "ALTERACIONES VISUALES (Miopía, astigmatismo, estrabismo)": 1,
  "ALTERACIONES HORMONALES (Pubertad tardía, alteraciones tiroideas adicionales)": 1,
  "DIABETES INFANTIL O INTOLERANCIA A LA GLUCOSA": 1, "DÉFICIT DE CRECIMIENTO": 0
}

# Convertir a DataFrame y escalar
input_data = pd.DataFrame([data], columns=feature_names)
input_array = scaler.transform(input_data.values.astype(float))

# Predicción
prediction = knn.predict(input_array)
print("Predicción con KNN:", prediction)
# Obtener la probabilidad asociada a la predicción
probabilidad = knn.predict_proba(input_array)
print(f"Probabilidad de clase 0 (sin sospecha): {probabilidad[0][0]:.4f}")
print(f"Probabilidad de clase 1 (con sospecha): {probabilidad[0][1]:.4f}")

# PCA para reducir a 2D
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_resampled)
nuevo_cliente_pca = pca.transform(input_array)

# Separar por clase para colorear
X_class0 = X_pca[y_resampled == 0]
X_class1 = X_pca[y_resampled == 1]

plt.figure(figsize=(8, 6))

# Datos históricos
plt.scatter(X_class0[:, 0], X_class0[:, 1], c='green', label='Sin sospecha (clase 0)', alpha=0.5)
plt.scatter(X_class1[:, 0], X_class1[:, 1], c='red', label='Con sospecha (clase 1)', alpha=0.5)

# Nuevo paciente
plt.scatter(nuevo_cliente_pca[0, 0], nuevo_cliente_pca[0, 1], c='blue', s=120, marker='X', label='Nuevo paciente')

plt.title("Visualización en 2D con PCA")
plt.xlabel("Componente Principal 1")
plt.ylabel("Componente Principal 2")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()