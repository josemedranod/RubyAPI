#encoding: utf-8 
#Las librerías que se necesitan son json y rest-client 
#para hacer las peticiones a un servidor

require 'json'
require 'rest-client'

# Para correr este programa es necesario tener instalado Ruby
# El comando para correrlo es ruby main.rb
# Asegurate de estar en la carpeta correcta.


# Este método trae los primeros 10 superheroes de la BD
def ver_superheroes()
 
    # Este es el URL del API REST a consumir 
    url = "https://sound-arcade-367913.uc.r.appspot.com"

    # La clase RestClient con el metodo Get llama a la URL
    # Tenemos 3 variables la respuesta del servidor, la petición y resultado
    RestClient.get(url) { | response, request, result | 
        # Si la respuesta del servidor es 200 --> Que está bien
        if response.code == 200
            #La respuesta se pasa a un objeto JSON
            result = JSON.parse response.to_str
            
            # Desplegar los nombres de los superheroes 
            # Ubicando los 10 primeros objetos del json
            # Se recorre un ciclo del 0 al 9 incluido
            puts "\n |    TOP 10 Superheroes   |"
            (0..99).each do |i|
                # Se obtiene del json "Result" el objeto heroes, que contiene varios objetos adentro
                # Se recorren los objetos y se busca el titulo "superhero_name" 
                superhero_name = result['heroes'][i]['superhero_name']
                # Después se imprime el nombre del superheroe catalogado en lista numerica ascendente. 
                puts "\t #{i+1}. #{superhero_name}"
            end
        # Si el codigo de respuesta es 400, se retorna el mensaje de error
        elsif response.code == 400
            return response.to_str
        end
    }
end

# Este método busca solo 1 superheroe
def Buscar_superheroe(nombre, caso)
 
    # Este es el URL del API REST a consumir 
    url = "https://sound-arcade-367913.uc.r.appspot.com/buscar?superhero_name=#{nombre}"
    
    # La clase RestClient con el metodo Get llama a la URL
    # Tenemos 3 variables la respuesta del servidor, la petición y resultado
    RestClient.get(url) { | response, request, result | 
        # Si la respuesta del servidor es 200 --> Que está bien
        if response.code == 200
            #La respuesta se pasa a un objeto JSON
            result = JSON.parse response.to_str
            
            #Se van a hacer las variables que se acceden:
            #Primero con el nombre del objeto
            #Después el numero del objeto a entrar (en este caso 0)
            superhero_name = result['heroes'][0]['superhero_name']
            full_name = result['heroes'][0]['full_name']
            weight_kg = result['heroes'][0]['weight_kg']
            height_cm = result['heroes'][0]['height_cm']

            # El caso define como se despliegan los datos
            # El caso 0 es para cuando los datos
            if caso == 0
                return "\nEl nombre del superheroe es: #{superhero_name} \nSu nombre completo es: #{full_name} \nMide #{height_cm}cm \nPesa #{weight_kg}kg"
            elsif caso == 1
                return superhero_name, full_name, height_cm, weight_kg
            end
        
        # Si el codigo de respuesta es 400, se retorna el mensaje de error
        elsif response.code == 400
            result = JSON.parse response.to_str
            return result['mensaje']
        end
    }
end    

# Este método agrega un superheroe
def Agregar_superheroe(name, full, height, weight)

    # Este es el URL del API REST a consumir con el método GET
    url = "https://sound-arcade-367913.uc.r.appspot.com/add?superhero_name=#{name}&full_name=#{full}&height_cm=#{height}&weight_kg=#{weight}"
    
    # Al hacer la petición la url ya tiene los datos que van a ser extraidos para su inserción en Flask y Mysql
    RestClient.get(url) { | response, request, result | 

        # Si la respuesta del servidor es 200 --> Que está bien
        if response.code == 200
            return response.to_str
        # Si el codigo de respuesta es 400, se retorna el mensaje de error
        elsif response.code == 400
            result = JSON.parse response.to_str
            return result['mensaje']
        end
    }
end

def Modificar_superheroe(name, full, height, weight)
    
    # Este es el URL del API REST a consumir con el método GET
    url = "https://sound-arcade-367913.uc.r.appspot.com/update?superhero_name=#{name}&full_name=#{full}&height_cm=#{height}&weight_kg=#{weight}"
    
    RestClient.get(url) { | response, request, result | 
        
        # Si la respuesta del servidor es 200 --> Que está bien
        if response.code == 200
            return response.to_str
        # Si el codigo de respuesta es 400, se retorna el mensaje de error
        elsif response.code == 400
            result = JSON.parse response.to_str
            return result['mensaje']
        end
    }
end

