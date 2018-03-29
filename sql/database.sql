PGDMP     "    ,                v           db    10.3    10.3 K    K           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            L           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            M           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            N           1262    16601    db    DATABASE     �   CREATE DATABASE db WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE db;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            O           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            P           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    16864    add_default_quantities_f()    FUNCTION       CREATE FUNCTION public.add_default_quantities_f() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO quantities_t VALUES (DEFAULT, NEW.id, '__MASS__', 'kg', 1);
	INSERT INTO quantities_t VALUES (DEFAULT, NEW.id, '__HEIGHT__', 'cm', 2);
	
	RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.add_default_quantities_f();
       public       postgres    false    3    1            �            1255    16795 "   add_food_f(integer, integer, real)    FUNCTION     �  CREATE FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) RETURNS TABLE(id integer, foodstuff_id integer, meal_id integer, quantity real, unit character, name character varying, calories real, carbs real, proteins real, fats real)
    LANGUAGE plpgsql
    AS $$

#variable_conflict use_column

DECLARE
	unit_v character(2);
	name_v character varying(128);
	calories_v real;
	carbs_v real;
	proteins_v real;
	fats_v real;

BEGIN
	SELECT
		unit,
		name,
		calories * quantity_a,
		carbs * quantity_a,
		proteins * quantity_a,
		fats * quantity_a
	INTO
		unit_v, name_v, calories_v, carbs_v, proteins_v, fats_v
	FROM
		foodstuffs_t
	WHERE
		id = foodstuff_id_a;
	
	RETURN QUERY
	INSERT INTO
		foods_t
	VALUES (
		DEFAULT,
		foodstuff_id_a,
		meal_id_a,
		quantity_a,
		unit_v,
		name_v,
		calories_v,
		carbs_v,
		proteins_v,
		fats_v)
	ON CONFLICT
	ON CONSTRAINT foods_t_foodstuff_id_meal_id_key
	DO UPDATE
	SET
		quantity = quantity_a,
		calories = calories_v,
		carbs = carbs_v,
		proteins = proteins_v,
		fats = fats_v
	RETURNING
		id,
		foodstuff_id,
		meal_id,
		quantity,
		unit,
		name,
		calories,
		carbs,
		proteins,
		fats;
END;

$$;
 ]   DROP FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real);
       public       postgres    false    3    1            �            1255    16801 K   add_foodstuff_f(real, character, character varying, real, real, real, real)    FUNCTION     �  CREATE FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO foodstuffs_t VALUES (
											DEFAULT,
											unit_a,
											name_a,
											ROUND((calories_a / quantity_a)::numeric, 3),
											ROUND((carbs_a / quantity_a)::numeric, 3),
											ROUND((proteins_a / quantity_a)::numeric, 3),
											ROUND((fats_a / quantity_a)::numeric, 3))
	RETURNING id, unit, name, calories, carbs, proteins, fats;
END;

$$;
 �   DROP FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real);
       public       postgres    false    3    1            �            1255    16934 #   add_meal_f(smallint, integer, date)    FUNCTION     C  CREATE FUNCTION public.add_meal_f(type_a smallint, user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY INSERT INTO meals_t VALUES (DEFAULT, type_a, user_id_a, date_a) RETURNING id, type, '[]'::json;
END;

$$;
 R   DROP FUNCTION public.add_meal_f(type_a smallint, user_id_a integer, date_a date);
       public       postgres    false    1    3            �            1255    16986     add_measurement_f(integer, real)    FUNCTION     �  CREATE FUNCTION public.add_measurement_f(quantity_id_a integer, value_a real) RETURNS TABLE(id integer, quantity_id integer, value real, date date)
    LANGUAGE plpgsql
    AS $$

#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO
		measurements_t
	VALUES
		(DEFAULT, quantity_id_a, value_a)
	ON CONFLICT
	ON CONSTRAINT
		measurements_t_quantity_id_date_key
	DO UPDATE
	SET
		value = value_a
	RETURNING *;
END;

