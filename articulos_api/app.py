from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from werkzeug.utils import secure_filename
import os
from datetime import datetime

# Configuración inicial
app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
ALLOWED_EXTENSIONS = {'pdf'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Crear carpeta 'uploads' si no existe
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/api2/upload', methods=['POST'])
def upload_file():
    print('📥 Petición recibida')
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No se encontró el archivo'}), 400

        file = request.files['file']
        uid = request.form.get('uid')
        email = request.form.get('email')

        if not file or file.filename == '':
            return jsonify({'error': 'Archivo vacío o no proporcionado'}), 400

        if not allowed_file(file.filename):
            return jsonify({'error': 'Solo se permiten archivos PDF'}), 400

        # Generar nombre de archivo único
        timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
        nombre_original = secure_filename(file.filename)
        nombre_guardado = nombre_original

        file_path = os.path.join(app.config['UPLOAD_FOLDER'], nombre_guardado)
        file.save(file_path)

        print(f"✅ Archivo guardado en: {file_path}")
        return jsonify({'archivo': nombre_guardado}), 200

    except Exception as e:
        print(f"❌ Error al subir archivo: {str(e)}")
        return jsonify({'error': str(e)}), 500

# Ruta para visualizar o descargar el PDF
@app.route('/uploads/<filename>', methods=['GET'])
def ver_pdf(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    # Servidor accesible desde otros dispositivos en la misma red
    app.run(host='0.0.0.0', port=5000, debug=True)
