import os
import time
from datetime import datetime
from flask import Flask, request, jsonify, send_from_directory, send_file, abort, render_template, url_for
from werkzeug.utils import secure_filename
from dotenv import load_dotenv
import pymysql


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = BASE_DIR  # servir os HTML já criados
UPLOAD_DIR = os.path.join(BASE_DIR, 'uploads')
os.makedirs(UPLOAD_DIR, exist_ok=True)

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'notas_db'),
    'port': int(os.getenv('DB_PORT', '3306')),
    'cursorclass': pymysql.cursors.DictCursor,
    'autocommit': True,
}


def get_conn():
    return pymysql.connect(**DB_CONFIG)


def init_db():
    sql = (
        """
        CREATE TABLE IF NOT EXISTS notas_fiscais (
            id INT PRIMARY KEY AUTO_INCREMENT,
            data_emissao DATE NOT NULL,
            numero_nf VARCHAR(44) NOT NULL,
            fornecedor VARCHAR(255) NOT NULL,
            pedidos VARCHAR(255) NOT NULL,
            data_recebimento DATE NOT NULL,
            caminho_pdf VARCHAR(255) NOT NULL,
            departamento_cod VARCHAR(10) NOT NULL,
            migo_realizada BOOLEAN DEFAULT FALSE,
            numero_migo VARCHAR(50) NULL,
            data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        """
    )
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql)


app = Flask(__name__, static_folder='static', template_folder='templates')


@app.route('/')
def index():
    departamentos = ['T001', 'T002', 'T003', 'T004', 'T005']
    return render_template('index.html', departamentos=departamentos)


@app.route('/departamento/<string:codigo>', endpoint='departamento')
def departamento_page(codigo: str):
    # Servimos a página estática; a listagem pode ser feita via JSON endpoint
    return send_file(os.path.join(STATIC_DIR, 'departamento.html'))


@app.route('/departamento/<string:codigo>/json')
def departamento_json(codigo: str):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT id, DATE_FORMAT(data_emissao, '%Y-%m-%d') AS data_emissao, numero_nf, fornecedor, pedidos, "
                "DATE_FORMAT(data_recebimento, '%Y-%m-%d') AS data_recebimento, caminho_pdf, departamento_cod, "
                "migo_realizada, numero_migo, UNIX_TIMESTAMP(data_criacao) AS data_criacao "
                "FROM notas_fiscais WHERE departamento_cod=%s ORDER BY data_criacao DESC",
                (codigo,)
            )
            rows = cur.fetchall()
    return jsonify(rows)


@app.route('/assets/<path:path>')
def serve_assets(path):
    return send_from_directory(os.path.join(STATIC_DIR, 'assets'), path)


@app.route('/api/notas', methods=['POST'])
def criar_nota():
    # Campos do form-data
    data_emissao = request.form.get('data_emissao')
    numero_nf = request.form.get('numero_nf')
    fornecedor = request.form.get('fornecedor')
    pedidos = request.form.get('pedidos')
    data_recebimento = request.form.get('data_recebimento')
    departamento_cod = request.form.get('departamento_cod')
    arquivo = request.files.get('arquivo_pdf')

    if not all([data_emissao, numero_nf, fornecedor, pedidos, data_recebimento, departamento_cod, arquivo]):
        return jsonify({'error': 'Campos obrigatórios faltando'}), 400

    # Validação simples do arquivo
    filename = secure_filename(arquivo.filename or '')
    if not filename.lower().endswith('.pdf'):
        return jsonify({'error': 'Arquivo deve ser PDF'}), 400

    # Inserir registro para obter ID
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO notas_fiscais (data_emissao, numero_nf, fornecedor, pedidos, data_recebimento, caminho_pdf, departamento_cod) "
                "VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (data_emissao, numero_nf, fornecedor, pedidos, data_recebimento, '', departamento_cod)
            )
            nota_id = cur.lastrowid

    # Salvar arquivo com nome único baseado no ID e timestamp
    ts = int(time.time())
    final_name = f"nf_{nota_id}_{ts}.pdf"
    save_path = os.path.join(UPLOAD_DIR, final_name)
    arquivo.save(save_path)

    # Atualizar caminho_pdf
    rel_path = os.path.join('uploads', final_name)
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE notas_fiscais SET caminho_pdf=%s WHERE id=%s", (rel_path, nota_id))
            cur.execute(
                "SELECT id, DATE_FORMAT(data_emissao, '%Y-%m-%d') AS data_emissao, numero_nf, fornecedor, pedidos, "
                "DATE_FORMAT(data_recebimento, '%Y-%m-%d') AS data_recebimento, caminho_pdf, departamento_cod, migo_realizada, numero_migo, "
                "UNIX_TIMESTAMP(data_criacao) AS data_criacao FROM notas_fiscais WHERE id=%s",
                (nota_id,)
            )
            row = cur.fetchone()

    return jsonify(row), 201


@app.route('/api/notas/<int:nota_id>/migo', methods=['PATCH'])
def atualizar_migo(nota_id: int):
    data = request.get_json(silent=True) or {}
    migo_realizada = bool(data.get('migo_realizada', False))
    numero_migo = data.get('numero_migo')

    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE notas_fiscais SET migo_realizada=%s, numero_migo=%s WHERE id=%s",
                (migo_realizada, numero_migo, nota_id)
            )
            if cur.rowcount == 0:
                return jsonify({'error': 'Nota não encontrada'}), 404
            cur.execute(
                "SELECT id, DATE_FORMAT(data_emissao, '%Y-%m-%d') AS data_emissao, numero_nf, fornecedor, pedidos, "
                "DATE_FORMAT(data_recebimento, '%Y-%m-%d') AS data_recebimento, caminho_pdf, departamento_cod, migo_realizada, numero_migo, "
                "UNIX_TIMESTAMP(data_criacao) AS data_criacao FROM notas_fiscais WHERE id=%s",
                (nota_id,)
            )
            row = cur.fetchone()

    return jsonify(row)


@app.route('/download/nf/<int:nota_id>')
def download_nf(nota_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT caminho_pdf FROM notas_fiscais WHERE id=%s", (nota_id,))
            row = cur.fetchone()
            if not row:
                abort(404)
            caminho = row['caminho_pdf']
    full_path = os.path.join(BASE_DIR, caminho)
    if not os.path.isfile(full_path):
        abort(404)
    return send_from_directory(os.path.dirname(full_path), os.path.basename(full_path), as_attachment=True)


if __name__ == '__main__':
    # Inicializa DB se necessário
    try:
        init_db()
    except Exception as e:
        print('Aviso: falha ao inicializar DB:', e)
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', '5000')), debug=True)
