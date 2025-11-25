
from flask import Flask, request, jsonify, send_file
from werkzeug.utils import secure_filename
from datetime import datetime
import os
import json

app = Flask(__name__)

# 📁 Carpeta raíz donde se guardan todas las verificaciones
VERIFICACION_UPLOAD_FOLDER = os.path.join(os.getcwd(), 'verificacion_archivos')
os.makedirs(VERIFICACION_UPLOAD_FOLDER, exist_ok=True)

# 📤 Ruta para enviar verificación (solo PDF e imágenes)
@app.route('/verificacion/enviar', methods=['POST'])
def enviar_verificacion():
    nombre = request.form.get('nombre')
    cedula = request.form.get('cedula')
    direccion = request.form.get('direccion')
    institucion = request.form.get('institucion')
    rethus = request.form.get('rethus')
    email = request.form.get('email')
    id_per = request.form.get('id_per')  # UID del usuario autenticado

    if not cedula:
        return jsonify({'error': 'La cédula es obligatoria'}), 400

    carpeta_usuario = os.path.join(VERIFICACION_UPLOAD_FOLDER, cedula)
    os.makedirs(carpeta_usuario, exist_ok=True)

    archivos = request.files.getlist('documentos')
    rutas_documentos = []

    extensiones_permitidas = ('.pdf', '.jpg', '.jpeg', '.png')

    for archivo in archivos:
        if archivo.filename == '':
            continue

        filename = secure_filename(archivo.filename)
        extension = os.path.splitext(filename)[1].lower()

        if extension not in extensiones_permitidas:
            print(f"⚠️ Archivo ignorado por tipo no permitido: {filename}")
            continue  # Saltamos archivos no válidos

        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        final_name = f"{timestamp}_{filename}"
        path = os.path.join(carpeta_usuario, final_name)
        archivo.save(path)

        rutas_documentos.append(f"/verificacion/archivo/{cedula}/{final_name}")

    if not rutas_documentos:
        return jsonify({'error': 'No se subió ningún documento válido'}), 400

    datos = {
        'nombre': nombre,
        'cedula': cedula,
        'direccion': direccion,
        'institucion': institucion,
        'rethus': rethus,
        'email': email,
        'id_per': id_per,
        'documentos': rutas_documentos,
        'fecha_envio': datetime.now().isoformat()
    }

    json_path = os.path.join(carpeta_usuario, 'datos.json')
    with open(json_path, 'w') as f:
        json.dump(datos, f, indent=2)

    return jsonify({'mensaje': 'Verificación guardada correctamente', 'cedula': cedula}), 200

# 📋 Listar todas las cédulas que tienen verificación enviada
@app.route('/verificacion/solicitudes', methods=['GET'])
def listar_todas_las_cedulas():
    cedulas = []
    for folder in os.listdir(VERIFICACION_UPLOAD_FOLDER):
        folder_path = os.path.join(VERIFICACION_UPLOAD_FOLDER, folder)
        if os.path.isdir(folder_path) and os.path.exists(os.path.join(folder_path, 'datos.json')):
            cedulas.append(folder)
    return jsonify(cedulas), 200

# 🔍 Obtener los datos por cédula
@app.route('/verificacion/datos/<cedula>', methods=['GET'])
def obtener_datos_por_cedula(cedula):
    json_path = os.path.join(VERIFICACION_UPLOAD_FOLDER, cedula, 'datos.json')
    if not os.path.exists(json_path):
        return jsonify({'error': 'Datos no encontrados para esa cédula'}), 404

    with open(json_path, 'r') as f:
        data = json.load(f)
    return jsonify(data), 200

# 📄 Obtener un archivo específico por cédula
@app.route('/verificacion/archivo/<cedula>/<filename>', methods=['GET'])
def obtener_archivo_de_usuario(cedula, filename):
    carpeta_usuario = os.path.join(VERIFICACION_UPLOAD_FOLDER, cedula)
    archivo_path = os.path.join(carpeta_usuario, filename)

    if not os.path.exists(archivo_path):
        return jsonify({'error': 'Archivo no encontrado'}), 404

    return send_file(archivo_path, as_attachment=False)

@app.route('/')
def home():
    return 'API de Verificación Médica funcionando correctamente (solo PDF e imágenes)'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
