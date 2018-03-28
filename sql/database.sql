--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-03-28 19:23:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 220 (class 1255 OID 16864)
-- Name: add_default_quantities_f(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_default_quantities_f() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO quantities_t VALUES (DEFAULT, NEW.id, '__MASS__', 'kg', 1);
	INSERT INTO quantities_t VALUES (DEFAULT, NEW.id, '__HEIGHT__', 'cm', 2);
	
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_default_quantities_f() OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 16795)
-- Name: add_food_f(integer, integer, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) RETURNS TABLE(id integer, foodstuff_id integer, meal_id integer, quantity real, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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


ALTER FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 16801)
-- Name: add_foodstuff_f(real, character, character varying, real, real, real, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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


ALTER FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16934)
-- Name: add_meal_f(smallint, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_meal_f(type_a smallint, user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY INSERT INTO meals_t VALUES (DEFAULT, type_a, user_id_a, date_a) RETURNING id, type, '[]'::json;
END;

$$;


ALTER FUNCTION public.add_meal_f(type_a smallint, user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 16860)
-- Name: add_quantity_f(integer, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character) RETURNS TABLE(id integer, user_id integer, name character varying, unit character, type smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	INSERT INTO quantities_t VALUES (DEFAULT, user_id_a, name_a, unit_a, DEFAULT) RETURNING *;
END;
$$;


ALTER FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 16720)
-- Name: add_user_f(character varying, character, date, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, email_a character varying, hash_a character) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, email character varying, type smallint)
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


ALTER FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, email_a character varying, hash_a character) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16758)
-- Name: find_foodstuffs_f(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_foodstuffs_f(query_a character varying) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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


ALTER FUNCTION public.find_foodstuffs_f(query_a character varying) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16936)
-- Name: get_meal_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_meal_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
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


ALTER FUNCTION public.get_meal_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 16935)
-- Name: get_meals_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_meals_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
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


ALTER FUNCTION public.get_meals_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 16964)
-- Name: get_quantities_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_quantities_f(user_id_a integer) RETURNS TABLE(id integer, user_id integer, name character varying, unit character, type smallint, value real, update timestamp without time zone)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
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
END;$$;


ALTER FUNCTION public.get_quantities_f(user_id_a integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 206 (class 1259 OID 16914)
-- Name: foods_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods_t (
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


ALTER TABLE public.foods_t OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16912)
-- Name: foods_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foods_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foods_t_id_seq OWNER TO postgres;

--
-- TOC entry 2894 (class 0 OID 0)
-- Dependencies: 205
-- Name: foods_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foods_t_id_seq OWNED BY public.foods_t.id;


--
-- TOC entry 200 (class 1259 OID 16624)
-- Name: foodstuffs_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foodstuffs_t (
    id integer NOT NULL,
    unit character(2) NOT NULL,
    name character varying(128) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real NOT NULL
);


ALTER TABLE public.foodstuffs_t OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16622)
-- Name: foodstuff_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foodstuff_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foodstuff_t_id_seq OWNER TO postgres;

--
-- TOC entry 2895 (class 0 OID 0)
-- Dependencies: 199
-- Name: foodstuff_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foodstuff_t_id_seq OWNED BY public.foodstuffs_t.id;


--
-- TOC entry 204 (class 1259 OID 16899)
-- Name: meals_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meals_t (
    id integer NOT NULL,
    type smallint NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.meals_t OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16897)
-- Name: meals_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meals_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meals_t_id_seq OWNER TO postgres;

--
-- TOC entry 2896 (class 0 OID 0)
-- Dependencies: 203
-- Name: meals_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_t_id_seq OWNED BY public.meals_t.id;


--
-- TOC entry 208 (class 1259 OID 16948)
-- Name: measurements_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.measurements_t (
    id integer NOT NULL,
    quantity_id integer NOT NULL,
    value real NOT NULL,
    date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.measurements_t OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16946)
-- Name: measurements_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.measurements_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurements_t_id_seq OWNER TO postgres;

--
-- TOC entry 2897 (class 0 OID 0)
-- Dependencies: 207
-- Name: measurements_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.measurements_t_id_seq OWNED BY public.measurements_t.id;


--
-- TOC entry 202 (class 1259 OID 16832)
-- Name: quantities_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quantities_t (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(128) NOT NULL,
    unit character(4) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.quantities_t OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16830)
-- Name: quantities_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quantities_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quantities_t_id_seq OWNER TO postgres;

--
-- TOC entry 2898 (class 0 OID 0)
-- Dependencies: 201
-- Name: quantities_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quantities_t_id_seq OWNED BY public.quantities_t.id;


--
-- TOC entry 197 (class 1259 OID 16604)
-- Name: users_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_t (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    sex character(1) NOT NULL,
    date_of_birth date NOT NULL,
    email character varying(64) NOT NULL,
    hash character(60) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.users_t OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16602)
-- Name: users_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_t_id_seq OWNER TO postgres;

--
-- TOC entry 2899 (class 0 OID 0)
-- Dependencies: 196
-- Name: users_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_t_id_seq OWNED BY public.users_t.id;


--
-- TOC entry 198 (class 1259 OID 16618)
-- Name: users_v; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.users_v AS
 SELECT users_t.id,
    users_t.name,
    users_t.sex,
    users_t.date_of_birth,
    users_t.email
   FROM public.users_t;


ALTER TABLE public.users_v OWNER TO postgres;

--
-- TOC entry 2721 (class 2604 OID 16917)
-- Name: foods_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t ALTER COLUMN id SET DEFAULT nextval('public.foods_t_id_seq'::regclass);


--
-- TOC entry 2717 (class 2604 OID 16627)
-- Name: foodstuffs_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t ALTER COLUMN id SET DEFAULT nextval('public.foodstuff_t_id_seq'::regclass);


