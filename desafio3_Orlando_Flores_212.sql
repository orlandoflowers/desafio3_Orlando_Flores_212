--Database name: Desafio3_Orlando_Flores_212

--Para este desafío debes crear una base de datos con las siguientes tablas.
--setup tabla usuarios


CREATE TABLE usuarios(
id serial,
email varchar,
nombre varchar,
apellido varchar,
rol varchar
);

--Ingresa 5 usuarios, al menos uno con rol de admin
INSERT INTO usuarios VALUES (default, 'a@gmail.com', 'Alejandra', 'Arenas', 'admin');
INSERT INTO usuarios VALUES (default, 'b@gmail.com', 'Barbara', 'Bruces', 'engineer');
INSERT INTO usuarios VALUES (default, 'c@gmail.com', 'Carlos', 'Carmona', 'designer');
INSERT INTO usuarios VALUES (default, 'd@gmail.com', 'Daniel', 'Diaz', 'scientist');
INSERT INTO usuarios VALUES (default, 'e@gmail.com', 'Eugenia', 'Errazuriz', 'analyst');

--check data
SELECT * FROM usuarios;


--setup table posts
CREATE TABLE posts(
id serial,
titulo varchar,
contenido text,
fecha_creacion timestamp,
fecha_actualizacion timestamp,
destacado boolean,
usuario_id bigint
);

--check data
SELECT * FROM posts;


--ingresa 5 posts
INSERT INTO posts VALUES (default, 'Felicidades', 'Muy feliz con el uso del producto', '2023-12-02', '2023-12-02', true, 1);
INSERT INTO posts VALUES (default, 'Espectacular', 'Feliz por el equipo, producto espectacular', '2023-12-03', '2023-12-03', true, 1);
INSERT INTO posts VALUES (default, 'Bien', 'Feliz por el buen producto', '2023-12-04', '2023-12-04', false, 2);
INSERT INTO posts VALUES (default, 'Regular', 'Un producto regular', '2023-12-05', '2023-12-05', true, 3);
INSERT INTO posts VALUES (default, 'Insuficiente', 'Un producto que no cumple', '2023-12-06', '2023-12-06', false, null);


--setup table comentarios
CREATE TABLE comentarios(
id serial,
contenido text,
fecha_creacion timestamp,
usuario_id bigint,
post_id bigint
);

--check data
SELECT * FROM comentarios;

--ingresa 5 comentarios
INSERT INTO comentarios VALUES (default, 'Comentario contenido uno', '2023-12-02', 1, 1);
INSERT INTO comentarios VALUES (default, 'Comentario contenido dos', '2023-12-03', 2, 1);
INSERT INTO comentarios VALUES (default, 'Comentario contenido tres', '2023-12-04', 3, 1);
INSERT INTO comentarios VALUES (default, 'Comentario contenido cuatro', '2023-12-05', 1, 2);
INSERT INTO comentarios VALUES (default, 'Comentario contenido cinco', '2023-12-06', 2, 2);


--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido. (ya realizado)

--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
JOIN posts p
ON u.id = p.usuario_id;


--3. Muestra el id, título y contenido de los posts de los administradores.

SELECT p.id, p.titulo, p.contenido
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
WHERE u.rol = 'admin';


--4. Cuenta la cantidad de posts de cada usuario.
-- a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

--5. Muestra el email del usuario que ha creado más posts.
--a. Aquí la tabla resultante tiene un único registro y muestra solo el email. (debe mostrar email del usuario y cantidad de posts creados)

SELECT u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

--6. Muestra la fecha del último post de cada usuario. (debe mostrar email usuario, el titulo del post y fecha de creacion)
--Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT u.email, p.titulo, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email, p.titulo;


--7. Muestra el título y contenido del post (artículo) con más comentarios. (debe mostrar titulo del post, contenido del post y cantidad de comentarios)

SELECT p.titulo, p.contenido, COUNT(c.id) AS cantidad_comentarios
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
GROUP BY p.titulo, p.contenido
ORDER BY COUNT(c.id) DESC
LIMIT 1;

--8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió. (debe mostrar solo los posts que han sido comentados)

SELECT p.titulo AS titulo_post, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email AS email_usuario
FROM posts p
JOIN comentarios c ON p.id = c.post_id
JOIN usuarios u ON c.usuario_id = u.id;

--9. Muestra el contenido del último comentario de cada usuario. (debe mostrar el email del usuario, el contenido del comentario y solo los usuarios que han hecho comentarios)

SELECT u.email, c.contenido AS ultimo_comentario
FROM usuarios u
JOIN (
    SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha
    FROM comentarios
    GROUP BY usuario_id
) max_fecha ON u.id = max_fecha.usuario_id
JOIN comentarios c ON u.id = c.usuario_id AND max_fecha.ultima_fecha = c.fecha_creacion


--10. Muestra los emails de los usuarios que no han escrito ningún comentario.
--Hint: Recuerda el uso de Having (obligatorio uso de Having)

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;








