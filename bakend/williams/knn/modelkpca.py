import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.decomposition import PCA
from imblearn.over_sampling import SMOTE
import pickle
import json

# === ENTRENAMIENTO ===
data_path = "../prueba.xlsx"
dataset = pd.read_excel(data_path)

dataset['TALLA/EDAD (ACTUAL)'] = dataset['TALLA/EDAD (ACTUAL)'].astype(str)
dataset['Peso al nacer/edad gestacional'] = dataset['Peso al nacer/edad gestacional'].astype(str)

categorical_cols = ['TALLA/EDAD (ACTUAL)', 'Peso al nacer/edad gestacional']
binary_cols = dataset.columns.drop(['CASOS', 'TALLA/EDAD (ACTUAL)', 'Peso al nacer/edad gestacional', 'Sospecha_WS'])

onehotencoder = OneHotEncoder()
categorical_data = onehotencoder.fit_transform(dataset[categorical_cols]).toarray()
X = np.concatenate((categorical_data, dataset[binary_cols].values), axis=1)
y = dataset['Sospecha_WS'].values

smote = SMOTE(sampling_strategy='minority', random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

scaler = StandardScaler()
X_resampled_scaled = scaler.fit_transform(X_resampled)

X_synthetic = np.load("X_synthetic_pca_inverse.npy")
y_synthetic = np.load("y_synthetic_pca_inverse.npy")

X_total = np.vstack([X_resampled_scaled, X_synthetic])
y_total = np.concatenate([y_resampled, y_synthetic])

X_train, X_test, y_train, y_test = train_test_split(X_total, y_total, test_size=0.2, stratify=y_total, random_state=42)

knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)

y_pred = knn.predict(X_test)
print("Matriz de Confusión:")
print(confusion_matrix(y_test, y_pred))
print("\nReporte de Clasificación:")
print(classification_report(y_test, y_pred))

with open("knn_con_sinteticos.pkl", "wb") as f:
    pickle.dump(knn, f)

print("✅ Modelo entrenado y guardado")

# === TEST DESDE test.json ===
# === TEST DESDE test.json ===
with open("test.json", "r", encoding="utf-8") as f:
    test_data = json.load(f)

feature_names = onehotencoder.get_feature_names_out(categorical_cols).tolist() + list(binary_cols)

# Convertir y rellenar columnas faltantes con 0
input_df = pd.DataFrame([test_data])
input_df = input_df.reindex(columns=feature_names, fill_value=0)

# Mostrar columnas faltantes si las hay
missing = [col for col in feature_names if col not in test_data]
if missing:
    print("\n⚠️ Columnas faltantes en test.json (rellenadas automáticamente con 0):")
    print(missing)
else:
    print("\n✅ Todas las columnas necesarias están presentes en test.json.")

# Escalado y predicción
input_scaled = scaler.transform(input_df.values.astype(float))

prediction = knn.predict(input_scaled)
proba = knn.predict_proba(input_scaled)

print("\n🎯 Predicción para test.json:")
print(f"Resultado: {prediction[0]}")
print(f"Probabilidad clase 0: {proba[0][0]:.4f}")
print(f"Probabilidad clase 1: {proba[0][1]:.4f}")

# === VISUALIZACIÓN PCA ===
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_total)
input_pca = pca.transform(input_scaled)

X_class0 = X_pca[y_total == 0]
X_class1 = X_pca[y_total == 1]

plt.figure(figsize=(8, 6))
plt.scatter(X_class0[:, 0], X_class0[:, 1], c='green', label='Clase 0 (sin sospecha)', alpha=0.5)
plt.scatter(X_class1[:, 0], X_class1[:, 1], c='red', label='Clase 1 (con sospecha)', alpha=0.5)
plt.scatter(input_pca[0, 0], input_pca[0, 1], c='blue', s=120, marker='X', label='Nuevo paciente (test.json)')

plt.title("Visualización PCA con paciente de test.json")
plt.xlabel("Componente 1")
plt.ylabel("Componente 2")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