$$;
 M   DROP FUNCTION public.add_measurement_f(quantity_id_a integer, value_a real);
       public       postgres    false    1    3            �            1255    16965 5   add_quantity_f(integer, character varying, character)    FUNCTION     �  CREATE FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character) RETURNS TABLE(id integer, user_id integer, name character varying, unit character, type smallint, value real, update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO quantities_t VALUES (DEFAULT, user_id_a, name_a, unit_a, DEFAULT) RETURNING id, user_id, name, unit, type, NULL::real, NULL::timestamp without time zone;
END;
$$;
 d   DROP FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character);
       public       postgres    false    3    1            �            1255    16720 L   add_user_f(character varying, character, date, character varying, character)    FUNCTION     �  CREATE FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, email_a character varying, hash_a character) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, email character varying, type smallint)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO
		users_t
	VALUES
		(DEFAULT, name_a, sex_a, date_of_birth_a, email_a, hash_a)
	RETURNING
		id, name, sex, date_of_birth, email, type;
END;
$$;
 �   DROP FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, email_a character varying, hash_a character);
       public       postgres    false    3    1            �            1255    16758 $   find_foodstuffs_f(character varying)    FUNCTION     \  CREATE FUNCTION public.find_foodstuffs_f(query_a character varying) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
    LANGUAGE plpgsql
    AS $$BEGIN
	RETURN QUERY
	SELECT
		*
	FROM
		foodstuffs_t
	WHERE
		lower(foodstuffs_t.name) LIKE '%' || lower(query_a) || '%';
END;
$$;
 C   DROP FUNCTION public.find_foodstuffs_f(query_a character varying);
       public       postgres    false    1    3            �            1255    16936    get_meal_f(integer, date)    FUNCTION     �  CREATE FUNCTION public.get_meal_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
	SELECT
		meals_t.id, meals_t.type, COALESCE(json_agg(foods_t) FILTER (WHERE foods_t.meal_id IS NOT NULL), '[]') AS foods 
	FROM
		meals_t
	LEFT JOIN
		foods_t
	ON
		meals_t.id = foods_t.meal_id
	WHERE
		meals_t.user_id = user_id_a AND meals_t.date = date_a
	GROUP BY
		meals_t.id
	ORDER BY
		meals_t.type ASC;
END;

$$;
 A   DROP FUNCTION public.get_meal_f(user_id_a integer, date_a date);
       public       postgres    false    1    3            �            1255    16935    get_meals_f(integer, date)    FUNCTION     �  CREATE FUNCTION public.get_meals_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
	SELECT
		meals_t.id, meals_t.type, COALESCE(json_agg(foods_t) FILTER (WHERE foods_t.meal_id IS NOT NULL), '[]') AS foods 
	FROM
		meals_t
	LEFT JOIN
		foods_t
	ON
		meals_t.id = foods_t.meal_id
	WHERE
		meals_t.user_id = user_id_a AND meals_t.date = date_a
	GROUP BY
		meals_t.id;
END;

$$;
 B   DROP FUNCTION public.get_meals_f(user_id_a integer, date_a date);
       public       postgres    false    3    1            �            1255    16987    get_quantities_f(integer)    FUNCTION     _  CREATE FUNCTION public.get_quantities_f(user_id_a integer) RETURNS TABLE(id integer, user_id integer, name character varying, unit character, type smallint, value real, update date)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT
		quantities_t.id,
		quantities_t.user_id,
		quantities_t.name,
		quantities_t.unit,
		quantities_t.type,
		measurements_s.value,
		measurements_s.date
	FROM
		quantities_t
	LEFT JOIN
		(
			WITH summary AS (
				SELECT
					quantity_id,
					value,
					date,
					ROW_NUMBER() OVER (PARTITION BY quantity_id ORDER BY date DESC) as row_number
				FROM
					measurements_t
			)
			SELECT
				*
			FROM
				summary
			WHERE row_number = 1
		) measurements_s
	ON
		quantities_t.id = measurements_s.quantity_id
	WHERE
		quantities_t.user_id = user_id_a
	ORDER BY
		quantities_t.id ASC;
