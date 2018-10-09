# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Department.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE departments AUTO_INCREMENT = 1')

Department.create(name:'Departamento de Física de Materiales')
Department.create(name:'Departamento de Ingeniería y Química de Materiales')
Department.create(name:'Departamento de Metalurgia e Integridad Estructural')
Department.create(name:'Departamento de Medio Ambiente y Energía')
Department.create(name:'Servicios Generales')

#Se crean laboratorios
Room.delete_all
ActiveRecord::Base.connection.execute('ALTER TABLE rooms AUTO_INCREMENT = 1')

#Laboratorios de Física de materiales
Department.find_by_name('Departamento de Física de Materiales').rooms.create(
    [
        {name:'Baterias de Litio'},
        {name:'Recubrimientos metálicos'},
        {name:'Películas delgadas'},
        {name:'Magnéticos'},
        {name:'Estrés residual'},
        {name:'Cerámicos funcionales'}
    ]
)

#Laboratorios de Ingeniería y Química de Materiales
Department.find_by_name('Departamento de Ingeniería y Química de Materiales').rooms.create(
    [
        {name:'Materiales Nanoestructurales'},
        {name:'Sensores poliméricos'},
        {name:'Reología'},
        {name:'Química de polímeros'},
        {name:'Procesamiento de polímeros'},
        {name:'HDS y Sol Gel'},
        {name:'Fotocatálisis'},
        {name:'Celdas de combusible'},
        {name:'Catálisis'}
    ]
)

#Laboratorios de Metalurgia e Integridad Estructural
Department.find_by_name('Departamento de Metalurgia e Integridad Estructural').rooms.create(
    [
        {name:'Recubrimientos Electroless'},
        {name:'Prototipos e Integridad Mecánica'},
        {name:'Propiedades Opticas de Materiales'},
        {name:'Nano Indentador'},
        {name:'Ensayos No Destructivos'},
        {name:'Corrosión y Protección'},
        {name:'Caracterización Mecánica de Fibras'},
        {name:'Atomización de Metales'},
        {name:'Aleado Mecánico'}
    ]
)

#Laboratorios de Medio Ambiente y Energía
Department.find_by_name('Departamento de Medio Ambiente y Energía').rooms.create(
    [
        {name:'Vigilancia radiológica'},
        {name:'Toxicología'},
        {name:'Residuos'},
        {name:'Nanocosmos (Química computacional)'},
        {name:'Nanocosmos (Bio Nano'},
        {name:'Calidad del aire'},
        {name:'Biohidrometalurgia'},
        {name:'Beneficio de materiales'},
        {name:'Automatización de técnicas analíticas'}
    ]
)

#Laboratorios de Servicios Generales
Department.find_by_name('Servicios Generales').rooms.create(
    [
        {name:'Materiales Cerámicos'},
        {name:'Análisis térmicos'},
        {name:'Tecnologías de la Información y Comunicaciones'},
        {name:'Cluster de cómputo científico'},
        {name:'Pruebas mecánicas'},
        {name:'Rayos X'},
        {name:'Metrología'},
        {name:'Análisis químicos'},
        {name:'Taller de prototipos'},
    ]
)