--
-- TOC entry 2720 (class 2604 OID 16902)
-- Name: meals_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t ALTER COLUMN id SET DEFAULT nextval('public.meals_t_id_seq'::regclass);


--
-- TOC entry 2722 (class 2604 OID 16951)
-- Name: measurements_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t ALTER COLUMN id SET DEFAULT nextval('public.measurements_t_id_seq'::regclass);


--
-- TOC entry 2718 (class 2604 OID 16835)
-- Name: quantities_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t ALTER COLUMN id SET DEFAULT nextval('public.quantities_t_id_seq'::regclass);


--
-- TOC entry 2714 (class 2604 OID 16607)
-- Name: users_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t ALTER COLUMN id SET DEFAULT nextval('public.users_t_id_seq'::regclass);


--
-- TOC entry 2885 (class 0 OID 16914)
-- Dependencies: 206
-- Data for Name: foods_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foods_t (id, foodstuff_id, meal_id, quantity, unit, name, calories, carbs, proteins, fats) FROM stdin;
\.


--
-- TOC entry 2879 (class 0 OID 16624)
-- Dependencies: 200
-- Data for Name: foodstuffs_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foodstuffs_t (id, unit, name, calories, carbs, proteins, fats) FROM stdin;
\.


--
-- TOC entry 2883 (class 0 OID 16899)
-- Dependencies: 204
-- Data for Name: meals_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meals_t (id, type, user_id, date) FROM stdin;
\.


--
-- TOC entry 2887 (class 0 OID 16948)
-- Dependencies: 208
-- Data for Name: measurements_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.measurements_t (id, quantity_id, value, date) FROM stdin;
\.


--
-- TOC entry 2881 (class 0 OID 16832)
-- Dependencies: 202
-- Data for Name: quantities_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quantities_t (id, user_id, name, unit, type) FROM stdin;
\.


--
-- TOC entry 2877 (class 0 OID 16604)
-- Dependencies: 197
-- Data for Name: users_t; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_t (id, name, sex, date_of_birth, email, hash, type) FROM stdin;
\.


--
-- TOC entry 2900 (class 0 OID 0)
-- Dependencies: 205
-- Name: foods_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foods_t_id_seq', 1, true);


--
-- TOC entry 2901 (class 0 OID 0)
-- Dependencies: 199
-- Name: foodstuff_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foodstuff_t_id_seq', 1, true);


--
-- TOC entry 2902 (class 0 OID 0)
-- Dependencies: 203
-- Name: meals_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meals_t_id_seq', 1, true);


--
-- TOC entry 2903 (class 0 OID 0)
-- Dependencies: 207
-- Name: measurements_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.measurements_t_id_seq', 1, true);


--
-- TOC entry 2904 (class 0 OID 0)
-- Dependencies: 201
-- Name: quantities_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quantities_t_id_seq', 1, true);


--
-- TOC entry 2905 (class 0 OID 0)
-- Dependencies: 196
-- Name: users_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_t_id_seq', 1, true);


--
-- TOC entry 2741 (class 2606 OID 16921)
-- Name: foods_t foods_t_foodstuff_id_meal_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_meal_id_key UNIQUE (foodstuff_id, meal_id);


--
-- TOC entry 2743 (class 2606 OID 16919)
-- Name: foods_t foods_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2729 (class 2606 OID 16629)
-- Name: foodstuffs_t foodstuff_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2731 (class 2606 OID 16631)
-- Name: foodstuffs_t foodstuff_t_unit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_unit_name_key UNIQUE (unit, name);


--
-- TOC entry 2737 (class 2606 OID 16904)
-- Name: meals_t meals_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2739 (class 2606 OID 16906)
-- Name: meals_t meals_t_type_user_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_type_user_id_date_key UNIQUE (type, user_id, date);


--
-- TOC entry 2745 (class 2606 OID 16953)
-- Name: measurements_t measurements_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2747 (class 2606 OID 16962)
-- Name: measurements_t measurements_t_quantity_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_date_key UNIQUE (quantity_id, date);


--
-- TOC entry 2733 (class 2606 OID 16838)
-- Name: quantities_t quantities_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2735 (class 2606 OID 16840)
-- Name: quantities_t quantities_t_user_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_name_key UNIQUE (user_id, name);


--
-- TOC entry 2725 (class 2606 OID 16612)
-- Name: users_t users_t_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_email_key UNIQUE (email);


--
-- TOC entry 2727 (class 2606 OID 16610)
-- Name: users_t users_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2716 (class 2606 OID 16680)
-- Name: users_t users_t_sex_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.users_t
    ADD CONSTRAINT users_t_sex_check CHECK ((sex = ANY (ARRAY['f'::bpchar, 'm'::bpchar]))) NOT VALID;


--
-- TOC entry 2753 (class 2620 OID 16865)
-- Name: users_t add_quantities_tr; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_quantities_tr AFTER INSERT ON public.users_t FOR EACH ROW EXECUTE PROCEDURE public.add_default_quantities_f();


--
-- TOC entry 2750 (class 2606 OID 16922)
-- Name: foods_t foods_t_foodstuff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_fkey FOREIGN KEY (foodstuff_id) REFERENCES public.foodstuffs_t(id) ON UPDATE CASCADE;


--
-- TOC entry 2751 (class 2606 OID 16927)
-- Name: foods_t foods_t_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2749 (class 2606 OID 16907)
-- Name: meals_t meals_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2752 (class 2606 OID 16956)
-- Name: measurements_t measurements_t_quantity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_fkey FOREIGN KEY (quantity_id) REFERENCES public.quantities_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2748 (class 2606 OID 16841)
-- Name: quantities_t quantities_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2018-03-28 19:23:59

--
-- PostgreSQL database dump complete
--