def Eliminar_superheroe(name, full, height, weight)
    
    # Este es el URL del API REST a consumir con el método GET
    url = "https://sound-arcade-367913.uc.r.appspot.com/delete?superhero_name=#{name}&full_name=#{full}&height_cm=#{height}&weight_kg=#{weight}"
    
    RestClient.get(url) { | response, request, result | 

        # Si la respuesta del servidor es 200 --> Que está bien
        if response.code == 200
            return response.to_str
        # Si el codigo de respuesta es 400, se retorna el mensaje de error
        elsif response.code == 400
            result = JSON.parse response.to_str
            return result['mensaje']
        end
    }
end

# Menú

loop do
    
    puts "\nPara ver los top 10 superheroes, escribe 1"
    puts "Para ver un solo superheroe, escribe 2"
    puts "Para agregar un superheroe, escribe 3"
    puts "Para modificar un superheroe, escribe 4"
    puts "Para eliminar un superheroe, escribe 5"
    puts "Para salir del menu, escribe 6\n"

    # Una validación por si no se escribe un numero
    begin
        valor = gets.chomp.to_i
    rescue 
    end

    if valor == 1
        ver_superheroes()

    elsif valor == 2
        puts "\nDe que superheroe te gustaría conocer su información"
        nombre = gets.chomp
        # Este método desplegará la información del superheroe
        if nombre == "" or nombre == " "
            puts "No se pueden consultar superheroes con el campo vacio"
        else
            n = Buscar_superheroe(nombre,0)
            if n == "No hay superheroes en la bd"
                puts "No se puede ver ese superheroe. Intenta insertar el nombre completo"
            else
                puts n
            end
        end

    elsif valor == 3
        puts "\nEscribe la información de tu nuevo superheroe"
        puts "Nombre famoso:"
        nombre = gets.chomp.scan(/[a-zA-Z\s]/).join
        puts "Nombre completo:"
        full = gets.chomp.scan(/[a-zA-Z\s]/).join
        puts "Cuanto crees que pese en kg:"
        weight = gets.chomp.to_i
        
        puts "Cuanto crees que mida en cm:"
        height = gets.chomp.to_i
        if nombre == "" or nombre == " " or full == "" or full == " " or
            weight == "" or weight == " " or height == "" or height == " " 
            puts "No se puede agregar un superheroe sin datos"
        else
            n = Agregar_superheroe(nombre, full, height, weight)
            if n == "No hay request JSON"
                puts "No se agregó el superheroe porque faltan datos"
            else
                puts n
            end
        end

    elsif valor == 4

        puts "\nIngresa el nombre de tu superheroe"
        nombre = gets.chomp
        n, f, h, w = Buscar_superheroe(nombre,1)

        if n == "No hay superheroes en la bd"
            puts "No se encontró el superheroe. Intenta con el nombre completo"
        else
            puts "\nEl nombre del superheroe es: #{n} \nSu nombre completo es: #{f} \nMide #{h}cm \nPesa #{w}kg\n"

            f1 = f 
            h1 = h 
            w1 = w 

            puts "\n¿Cambiarías su nombre completo? Si o No"
            d1 = gets.chomp
            if d1 == "Si" or d1 == "si" or d1 == "sI"
                puts "Nombre completo:"
                f = gets.chomp
            end
            f = f.scan(/[a-zA-Z\s]/).join

            puts "¿Cambiarías su peso? Si o No"
            d1 = gets.chomp
            if d1 == "Si" or d1 == "si" or d1 == "sI"
                puts "Peso:"
                w = gets.chomp
            end
        
            puts "¿Cambiarías su altura? Si o No"
            d1 = gets.chomp
            if d1 == "Si" or d1 == "si" or d1 == "sI"
                puts "Altura:"
                h = gets.chomp
            end
            if f1 == f and w1 == w and h1 == h1
                puts "No se realizaron modificaciones al superheroe"
            else
                x = Modificar_superheroe(n, f, h, w)
                if x == "No hay request JSON"
                    puts "No se modificó el superheroe porque faltan datos"
                else
                    puts x
                end
            end
        end

    elsif valor == 5
        
        puts "\nIngresa el nombre de tu superheroe que deseas eliminar"
        nombre = gets.chomp
    
        n, f, h, w = Buscar_superheroe(nombre,1)

        if n == "No hay superheroes en la bd" or n == "No hay request JSON"
            puts "No se encontró el superheroe. Intenta con el nombre completo"
        else
            puts "\nEl nombre del superheroe es: #{n} \nSu nombre completo es: #{f} \nMide #{h}cm \nPesa #{w}kg\n"

            puts "\nEstás seguro de que quieres eliminar a #{n}. Si o No"
            d1 = gets.chomp
            if d1 == "Si" or d1 == "si" or d1 == "sI"
                n = n.gsub(" ","%20")
                f = f.gsub(" ","%20")
                puts Eliminar_superheroe(n,f,h,w)
            else
                puts "#{n} no fué eliminado"
            end
        end

    # Con esta opción el programa se termina de correr
    elsif valor == 6
        puts "\n\tPrograma terminado!!!\n"
        break

    # Validación para no agregar numeros fuera del rango
    elsif valor >= 7 or valor <= 0
        puts "\n\tNúmero inválido\n"
    end
end