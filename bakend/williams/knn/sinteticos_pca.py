import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.decomposition import PCA
from imblearn.over_sampling import SMOTE
import pickle

# === CARGA DE DATOS ===
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

# === BALANCEO Y ESCALADO ===
smote = SMOTE(sampling_strategy='minority', random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

scaler = StandardScaler()
X_resampled = scaler.fit_transform(X_resampled)

# === REDUCCIÓN PCA ===
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_resampled)
X_class1_pca = X_pca[y_resampled == 1]
X_class0_pca = X_pca[y_resampled == 0]
X_class1_full = X_resampled[y_resampled == 1]

# === GENERACIÓN DE SINTÉTICOS ===
synthetic_points = []
num_synthetic = 20
noise_level = 0.3
max_distance = 5.0
min_distance = 0.8
max_attempts = 500
attempts = 0

centroid_1 = X_class1_pca.mean(axis=0)

while len(synthetic_points) < num_synthetic and attempts < max_attempts:
    attempts += 1
    idx = np.random.choice(len(X_class1_full))
    base = X_class1_full[idx]
    synthetic = base + np.random.normal(0, noise_level, base.shape)
    synthetic_pca = pca.transform([synthetic])
    dist = np.linalg.norm(synthetic_pca[0] - centroid_1)

    if dist > min_distance and dist < max_distance:
        synthetic_points.append(synthetic)

    if attempts % 20 == 0:
        print(f"Intento {attempts} - Puntos válidos: {len(synthetic_points)}")

print(f"\n✅ Se generaron {len(synthetic_points)} puntos sintéticos tras {attempts} intentos.")

X_synthetic = np.array(synthetic_points)
y_synthetic = np.ones(len(X_synthetic))
X_synthetic_pca = pca.transform(X_synthetic)

# === VISUALIZACIÓN ===
plt.figure(figsize=(10, 6))
plt.scatter(X_class0_pca[:, 0], X_class0_pca[:, 1], c='green', label='Clase 0 (original)', alpha=0.5)
plt.scatter(X_class1_pca[:, 0], X_class1_pca[:, 1], c='red', label='Clase 1 (original)', alpha=0.6)
plt.scatter(X_synthetic_pca[:, 0], X_synthetic_pca[:, 1], c='blue', marker='x', s=100, label='Clase 1 (sintético)')

plt.title("Distribución PCA: Originales vs Sintéticos Dispersos")
plt.xlabel("Componente Principal 1")
plt.ylabel("Componente Principal 2")
plt.legend()
plt.grid(True)
plt.tight_layout()

# Guardar en archivo (opcional)
plt.savefig("sinteticos_dispersos.png", dpi=300)
plt.show()

# === GUARDAR DATOS PARA FUSIÓN ===
np.save("X_synthetic.npy", X_synthetic)
np.save("y_synthetic.npy", y_synthetic)
