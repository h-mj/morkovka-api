--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-03-23 17:55:45

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
-- TOC entry 217 (class 1255 OID 16754)
-- Name: add_food_f(integer, integer, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) RETURNS TABLE(foodstuff_id integer, meal_id integer, quantity real, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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
	ON CONSTRAINT foods_t_pkey
	DO UPDATE
	SET
		quantity = quantity_a,
		calories = calories_v,
		carbs = carbs_v,
		proteins = proteins_v,
		fats = fats_v
	RETURNING
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
-- TOC entry 212 (class 1255 OID 16632)
-- Name: add_foodstuff_f(character, character varying, real, real, real, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_foodstuff_f(unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO foodstuffs_t VALUES (DEFAULT, unit_a, name_a, calories_a, carbs_a, proteins_a, fats_a);
END;
$$;


ALTER FUNCTION public.add_foodstuff_f(unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 16756)
-- Name: add_meal_f(character varying, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_meal_f(name_a character varying, user_id_a integer, date_a date) RETURNS TABLE(id integer, name character varying, foods json)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
BEGIN
	RETURN QUERY INSERT INTO meals_t VALUES (DEFAULT, name_a, user_id_a, date_a) RETURNING id, name, '[]'::json;
END;
$$;


ALTER FUNCTION public.add_meal_f(name_a character varying, user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 16720)
-- Name: add_user_f(character varying, character, date, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, email_a character varying, hash_a character) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, email character varying, type smallint)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
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
-- TOC entry 220 (class 1255 OID 16758)
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
-- TOC entry 208 (class 1255 OID 16682)
-- Name: get_meal_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_meal_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, name character varying, foods json)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT
		meals_t.id, meals_t.name, COALESCE(json_agg(foods_t) FILTER (WHERE foods_t.meal_id IS NOT NULL), '[]') AS foods 
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


ALTER FUNCTION public.get_meal_f(user_id_a integer, date_a date) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 203 (class 1259 OID 16737)
-- Name: foods_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods_t (
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
-- TOC entry 2846 (class 0 OID 0)
-- Dependencies: 199
-- Name: foodstuff_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foodstuff_t_id_seq OWNED BY public.foodstuffs_t.id;


--
-- TOC entry 202 (class 1259 OID 16651)
-- Name: meals_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meals_t (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.meals_t OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16649)
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
-- TOC entry 2847 (class 0 OID 0)
-- Dependencies: 201
-- Name: meals_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_t_id_seq OWNED BY public.meals_t.id;


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
-- TOC entry 2848 (class 0 OID 0)
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
-- TOC entry 2699 (class 2604 OID 16627)
-- Name: foodstuffs_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t ALTER COLUMN id SET DEFAULT nextval('public.foodstuff_t_id_seq'::regclass);


--
-- TOC entry 2700 (class 2604 OID 16654)
-- Name: meals_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t ALTER COLUMN id SET DEFAULT nextval('public.meals_t_id_seq'::regclass);


--
-- TOC entry 2696 (class 2604 OID 16607)
-- Name: users_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t ALTER COLUMN id SET DEFAULT nextval('public.users_t_id_seq'::regclass);


--
-- TOC entry 2714 (class 2606 OID 16741)
-- Name: foods_t foods_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_pkey PRIMARY KEY (foodstuff_id, meal_id);


--
-- TOC entry 2706 (class 2606 OID 16629)
-- Name: foodstuffs_t foodstuff_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2708 (class 2606 OID 16631)
-- Name: foodstuffs_t foodstuff_t_unit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_unit_name_key UNIQUE (unit, name);


--
-- TOC entry 2710 (class 2606 OID 16658)
-- Name: meals_t meals_t_name_user_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_name_user_id_date_key UNIQUE (name, user_id, date);


--
-- TOC entry 2712 (class 2606 OID 16656)
-- Name: meals_t meals_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2702 (class 2606 OID 16612)
-- Name: users_t users_t_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_email_key UNIQUE (email);


--
-- TOC entry 2704 (class 2606 OID 16610)
-- Name: users_t users_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2698 (class 2606 OID 16680)
-- Name: users_t users_t_sex_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.users_t
    ADD CONSTRAINT users_t_sex_check CHECK ((sex = ANY (ARRAY['f'::bpchar, 'm'::bpchar]))) NOT VALID;


--
-- TOC entry 2716 (class 2606 OID 16742)
-- Name: foods_t foods_t_foodstuff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_fkey FOREIGN KEY (foodstuff_id) REFERENCES public.foodstuffs_t(id) ON UPDATE CASCADE;


--
-- TOC entry 2717 (class 2606 OID 16747)
-- Name: foods_t foods_t_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2715 (class 2606 OID 16659)
-- Name: meals_t meals_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2018-03-23 17:55:45

--
-- PostgreSQL database dump complete
--

