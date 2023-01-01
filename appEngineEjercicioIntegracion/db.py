import os
import pymysql
from flask import jsonify

db_user = os.environ.get('CLOUD_SQL_USERNAME')
db_password = os.environ.get('CLOUD_SQL_PASSWORD')
db_name = os.environ.get('CLOUD_SQL_DATABASE')
db_connection_name = os.environ.get('CLOUD_SQL_CONNECTION_NAME')

def open_connection():
    unix_socket = '/cloudsql/{}'.format(db_connection_name)
    try:
        # Una variable del servidor del cloud
        # Si app.yaml existe, agarra los datos
        if os.environ.get('GAE_ENV') == 'standard':
            conn = pymysql.connect(user=db_user,password=db_password,
                                unix_socket=unix_socket, db=db_name, cursorclass=pymysql.cursors.DictCursor)

    except pymysql.MySQLError as e:
        print(e)
    
    return conn

def get_heroes():
    conn = open_connection()
    with conn.cursor() as cursor:
        result = cursor.execute('SELECT superhero_name, full_name, height_cm, weight_kg FROM superhero LIMIT 10')
        heroes = cursor.fetchall()
        if result > 0:
            got_heroes = jsonify({'heroes':heroes})
        else:
            got_heroes = jsonify({"mensaje":"No hay superheroes en la bd"}),400
    conn.close()
    return got_heroes

def get_hero(hero):
    conn = open_connection()
    with conn.cursor() as cursor:
        result = cursor.execute('SELECT superhero_name, full_name, height_cm, weight_kg FROM superhero WHERE superhero_name=%s',hero[0])
        heroes = cursor.fetchall()
        if result > 0:
            got_hero = jsonify({'heroes':heroes})
        else:
            got_hero = jsonify({"mensaje":"No hay superheroes en la bd"}),400
    conn.close()
    return got_hero

def add_hero(hero):
    conn = open_connection()
    with conn.cursor() as cursor:
        cursor.execute('INSERT INTO superhero(superhero_name, full_name, height_cm, weight_kg) VALUES (%s,%s,%s,%s)',
                        (hero[0],hero[1],hero[2],hero[3]))
    conn.commit()
    conn.close

def put_hero(hero):
    conn = open_connection()
    with conn.cursor() as cursor:
        cursor.execute('UPDATE superhero SET full_name=%s, height_cm=%s, weight_kg=%s WHERE superhero_name=%s',
                        (hero[0],hero[1],hero[2],hero[3]))
    conn.commit()
    conn.close

def delete_hero(hero):
    conn = open_connection()
    with conn.cursor() as cursor:
        cursor.execute('DELETE FROM superhero WHERE superhero_name=%s and full_name=%s and height_cm=%s and weight_kg=%s ',
                        (hero[0],hero[1],hero[2],hero[3]))
    conn.commit()
    conn.close