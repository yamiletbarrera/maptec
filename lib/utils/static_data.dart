// * INFORMACIÓN IMPORTANTE: De este archivo se usa el Map linksDepartamentos así que no borrar.

const linksDepartamentos = {
  "Departamento de Ciencias Básicas":
      "https://www.cuautla.tecnm.mx/cie_basicas",
  "Departamento de Sistemas y Computación":
      "https://www.cuautla.tecnm.mx/sis_com",
  "Departamento de Metal - Mecánica":
      "https://www.cuautla.tecnm.mx/metal_mecanica",
  "Departamento de Eléctrica y Electrónica":
      "https://www.cuautla.tecnm.mx/electrica_electronica",
  "Departamento de Ciencias Económico-Administrativas":
      "https://www.cuautla.tecnm.mx/dep_eco_adm",
  "Departamento de Desarrollo Académico":
      "https://www.cuautla.tecnm.mx/des_acad",
  "División de Estudios Profesionales":
      "https://www.cuautla.tecnm.mx/div_est_prf",
  "Departamento de Planeación, Programación y Presupuestación":
      "https://www.cuautla.tecnm.mx/dep_p_p_p",
  "Departamento de Gestión Tecnológica y Vinculación":
      "https://www.cuautla.tecnm.mx/dep_g_t_v",
  "Departamento de Comunicación y Difusión":
      "https://www.cuautla.tecnm.mx/comunicacion_difusion",
  "Departamento de Actividades Extraescolares":
      "https://www.cuautla.tecnm.mx/dep_activ_ext",
  "Departamento de Servicios Escolares": "https://www.cuautla.tecnm.mx/ser_es",
  "Departamento de Centro de Información":
      "https://www.cuautla.tecnm.mx/cent_info",
  "Departamento de Recursos Humanos":
      "https://www.cuautla.tecnm.mx/dep_rec_hum",
  "Departamento de Recursos Financieros":
      "https://www.cuautla.tecnm.mx/dep_rec_fin",
  "Departamento de Recursos Materiales y Servicios":
      "https://www.cuautla.tecnm.mx/dep_rec_mat",
  "Departamento de Mantenimiento y Equipo":
      "https://www.cuautla.tecnm.mx/dep_mant_equi",
  "Departamento de Centro de Cómputo":
      "https://www.cuautla.tecnm.mx/cent_compt",
  "Subdirección Académica": "https://www.cuautla.tecnm.mx/sub_acad",
  "Subdirección de Planeación y Vinculación":
      "https://www.cuautla.tecnm.mx/sub_plan_v",
  "Subdirección de Servicios Administrativos":
      "https://www.cuautla.tecnm.mx/sub_serv_ad",
  "Dirección": "https://www.cuautla.tecnm.mx/direccion",
  "Posgrado": "https://www.cuautla.tecnm.mx/dep_posgrado",
};