END;
$$;
 :   DROP FUNCTION public.get_quantities_f(user_id_a integer);
       public       postgres    false    3    1            �            1259    16914    foods_t    TABLE     I  CREATE TABLE public.foods_t (
    id integer NOT NULL,
    foodstuff_id integer NOT NULL,
    meal_id integer NOT NULL,
    quantity real NOT NULL,
    unit character(2) NOT NULL,
    name character varying(128) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real NOT NULL
);
    DROP TABLE public.foods_t;
       public         postgres    false    3            �            1259    16912    foods_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.foods_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.foods_t_id_seq;
       public       postgres    false    3    206            Q           0    0    foods_t_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.foods_t_id_seq OWNED BY public.foods_t.id;
            public       postgres    false    205            �            1259    16624    foodstuffs_t    TABLE     �   CREATE TABLE public.foodstuffs_t (
    id integer NOT NULL,
    unit character(2) NOT NULL,
    name character varying(128) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real NOT NULL
);
     DROP TABLE public.foodstuffs_t;
       public         postgres    false    3            �            1259    16622    foodstuff_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.foodstuff_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.foodstuff_t_id_seq;
       public       postgres    false    200    3            R           0    0    foodstuff_t_id_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.foodstuff_t_id_seq OWNED BY public.foodstuffs_t.id;
            public       postgres    false    199            �            1259    16899    meals_t    TABLE     �   CREATE TABLE public.meals_t (
    id integer NOT NULL,
    type smallint NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL
);
    DROP TABLE public.meals_t;
       public         postgres    false    3            �            1259    16897    meals_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.meals_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.meals_t_id_seq;
       public       postgres    false    3    204            S           0    0    meals_t_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.meals_t_id_seq OWNED BY public.meals_t.id;
            public       postgres    false    203            �            1259    16972    measurements_t    TABLE     �   CREATE TABLE public.measurements_t (
    id integer NOT NULL,
    quantity_id integer NOT NULL,
    value real NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);
 "   DROP TABLE public.measurements_t;
       public         postgres    false    3            �            1259    16970    measurements_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.measurements_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.measurements_t_id_seq;
       public       postgres    false    3    208            T           0    0    measurements_t_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.measurements_t_id_seq OWNED BY public.measurements_t.id;
            public       postgres    false    207            �            1259    16832    quantities_t    TABLE     �   CREATE TABLE public.quantities_t (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(128) NOT NULL,
    unit character(16) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);
     DROP TABLE public.quantities_t;
       public         postgres    false    3            �            1259    16830    quantities_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.quantities_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.quantities_t_id_seq;
       public       postgres    false    202    3            U           0    0    quantities_t_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.quantities_t_id_seq OWNED BY public.quantities_t.id;
            public       postgres    false    201            �            1259    16604    users_t    TABLE       CREATE TABLE public.users_t (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    sex character(1) NOT NULL,
    date_of_birth date NOT NULL,
    email character varying(64) NOT NULL,
    hash character(60) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);
    DROP TABLE public.users_t;
       public         postgres    false    3            �            1259    16602    users_t_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.users_t_id_seq;
       public       postgres    false    197    3            V           0    0    users_t_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.users_t_id_seq OWNED BY public.users_t.id;
            public       postgres    false    196            �            1259    16618    users_v    VIEW     �   CREATE VIEW public.users_v AS
 SELECT users_t.id,
    users_t.name,
    users_t.sex,
    users_t.date_of_birth,
    users_t.email
   FROM public.users_t;
    DROP VIEW public.users_v;
       public       postgres    false    197    197    197    197    197    3            �
           2604    16917 
   foods_t id    DEFAULT     h   ALTER TABLE ONLY public.foods_t ALTER COLUMN id SET DEFAULT nextval('public.foods_t_id_seq'::regclass);
 9   ALTER TABLE public.foods_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    206    205    206            �
           2604    16627    foodstuffs_t id    DEFAULT     q   ALTER TABLE ONLY public.foodstuffs_t ALTER COLUMN id SET DEFAULT nextval('public.foodstuff_t_id_seq'::regclass);
 >   ALTER TABLE public.foodstuffs_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    200    200            �
           2604    16902 
   meals_t id    DEFAULT     h   ALTER TABLE ONLY public.meals_t ALTER COLUMN id SET DEFAULT nextval('public.meals_t_id_seq'::regclass);
 9   ALTER TABLE public.meals_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203    204            �
           2604    16975    measurements_t id    DEFAULT     v   ALTER TABLE ONLY public.measurements_t ALTER COLUMN id SET DEFAULT nextval('public.measurements_t_id_seq'::regclass);
 @   ALTER TABLE public.measurements_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    208    208            �
           2604    16835    quantities_t id    DEFAULT     r   ALTER TABLE ONLY public.quantities_t ALTER COLUMN id SET DEFAULT nextval('public.quantities_t_id_seq'::regclass);
 >   ALTER TABLE public.quantities_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    201    202            �
           2604    16607 
   users_t id    DEFAULT     h   ALTER TABLE ONLY public.users_t ALTER COLUMN id SET DEFAULT nextval('public.users_t_id_seq'::regclass);
 9   ALTER TABLE public.users_t ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    196    197    197            F          0    16914    foods_t 
   TABLE DATA               s   COPY public.foods_t (id, foodstuff_id, meal_id, quantity, unit, name, calories, carbs, proteins, fats) FROM stdin;
    public       postgres    false    206   �l       @          0    16624    foodstuffs_t 
   TABLE DATA               W   COPY public.foodstuffs_t (id, unit, name, calories, carbs, proteins, fats) FROM stdin;
    public       postgres    false    200   �l       D          0    16899    meals_t 
   TABLE DATA               :   COPY public.meals_t (id, type, user_id, date) FROM stdin;
    public       postgres    false    204   /m       H          0    16972    measurements_t 
   TABLE DATA               F   COPY public.measurements_t (id, quantity_id, value, date) FROM stdin;
    public       postgres    false    208   ]m       B          0    16832    quantities_t 
   TABLE DATA               E   COPY public.quantities_t (id, user_id, name, unit, type) FROM stdin;
    public       postgres    false    202   �m       >          0    16604    users_t 
   TABLE DATA               R   COPY public.users_t (id, name, sex, date_of_birth, email, hash, type) FROM stdin;
    public       postgres    false    197   �m       W           0    0    foods_t_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.foods_t_id_seq', 3, true);
            public       postgres    false    205            X           0    0    foodstuff_t_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.foodstuff_t_id_seq', 3, true);
            public       postgres    false    199            Y           0    0    meals_t_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.meals_t_id_seq', 2, true);
            public       postgres    false    203            Z           0    0    measurements_t_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.measurements_t_id_seq', 21, true);
            public       postgres    false    207            [           0    0    quantities_t_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.quantities_t_id_seq', 17, true);
            public       postgres    false    201            \           0    0    users_t_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_t_id_seq', 2, true);
            public       postgres    false    196            �
           2606    16921 (   foods_t foods_t_foodstuff_id_meal_id_key 
   CONSTRAINT     t   ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_meal_id_key UNIQUE (foodstuff_id, meal_id);
 R   ALTER TABLE ONLY public.foods_t DROP CONSTRAINT foods_t_foodstuff_id_meal_id_key;
       public         postgres    false    206    206            �
           2606    16919    foods_t foods_t_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.foods_t DROP CONSTRAINT foods_t_pkey;
       public         postgres    false    206            �
           2606    16629    foodstuffs_t foodstuff_t_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.foodstuffs_t DROP CONSTRAINT foodstuff_t_pkey;
       public         postgres    false    200            �
           2606    16631 &   foodstuffs_t foodstuff_t_unit_name_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_unit_name_key UNIQUE (unit, name);
 P   ALTER TABLE ONLY public.foodstuffs_t DROP CONSTRAINT foodstuff_t_unit_name_key;
       public         postgres    false    200    200            �
           2606    16904    meals_t meals_t_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.meals_t DROP CONSTRAINT meals_t_pkey;
       public         postgres    false    204            �
           2606    16906 %   meals_t meals_t_type_user_id_date_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_type_user_id_date_key UNIQUE (type, user_id, date);
 O   ALTER TABLE ONLY public.meals_t DROP CONSTRAINT meals_t_type_user_id_date_key;
       public         postgres    false    204    204    204            �
           2606    16978 "   measurements_t measurements_t_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.measurements_t DROP CONSTRAINT measurements_t_pkey;
       public         postgres    false    208            �
           2606    16980 2   measurements_t measurements_t_quantity_id_date_key 
   CONSTRAINT     z   ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_date_key UNIQUE (quantity_id, date);
 \   ALTER TABLE ONLY public.measurements_t DROP CONSTRAINT measurements_t_quantity_id_date_key;
       public         postgres    false    208    208            �
           2606    16838    quantities_t quantities_t_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.quantities_t DROP CONSTRAINT quantities_t_pkey;
       public         postgres    false    202            �
           2606    16840 *   quantities_t quantities_t_user_id_name_key 
   CONSTRAINT     n   ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_name_key UNIQUE (user_id, name);
 T   ALTER TABLE ONLY public.quantities_t DROP CONSTRAINT quantities_t_user_id_name_key;
       public         postgres    false    202    202            �
           2606    16612    users_t users_t_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.users_t DROP CONSTRAINT users_t_email_key;
       public         postgres    false    197            �
           2606    16610    users_t users_t_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.users_t DROP CONSTRAINT users_t_pkey;
       public         postgres    false    197            �
           2606    16680    users_t users_t_sex_check    CHECK CONSTRAINT     �   ALTER TABLE public.users_t
    ADD CONSTRAINT users_t_sex_check CHECK ((sex = ANY (ARRAY['f'::bpchar, 'm'::bpchar]))) NOT VALID;
 >   ALTER TABLE public.users_t DROP CONSTRAINT users_t_sex_check;
       public       postgres    false    197    197            �
           2620    16865    users_t add_quantities_tr    TRIGGER     �   CREATE TRIGGER add_quantities_tr AFTER INSERT ON public.users_t FOR EACH ROW EXECUTE PROCEDURE public.add_default_quantities_f();
 2   DROP TRIGGER add_quantities_tr ON public.users_t;
       public       postgres    false    220    197            �
           2606    16922 !   foods_t foods_t_foodstuff_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_fkey FOREIGN KEY (foodstuff_id) REFERENCES public.foodstuffs_t(id) ON UPDATE CASCADE;
 K   ALTER TABLE ONLY public.foods_t DROP CONSTRAINT foods_t_foodstuff_id_fkey;
       public       postgres    false    2730    200    206            �
           2606    16927    foods_t foods_t_meal_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals_t(id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.foods_t DROP CONSTRAINT foods_t_meal_id_fkey;
       public       postgres    false    2738    204    206            �
           2606    16907    meals_t meals_t_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.meals_t DROP CONSTRAINT meals_t_user_id_fkey;
       public       postgres    false    204    2728    197            �
           2606    16981 .   measurements_t measurements_t_quantity_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_fkey FOREIGN KEY (quantity_id) REFERENCES public.quantities_t(id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.measurements_t DROP CONSTRAINT measurements_t_quantity_id_fkey;
       public       postgres    false    208    2734    202            �
           2606    16841 &   quantities_t quantities_t_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.quantities_t DROP CONSTRAINT quantities_t_user_id_fkey;
       public       postgres    false    202    2728    197            F      x������ � �      @   ;   x�3�LW��N�IT���K�,.M/�K�4�4�3�a.cΒl΀��NC#N����� �k      D      x�3�4�4�420��50�5������ &�U      H   0   x�34�4�44��420��50�5��2�4�440@22*B����� \|
w      B   L   x�3�4⌏�u����NW@��\�`yWOw����\4F\��@%^�9�
���&���zxk	�J�=... ~�N      >   �   x�3��H�+���M,*��S�JL�.�����4��4�5��52���͂;��&f��%��r�%�X���$�X:{�;[�{X��yd��;�������%%��de�;����rp��qqq 8�$�     