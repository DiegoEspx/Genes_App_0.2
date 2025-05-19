from locust import HttpUser, task, between
import random

# Simulación de datos de entrada válidos (debes ajustarlos si hay valores obligatorios específicos)
def generar_datos():
    return {
        'TALLA/EDAD (ACTUAL)_0': 0,
        'TALLA/EDAD (ACTUAL)_Alto': 0,
        'TALLA/EDAD (ACTUAL)_Bajo': 0,
        'TALLA/EDAD (ACTUAL)_Normal': 1,
        'Peso al nacer/edad gestacional_0': 0,
        'Peso al nacer/edad gestacional_Adecuado': 1,
        'Peso al nacer/edad gestacional_Alto': 0,
        'Peso al nacer/edad gestacional_Bajo': 0,
        'SEXO': 1,
        'PESO': 10,
        'EDAD': 5,
        'BAJO PESO AL NACER': 0,
        'TALLA/EDAD (ACTUAL).1': 1,
        'PESO/EDAD (ACTUAL)': 1,
        'RDPM / DISCAPACIDAD INTELECTUAL': 0,
        'CARACTERISTICAS FACIALES': 1,
        'DEPRESION BITEMPORAL': 0,
        'CEJAS ARQUEADAS': 1,
        'PLIEGUE EPICANTICO': 0,
        'PATRON ESTELAR DEL IRIS': 0,
        'PUENTE NASAL DEPRIMIDO': 1,
        'NARIZ CORTA NARINAS ANTEVERTIDAS': 1,
        'PUNTA NASAL ANCHA O BULBOSA': 1,
        'MEJILLAS PROMINENTES': 1,
        'REGION MALAR PLANA': 0,
        'FILTRUM LARGO': 0,
        'LABIOS GRUESOS': 1,
        'DIENTES PEQUEÑOS O ESPACIADOS': 1,
        'PALADAR ALTO Y OJIVAL': 0,
        'BOCA AMPLIA': 0,
        'PABELLONES AURICULARES GRANDES': 0,
        'CARDIOPATIA CONGENITA': 1,
        'ESTENOSIS SUPRAVALVULAR AORTICA': 0,
        'ESTENOSIS PULMONAR': 0,
        'OTRA CARDIOPATIA': 0,
        'OTRAS ALTERACIONES': 0,
        'VOZ DISFONICA': 0,
        'TRASTORNO TIROIDEO': 0,
        'TRASTORNO DE LA REFRACCION': 1,
        'HERNIA': 0,
        'ORQUIDOPEXIA': 0,
        'SINOSTOSIS RADIOCUBITAL': 0,
        'HIPERLAXITUD ARTICULAR': 0,
        'ANTECEDENTE DE ORQUIDOPEXIA': 0,
        'ESCOLIOSIS': 0,
        'HIPERCALCEMIA': 0,
        'RETRASO EN EL DESARROLLO PSICOMOTOR': 1,
        'DÉFICIT COGNITIVO': 1,
        'PERSONALIDAD SOCIAL EXTREMA': 1,
        'TRASTORNOS DEL APRENDIZAJE': 1,
        'ANSIEDAD O FOBIAS (Sonidos fuertes, lugares cerrados, separación, etc.)': 1,
        'PROBLEMAS DEL SUEÑO (Insomnio, despertares nocturnos)': 1,
        'GENÉTICA CONFIRMADA (Deleción 7q11.23 / Sin análisis)': 0,
        'ESTUDIO MOLECULAR CONFIRMATORIO': 0,
        'HIPOACUSIA': 0,
        'HIPERSENSIBILIDAD AUDITIVA (HIPERACUSIA)': 1,
        'ALTERACIONES VISUALES (Miopía, astigmatismo, estrabismo)': 1,
        'ALTERACIONES HORMONALES (Pubertad tardía, alteraciones tiroideas adicionales)': 0,
        'DIABETES INFANTIL O INTOLERANCIA A LA GLUCOSA': 0,
        'DÉFICIT DE CRECIMIENTO': 1
    }

class PredictUser(HttpUser):
    wait_time = between(1, 3)  # espera entre peticiones

    @task
    def predict_sindrome(self):
        payload = generar_datos()
        self.client.post("/predict", json=payload)
