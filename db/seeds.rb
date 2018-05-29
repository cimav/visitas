# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Department.create(id:1, name:'Departamento de Física de Materiales') rescue puts 'El departamento ya existe'
Department.create(id:2, name:'Departamento de Ingeniería y Química de Materiales') rescue puts 'El departamento ya existe'
Department.create(id:3, name:'Departamento de Metalurgia e Integridad Estructural') rescue puts 'El departamento ya existe'
Department.create(id:4, name:'Departamento de Medio Ambiente y Energía') rescue puts 'El departamento ya existe'
Department.create(id:5, name:'Laboratorios de Servicios Generales, Talleres y TIC') rescue puts 'El departamento ya existe'