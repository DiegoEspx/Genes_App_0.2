import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.decomposition import PCA
from imblearn.over_sampling import SMOTE

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

# SMOTE + ESCALADO
smote = SMOTE(sampling_strategy='minority', random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

scaler = StandardScaler()
X_resampled_scaled = scaler.fit_transform(X_resampled)

# PCA a 2 componentes
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_resampled_scaled)
X_class0_pca = X_pca[y_resampled == 0]
X_class1_pca = X_pca[y_resampled == 1]

# === GENERACIÓN DE NUEVAS COORDENADAS PCA ===
num_points = 20

# Región entre clase 0 y clase 1, ajusta si deseas
x_min, x_max = 0.5, 3.0
y_min, y_max = -2.5, 2.5

synthetic_pca_coords = np.random.uniform(
    low=[x_min, y_min], high=[x_max, y_max], size=(num_points, 2)
)

# Invertimos a espacio original escalado
synthetic_scaled = pca.inverse_transform(synthetic_pca_coords)

# Guardamos como positivos
y_synthetic = np.ones(len(synthetic_scaled))

# === VISUALIZACIÓN ===
plt.figure(figsize=(10, 6))
plt.scatter(X_class0_pca[:, 0], X_class0_pca[:, 1], c='green', label='Clase 0 (original)', alpha=0.5)
plt.scatter(X_class1_pca[:, 0], X_class1_pca[:, 1], c='red', label='Clase 1 (original)', alpha=0.6)
plt.scatter(synthetic_pca_coords[:, 0], synthetic_pca_coords[:, 1], c='blue', marker='x', s=100, label='Clase 1 (sintético PCA)')

plt.title("Distribución PCA: Síntesis Inversa desde Espacio PCA")
plt.xlabel("Componente Principal 1")
plt.ylabel("Componente Principal 2")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("sinteticos_por_pca_inverse.png", dpi=300)
plt.show()

np.save("X_synthetic_pca_inverse.npy", synthetic_scaled)
np.save("y_synthetic_pca_inverse.npy", y_synthetic)