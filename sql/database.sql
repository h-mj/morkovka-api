--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-03-21 13:10:28

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
-- TOC entry 213 (class 1255 OID 16524)
-- Name: create_foodstuff(character varying, character, real, real, real, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_foodstuff(character varying, character, real, real, real, real) RETURNS void
    LANGUAGE plpgsql
    AS $_$begin
	insert into foodstuffs (name, unit, calories, carbs, proteins, fats) values ($1, $2, $3, $4, $5);
end;$_$;


ALTER FUNCTION public.create_foodstuff(character varying, character, real, real, real, real) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 16522)
-- Name: create_user(character varying, character, date, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(character varying, character, date, character varying, character) RETURNS void
    LANGUAGE plpgsql
    AS $_$begin
	insert into users (name, sex, date_of_birth, email, hash) values ($1, $2, $3, $4, $5);
end;$_$;


ALTER FUNCTION public.create_user(character varying, character, date, character varying, character) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 202 (class 1259 OID 16507)
-- Name: foods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods (
    meal_id integer NOT NULL,
    foodstuff_id integer NOT NULL,
    quantity integer NOT NULL,
    unit character(1) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real NOT NULL
);


ALTER TABLE public.foods OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16499)
-- Name: foodstuffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foodstuffs (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    unit character(1) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real
);


ALTER TABLE public.foodstuffs OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16497)
-- Name: foodstuffs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foodstuffs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foodstuffs_id_seq OWNER TO postgres;

--
-- TOC entry 2839 (class 0 OID 0)
-- Dependencies: 200
-- Name: foodstuffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foodstuffs_id_seq OWNED BY public.foodstuffs.id;


--
-- TOC entry 199 (class 1259 OID 16484)
-- Name: meals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meals (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    date date NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.meals OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 16482)
-- Name: meals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.meals_id_seq OWNER TO postgres;

--
-- TOC entry 2840 (class 0 OID 0)
-- Dependencies: 198
-- Name: meals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_id_seq OWNED BY public.meals.id;


--
-- TOC entry 197 (class 1259 OID 16475)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    sex character(1) NOT NULL,
    date_of_birth date NOT NULL,
    email character varying(64) NOT NULL,
    hash character(60) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16473)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 2841 (class 0 OID 0)
-- Dependencies: 196
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public.users.id;


--
-- TOC entry 203 (class 1259 OID 16529)
-- Name: v_user; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_user AS
 SELECT users.id,
    users.name,
    users.sex,
    users.date_of_birth,
    users.email,
    users.type
   FROM public.users;


ALTER TABLE public.v_user OWNER TO postgres;

--
-- TOC entry 2695 (class 2604 OID 16502)
-- Name: foodstuffs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs ALTER COLUMN id SET DEFAULT nextval('public.foodstuffs_id_seq'::regclass);


--
-- TOC entry 2694 (class 2604 OID 16487)
-- Name: meals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals ALTER COLUMN id SET DEFAULT nextval('public.meals_id_seq'::regclass);


--
-- TOC entry 2692 (class 2604 OID 16478)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2707 (class 2606 OID 16511)
-- Name: foods foods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (meal_id, foodstuff_id);


--
-- TOC entry 2703 (class 2606 OID 16506)
-- Name: foodstuffs foodstuffs_name_unit_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs
    ADD CONSTRAINT foodstuffs_name_unit_key UNIQUE (name, unit);


--
-- TOC entry 2705 (class 2606 OID 16504)
-- Name: foodstuffs foodstuffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs
    ADD CONSTRAINT foodstuffs_pkey PRIMARY KEY (id);


--
-- TOC entry 2699 (class 2606 OID 16491)
-- Name: meals meals_name_date_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_name_date_user_id_key UNIQUE (name, date, user_id);


--
-- TOC entry 2701 (class 2606 OID 16489)
-- Name: meals meals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_pkey PRIMARY KEY (id);


--
-- TOC entry 2697 (class 2606 OID 16480)
-- Name: users user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2710 (class 2606 OID 16517)
-- Name: foods foods_foodstuff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_foodstuff_id_fkey FOREIGN KEY (foodstuff_id) REFERENCES public.foodstuffs(id) ON UPDATE CASCADE;


--
-- TOC entry 2709 (class 2606 OID 16512)
-- Name: foods foods_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2708 (class 2606 OID 16492)
-- Name: meals meals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2018-03-21 13:10:28

--
-- PostgreSQL database dump complete
--