const staticDataDepartamentos = {
  "data": [
    {
      "id_departamento": 1,
      "nombre": "Departamento de Ciencias Básicas",
      "edificio": {
        "id_edificio": 7,
        "nombre": "G",
        "numaulas": 14,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 1,
        "nombre": "Mtra. Ma. de los Ángeles",
        "apellido": "Alcántara Barrera",
        "correo": "basicas@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/cie_basicas"
    },
    {
      "id_departamento": 2,
      "nombre": "Departamento de Sistemas y Computación",
      "edificio": {
        "id_edificio": 5,
        "nombre": "E",
        "numaulas": 14,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 2,
        "nombre": "Ing. Gisela",
        "apellido": "Vega Torres",
        "correo": "sistemas@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/sis_com"
    },
    {
      "id_departamento": 3,
      "nombre": "Departamento de Metal - Mecánica",
      "edificio": {
        "id_edificio": 7,
        "nombre": "G",
        "numaulas": 14,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 3,
        "nombre": "Ing. María del Rubí",
        "apellido": "Hernández Andrade",
        "correo": "metal@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/metal_mecanica"
    },
    {
      "id_departamento": 4,
      "nombre": "Departamento de Electrica y Electrónica",
      "edificio": {
        "id_edificio": 7,
        "nombre": "G",
        "numaulas": 14,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 4,
        "nombre": "Mtra. Marlem",
        "apellido": "Flores Montiel",
        "correo": "electronica@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/electrica_electronica"
    },
    {
      "id_departamento": 5,
      "nombre": "Departamento de Ciencias Económico - Administrativo",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 5,
        "nombre": "Mtro. Omar Oswaldo",
        "apellido": "Torres Fernández",
        "correo": "economico@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_eco_adm"
    },
    {
      "id_departamento": 6,
      "nombre": "Departamento de Desarrollo Académico",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 6,
        "nombre": "Mtro. Julio",
        "apellido": "Pérez Machorro",
        "correo": "desarrollo@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/des_acad"
    },
    {
      "id_departamento": 7,
      "nombre": "Departamento de División de Estudios Profesionales",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 7,
        "nombre": "M. I. Leticia",
        "apellido": "Bedolla Vázquez",
        "correo": "division@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/div_est_prf"
    },
    {
      "id_departamento": 8,
      "nombre": "Departamento de Planeación, Programación y Presupuestación",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 8,
        "nombre": "M. E. Guillermina",
        "apellido": "Sánchez Marino",
        "correo": "planeacion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_p_p_p"
    },
    {
      "id_departamento": 9,
      "nombre": "Departamento de Gestión Tecnológica y Vinculación",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 9,
        "nombre": "M.F.G. Areli Soledad",
        "apellido": "Ruíz Martínez",
        "correo": "gestion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_g_t_v"
    },
    {
      "id_departamento": 10,
      "nombre": "Departamento de Comunicación y Difusión",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 10,
        "nombre": "Ing. Josué Iván",
        "apellido": "Jaimes Perez",
        "correo": "comunicacion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/comunicacion_difusion"
    },
    {
      "id_departamento": 11,
      "nombre": "Departamento de Actividades Extraescolares",
      "edificio": {
        "id_edificio": 4,
        "nombre": "D",
        "numaulas": 0,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 11,
        "nombre": "Lic. Roberto Marcio",
        "apellido": "Cuauhtle Pluma",
        "correo": "extraescolares@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_activ_ext"
    },
    {
      "id_departamento": 12,
      "nombre": "Departamento de Servicios Escolares",
      "edificio": {
        "id_edificio": 2,
        "nombre": "B",
        "numaulas": 0,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 12,
        "nombre": "M. C. Moisés",
        "apellido": "Román Sedeño",
        "correo": "escolares@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/ser_es"
    },
    {
      "id_departamento": 13,
      "nombre": "Departamento de Centro de información",
      "edificio": {
        "id_edificio": 8,
        "nombre": "H",
        "numaulas": 4,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 13,
        "nombre": "Lic. Norma Angelica",
        "apellido": "Morales Tablas",
        "correo": "c.informacion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/cent_info"
    },
    {
      "id_departamento": 14,
      "nombre": "Departamento de Recursos Humanos",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 14,
        "nombre": "Mtro. José Luís",
        "apellido": "Eguía Rivas",
        "correo": "humanos@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_rec_hum"
    },
    {
      "id_departamento": 15,
      "nombre": "Departamento de Recursos Financieros",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 15,
        "nombre": "C. P. Estela",
        "apellido": "Mendoza Mondragón",
        "correo": "financieros@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_rec_fin"
    },
    {
      "id_departamento": 16,
      "nombre": "Departamento de Recursos Materiales y Servicios",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 16,
        "nombre": "Ing. Braulio",
        "apellido": "González Román",
        "correo": "materiales@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_rec_mat"
    },
    {
      "id_departamento": 17,
      "nombre": "Departamento de Manteniemiento y Equipo",
      "edificio": {
        "id_edificio": 3,
        "nombre": "C",
        "numaulas": 0,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 17,
        "nombre": "Ing. Noel",
        "apellido": "Morales Muñiz",
        "correo": "mantenimiento@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_mant_equi"
    },
    {
      "id_departamento": 18,
      "nombre": "Departamento de Centro de Cómputo",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 18,
        "nombre": "Ing. Victor Manuel",
        "apellido": "Ayala Lara",
        "correo": "c.computo@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/cent_compt"
    },
    {
      "id_departamento": 19,
      "nombre": "Subdirección Académica",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 19,
        "nombre": "Dra. Zully",
        "apellido": "Vargas Galarza",
        "correo": "sub.academica@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/sub_acad"
    },
    {
      "id_departamento": 20,
      "nombre": "Subdirección de Planeación y Vinculación",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 20,
        "nombre": "C.P. María Magdalena",
        "apellido": "Leyva Valles",
        "correo": "sub.planeacion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/sub_plan_v"
    },
    {
      "id_departamento": 21,
      "nombre": "Subdirección de Servicios Administrativos",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 21,
        "nombre": "M. A. Angélica",
        "apellido": "Gómez Cárdenas",
        "correo": "sub.administrativa@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/sub_serv_ad"
    },
    {
      "id_departamento": 22,
      "nombre": "Dirección",
      "edificio": {
        "id_edificio": 6,
        "nombre": "F",
        "numaulas": 3,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 22,
        "nombre": "M. en C. Porfirio Roberto",
        "apellido": "Nájera Medina",
        "correo": "direccion@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/direccion"
    },
    {
      "id_departamento": 23,
      "nombre": "Posgrado",
      "edificio": {
        "id_edificio": 8,
        "nombre": "H",
        "numaulas": 4,
      },
      "jefeDepartamento": {
        "id_jefeDepartamento": 23,
        "nombre": "C. P. Mónica Leticia",
        "apellido": "Acosta Miranda",
        "correo": "posgrado@cuautla.tecnm.mx",
      },
      "linkInfo": "https://www.cuautla.tecnm.mx/dep_posgrado"
    },
  ]
};

// /api/laboratorios.php
const laboratorios = {
  "data": [
    {
      "id_laboratorio": "string or int",
      "nombre": "string",
      "edificio": {
        "id_edificio": "string",
        "nombre": "string",
        "numaulas": "int or string",
      },
    },
  ],
};

// /api/audiovisuales.php
const audiovisuales = {
  "data": [
    {
      "id_sala": "string or int",
      "nombre": "string",
      "edificio": {
        "id_edificio": "string",
        "nombre": "string",
        "numaulas": "int or string",
      },
    },
  ],
};

// /api/cubiculos.php
const cubiculos = {
  "data": [
    {
      "id_cubiculo": "string",
      "nombre": "string",
      "correo": "string",
      "edificio": {
        "id_edificio": "string",
        "nombre": "string",
        "numaulas": "int or string",
      },
    },
  ],
};
