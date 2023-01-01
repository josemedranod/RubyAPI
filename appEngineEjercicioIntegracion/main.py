from flask import Flask, jsonify, request
from db import get_hero, get_heroes, add_hero, put_hero, delete_hero

app = Flask(__name__)

# Método para conocer todos los superheroes
@app.route('/',methods=['GET'])
def superheroes():
    return get_heroes()

# Método para buscar a un solo superheroe
@app.route('/buscar',methods=['GET'])
def buscar():
    if not request.args.get('superhero_name'):
        return jsonify({"mensaje":"No hay request JSON"}),400
    data = (request.args.get('superhero_name'),)
    return get_hero(data)

# Método para agregar un superheroe
@app.route('/add',methods=['GET'])
def agregar():
    # Si tienes un request que tiene JSON
    if not request.args.get('superhero_name') or not request.args.get('full_name') or not request.args.get('height_cm') or not request.args.get('weight_kg'):
        return jsonify({"mensaje":"No hay request JSON"}),400
    # Si no 
    data = (request.args.get('superhero_name'),request.args.get('full_name'),request.args.get('height_cm'),request.args.get('weight_kg'),)
    add_hero(data)
    return 'Superheroe agregado'

# Método para editar un superheroe
@app.route('/update',methods=['GET'])
def actualizar():
    # Si tienes un request que tiene JSON
    if not request.args.get('superhero_name') or not request.args.get('full_name') or not request.args.get('height_cm') or not request.args.get('weight_kg'):
        return jsonify({"mensaje":"No hay request JSON"}),400
    # Si no 
    data = (request.args.get('full_name'),request.args.get('height_cm'),request.args.get('weight_kg'),request.args.get('superhero_name'),)
    put_hero(data)
    return 'Superheroe modificado'

# Método para eliminar un superheroe
@app.route('/delete',methods=['GET'])
def eliminar():
    # Si tienes un request que tiene JSON
    if not request.args.get('superhero_name') or not request.args.get('full_name') or not request.args.get('height_cm') or not request.args.get('weight_kg'):
        return jsonify({"mensaje":"No hay request JSON"}),400
    # Si no 
    data = (request.args.get('superhero_name'),request.args.get('full_name'),request.args.get('height_cm'),request.args.get('weight_kg'),)
    delete_hero(data)
    return 'Superheroe eliminado'

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=8080)