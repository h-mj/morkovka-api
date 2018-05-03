--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-05-03 16:21:24

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
-- TOC entry 1 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2947 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 25838)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2948 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 243 (class 1255 OID 25681)
-- Name: add_food_f(integer, integer, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) RETURNS TABLE(id integer, meal_id integer, foodstuff_id integer, quantity real, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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
    meal_id_a,
		foodstuff_id_a,
		quantity_a)
	ON CONFLICT
	ON CONSTRAINT foods_t_meal_id_foodstuff_id_key
	DO UPDATE
	SET
		quantity = quantity_a
	RETURNING
		id,
    meal_id,
		foodstuff_id,
		quantity,
		unit_v,
		name_v,
		calories_v,
		carbs_v,
		proteins_v,
		fats_v;
END;

$$;


ALTER FUNCTION public.add_food_f(foodstuff_id_a integer, meal_id_a integer, quantity_a real) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 25682)
-- Name: add_foodstuff_f(real, character, character varying, real, real, real, real, real, real, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real, sugars_a real, salt_a real, saturates_a real) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
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
											ROUND((fats_a / quantity_a)::numeric, 3),
                      ROUND((sugars_a / quantity_a)::numeric, 3),
                      ROUND((salt_a / quantity_a)::numeric, 3),
                      ROUND((saturates_a / quantity_a)::numeric, 3))
	RETURNING id, unit, name, calories, carbs, proteins, fats;
END;

$$;


ALTER FUNCTION public.add_foodstuff_f(quantity_a real, unit_a character, name_a character varying, calories_a real, carbs_a real, proteins_a real, fats_a real, sugars_a real, salt_a real, saturates_a real) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 25683)
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
-- TOC entry 213 (class 1255 OID 25684)
-- Name: add_measurement_f(integer, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_measurement_f(quantity_id_a integer, value_a real) RETURNS TABLE(id integer, quantity_id integer, value real, date date)
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


ALTER FUNCTION public.add_measurement_f(quantity_id_a integer, value_a real) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 25685)
-- Name: add_quantity_f(integer, character varying, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character) RETURNS TABLE(id integer, name character varying, unit character, type smallint, measurements json)
    LANGUAGE plpgsql
    AS $$

#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO quantities_t VALUES (DEFAULT, user_id_a, name_a, unit_a, DEFAULT) RETURNING id, name, unit, type, '[]'::json;
END;

$$;


ALTER FUNCTION public.add_quantity_f(user_id_a integer, name_a character varying, unit_a character) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 25686)
-- Name: add_ratio_f(integer, smallint, smallint, smallint, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_ratio_f(user_id_a integer, delta_a smallint, carbs_a smallint, proteins_a smallint, fats_a smallint) RETURNS TABLE(delta smallint, carbs smallint, proteins smallint, fats smallint)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	INSERT INTO
		ratios_t
	VALUES
		(DEFAULT, user_id_a, DEFAULT, delta_a, carbs_a, proteins_a, fats_a)
	ON CONFLICT
	ON CONSTRAINT ratios_t_user_id_date_key
	DO UPDATE
	SET
		delta = delta_a,
		carbs = carbs_a,
		proteins = proteins_a,
		fats = fats_a
	RETURNING delta, carbs, proteins, fats;
END;

$$;


ALTER FUNCTION public.add_ratio_f(user_id_a integer, delta_a smallint, carbs_a smallint, proteins_a smallint, fats_a smallint) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 25892)
-- Name: add_user_f(character varying, character, date, character, character varying, character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, language_a character, email_a character varying, hash_a character, code_a character) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, language character, email character varying, type smallint, trainer_id integer)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
declare
  trainer_id_v integer;
begin
  select
    registration_codes_t.user_id into trainer_id_v
  from
    registration_codes_t
  where
    registration_codes_t.code = code_a and
    registration_codes_t.used = false and
    extract(day from current_timestamp - registration_codes_t.timestamp) <= 2;

  if trainer_id_v is null then
    return;
  end if;
  
  update
    registration_codes_t
  set
    used = true
  where
    registration_codes_t.code = code_a;

	return query
	insert into
		users_t
	values
		(default, name_a, sex_a, date_of_birth_a, language_a, email_a, hash_a, default, trainer_id_v)
	returning
		id, name, sex, date_of_birth, language, email, type, trainer_id;
END;

$$;


ALTER FUNCTION public.add_user_f(name_a character varying, sex_a character, date_of_birth_a date, language_a character, email_a character varying, hash_a character, code_a character) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 25688)
-- Name: after_users_t_insert_f(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.after_users_t_insert_f() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO quantities_t VALUES
		(DEFAULT, NEW.id, '__MASS__', 'kg', 1),
		(DEFAULT, NEW.id, '__HEIGHT__', 'cm', 2),
		(DEFAULT, NEW.id, '__ACTIVENESS__', 'unit', 3),
		(DEFAULT, NEW.id, '__CHEST_PERIMETER__', 'cm', 4),
		(DEFAULT, NEW.id, '__WAIST_PERIMETER__', 'cm', 5),
		(DEFAULT, NEW.id, '__THIGHS_PERIMETER__', 'cm', 6),
		(DEFAULT, NEW.id, '__THIGH_PERIMETER__', 'cm', 7),
		(DEFAULT, NEW.id, '__CALF_PERIMETER__', 'cm', 8),
		(DEFAULT, NEW.id, '__BICEPS_PERIMETER__', 'cm', 9),
		(DEFAULT, NEW.id, '__FOREARM_PERIMETER__', 'cm', 10),
		(DEFAULT, NEW.id, '__ANKLE_PERIMETER__', 'cm', 11);

	INSERT INTO ratios_t VALUES
		(DEFAULT, NEW.id, DEFAULT, 0, 50, 20, 30);

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.after_users_t_insert_f() OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 25689)
-- Name: find_foodstuffs_f(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_foodstuffs_f(query_a character varying) RETURNS TABLE(id integer, unit character, name character varying, calories real, carbs real, proteins real, fats real)
    LANGUAGE plpgsql
    AS $$BEGIN
	RETURN QUERY
	SELECT
		foodstuffs_t.id,
    foodstuffs_t.unit,
    foodstuffs_t.name,
    foodstuffs_t.calories,
    foodstuffs_t.carbs,
    foodstuffs_t.proteins,
    foodstuffs_t.fats
	FROM
		foodstuffs_t
	WHERE
		lower(foodstuffs_t.name) LIKE '%' || lower(query_a) || '%'
  ORDER BY
    LENGTH(foodstuffs_t.name) ASC
  LIMIT
    32;
END;
$$;


ALTER FUNCTION public.find_foodstuffs_f(query_a character varying) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 25880)
-- Name: generate_registration_code_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_registration_code_f(user_id_a integer) RETURNS TABLE(code character)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
declare
  code_v text;
begin
  loop
    code_v := encode(gen_random_bytes(12), 'base64');
    code_v := replace(code_v, '/', '_');
    code_v := replace(code_v, '+', '-');
    
    if not exists(select 1 from registration_codes_t where registration_codes_t.code = code_v limit 1) then
      exit;
    end if;
  end loop;
  
  return query insert into registration_codes_t values (code_v, default, user_id_a, false) returning code;
end;

$$;


ALTER FUNCTION public.generate_registration_code_f(user_id_a integer) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 25690)
-- Name: get_clients_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_clients_f(user_id_a integer) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, language character, email character varying, type smallint, ratios json, measurements json)
    LANGUAGE plpgsql
    AS $$
begin
return query
select
  users_t.id,
  users_t.name,
  users_t.sex,
  users_t.date_of_birth,
  users_t.language,
  users_t.email,
  users_t.type,
  (select row_to_json(d) from get_ratios_f(users_t.id, CURRENT_DATE) as d) as ratios,
  (select row_to_json(d) from get_crucial_measurements_f(users_t.id, CURRENT_DATE) as d) as measurements
from
  users_t
where
  users_t.trainer_id = user_id_a;
end;

$$;


ALTER FUNCTION public.get_clients_f(user_id_a integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 25691)
-- Name: get_consumption_stats_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_consumption_stats_f(user_id_a integer) RETURNS TABLE(date date, consumed json, ratios json, measurements json)
    LANGUAGE plpgsql
    AS $$begin
return query
select
  dates.date,
  (
    select row_to_json(d) from (
    select
      coalesce(sum(foodstuffs_t.calories * foods_t.quantity), 0) as calories,
      coalesce(sum(foodstuffs_t.carbs * foods_t.quantity), 0) as carbs,
      coalesce(sum(foodstuffs_t.proteins * foods_t.quantity), 0) as proteins,
      coalesce(sum(foodstuffs_t.fats * foods_t.quantity), 0) as fats
    from
      meals_t
    join
      foods_t
    on
      foods_t.meal_id = meals_t.id
    join
      foodstuffs_t
    on
      foodstuffs_t.id = foods_t.foodstuff_id
    where
      meals_t.date = dates.date and meals_t.user_id = user_id_a
  ) d) as consumed,
  (select row_to_json(d) from get_ratios_f(user_id_a, dates.date) d) as ratios,
  (select row_to_json(d) from get_crucial_measurements_f(user_id_a, dates.date) d) as measurements
from
  (
    select t::date as date from generate_series
	  (
      current_date - interval '28' day,
      current_date,
      '1 day'
    ) t
  ) dates;
end;
$$;


ALTER FUNCTION public.get_consumption_stats_f(user_id_a integer) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 25692)
-- Name: get_crucial_measurements_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_crucial_measurements_f(user_id_a integer, date_a date) RETURNS TABLE(mass real, height real, activeness real)
    LANGUAGE plpgsql
    AS $$

begin
return query
select
  *
from
(
select
  max(t.mass) as mass,
  max(t.height) as height,
  max(t.activeness) as activeness
from
(
  select distinct on (quantities_t.type)
    (select value where type = 1) as mass,
    (select value where type = 2) as height,
    (select value where type = 3) as activeness
  from
    quantities_t
  join
    measurements_t
  on
    measurements_t.quantity_id = quantities_t.id
  where
    measurements_t.date <= date_a and
    quantities_t.user_id = user_id_a and
    quantities_t.type >= 1 and quantities_t.type <= 3
  order by
    quantities_t.type, date DESC
) t
) d
where
  d is not null;
end;

$$;


ALTER FUNCTION public.get_crucial_measurements_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 25693)
-- Name: get_day_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_day_f(user_id_a integer, date_a date) RETURNS TABLE(date date, meals json, ratios json, measurements json)
    LANGUAGE plpgsql
    AS $$

begin
return query
  select
  date_a as date,
  coalesce((
    select
      array_to_json(array_agg(row_to_json(d)))
    from
      get_meals_f(user_id_a, date_a) as d
  ), '[]'::json) as meals,
  (select row_to_json(d) from get_ratios_f(user_id_a, date_a) as d) as ratios,
  (select row_to_json(d) from get_crucial_measurements_f(user_id_a, date_a) as d) as measurements;
end;

$$;


ALTER FUNCTION public.get_day_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 25694)
-- Name: get_meals_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_meals_f(user_id_a integer, date_a date) RETURNS TABLE(id integer, type smallint, foods json)
    LANGUAGE plpgsql
    AS $$begin
  return query
  select
    meals_t.id,
    meals_t.type,
    coalesce((
      select array_to_json(array_agg(d)) from (
        select
          foods_t.id as id,
          foods_t.quantity as quantity,
          foodstuffs_t.id as foodstuff_id,
          foodstuffs_t.unit as unit,
          foodstuffs_t.name as name,
          foodstuffs_t.calories * foods_t.quantity as calories,
          foodstuffs_t.carbs * foods_t.quantity as carbs,
          foodstuffs_t.proteins * foods_t.quantity as proteins,
          foodstuffs_t.fats * foods_t.quantity as fats
        from
          foods_t
        join
          foodstuffs_t
        on
          foods_t.foodstuff_id = foodstuffs_t.id
        where
          foods_t.meal_id = meals_t.id
      ) d
    ), '[]'::json) as foods
  from
    meals_t
  where
    meals_t.user_id = user_id_a and meals_t.date = date_a
  order by
    meals_t.type asc;
end;
$$;


ALTER FUNCTION public.get_meals_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 25695)
-- Name: get_quantities_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_quantities_f(user_id_a integer) RETURNS TABLE(id integer, name character varying, unit character, type smallint, measurements json)
    LANGUAGE plpgsql
    AS $$begin
  return query
  select
  quantities_t.id,
  quantities_t.name,
  quantities_t.unit,
  quantities_t.type,
  coalesce((
    select
      array_to_json(array_agg(row_to_json(d)))
    from
      (
        select
          measurements_t.id,
          measurements_t.value,
          measurements_t.date
        from
          measurements_t
        where
          measurements_t.quantity_id = quantities_t.id
        order by
          measurements_t.date asc
      ) as d
  ), '[]'::json) as measurements
from
  quantities_t
where
  quantities_t.user_id = user_id_a
order by
  quantities_t.id;
end;
$$;


ALTER FUNCTION public.get_quantities_f(user_id_a integer) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 25696)
-- Name: get_ratios_f(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ratios_f(user_id_a integer, date_a date) RETURNS TABLE(delta smallint, carbs smallint, proteins smallint, fats smallint)
    LANGUAGE plpgsql
    AS $$#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT
		delta,
    carbs,
    proteins,
    fats
	FROM
		ratios_t
	WHERE
    ratios_t.user_id = user_id_a and
		ratios_t.date <= date_a
	ORDER BY
		ratios_t.date DESC
	LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_ratios_f(user_id_a integer, date_a date) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 25697)
-- Name: get_user_f(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_f(user_id_a integer) RETURNS TABLE(id integer, name character varying, sex character, date_of_birth date, language character, email character varying, type smallint, ratios json, measurements json)
    LANGUAGE plpgsql
    AS $$
begin
return query
select
  users_t.id,
  users_t.name,
  users_t.sex,
  users_t.date_of_birth,
  users_t.language,
  users_t.email,
  users_t.type,
  (select row_to_json(d) from get_ratios_f(user_id_a, CURRENT_DATE) as d) as ratios,
  (select row_to_json(d) from get_crucial_measurements_f(user_id_a, CURRENT_DATE) as d) as measurements
from
  users_t
where
  users_t.id = user_id_a;
end;
$$;


ALTER FUNCTION public.get_user_f(user_id_a integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 197 (class 1259 OID 25698)
-- Name: foods_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods_t (
    id integer NOT NULL,
    meal_id integer NOT NULL,
    foodstuff_id integer NOT NULL,
    quantity real NOT NULL
);


ALTER TABLE public.foods_t OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 25701)
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
-- TOC entry 2949 (class 0 OID 0)
-- Dependencies: 198
-- Name: foods_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foods_t_id_seq OWNED BY public.foods_t.id;


--
-- TOC entry 199 (class 1259 OID 25703)
-- Name: foodstuffs_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foodstuffs_t (
    id integer NOT NULL,
    unit character(2) NOT NULL,
    name character varying(128) NOT NULL,
    calories real NOT NULL,
    carbs real NOT NULL,
    proteins real NOT NULL,
    fats real NOT NULL,
    sugars real,
    salt real,
    saturates real
);


ALTER TABLE public.foodstuffs_t OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 25706)
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
-- TOC entry 2950 (class 0 OID 0)
-- Dependencies: 200
-- Name: foodstuff_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foodstuff_t_id_seq OWNED BY public.foodstuffs_t.id;


--
-- TOC entry 201 (class 1259 OID 25708)
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
-- TOC entry 202 (class 1259 OID 25711)
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
-- TOC entry 2951 (class 0 OID 0)
-- Dependencies: 202
-- Name: meals_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_t_id_seq OWNED BY public.meals_t.id;


--
-- TOC entry 203 (class 1259 OID 25713)
-- Name: measurements_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.measurements_t (
    id integer NOT NULL,
    quantity_id integer NOT NULL,
    value real NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.measurements_t OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 25717)
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
-- TOC entry 2952 (class 0 OID 0)
-- Dependencies: 204
-- Name: measurements_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.measurements_t_id_seq OWNED BY public.measurements_t.id;


--
-- TOC entry 205 (class 1259 OID 25719)
-- Name: quantities_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quantities_t (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(128) NOT NULL,
    unit character(16) NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.quantities_t OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 25723)
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
-- TOC entry 2953 (class 0 OID 0)
-- Dependencies: 206
-- Name: quantities_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quantities_t_id_seq OWNED BY public.quantities_t.id;


--
-- TOC entry 207 (class 1259 OID 25725)
-- Name: ratios_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ratios_t (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    delta smallint NOT NULL,
    carbs smallint NOT NULL,
    proteins smallint NOT NULL,
    fats smallint NOT NULL,
    CONSTRAINT ratios_t_check CHECK (((carbs >= 0) AND (proteins >= 0) AND (fats >= 0) AND (((carbs + proteins) + fats) = 100)))
);


ALTER TABLE public.ratios_t OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25730)
-- Name: ratios_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ratios_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ratios_t_id_seq OWNER TO postgres;

--
-- TOC entry 2954 (class 0 OID 0)
-- Dependencies: 208
-- Name: ratios_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ratios_t_id_seq OWNED BY public.ratios_t.id;


--
-- TOC entry 209 (class 1259 OID 25732)
-- Name: registration_codes_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registration_codes_t (
    code character(16) NOT NULL,
    "timestamp" timestamp(4) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id integer NOT NULL,
    used boolean DEFAULT false NOT NULL
);


ALTER TABLE public.registration_codes_t OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 25736)
-- Name: users_t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_t (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    sex character(1) NOT NULL,
    date_of_birth date NOT NULL,
    language character(2) NOT NULL,
    email character varying(64) NOT NULL,
    hash character(60) NOT NULL,
    type smallint DEFAULT 0 NOT NULL,
    trainer_id integer
);


ALTER TABLE public.users_t OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 25740)
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
-- TOC entry 2955 (class 0 OID 0)
-- Dependencies: 211
-- Name: users_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_t_id_seq OWNED BY public.users_t.id;


--
-- TOC entry 2765 (class 2604 OID 25742)
-- Name: foods_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t ALTER COLUMN id SET DEFAULT nextval('public.foods_t_id_seq'::regclass);


--
-- TOC entry 2766 (class 2604 OID 25743)
-- Name: foodstuffs_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t ALTER COLUMN id SET DEFAULT nextval('public.foodstuff_t_id_seq'::regclass);


--
-- TOC entry 2767 (class 2604 OID 25744)
-- Name: meals_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t ALTER COLUMN id SET DEFAULT nextval('public.meals_t_id_seq'::regclass);


--
-- TOC entry 2769 (class 2604 OID 25745)
-- Name: measurements_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t ALTER COLUMN id SET DEFAULT nextval('public.measurements_t_id_seq'::regclass);


--
-- TOC entry 2771 (class 2604 OID 25746)
-- Name: quantities_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t ALTER COLUMN id SET DEFAULT nextval('public.quantities_t_id_seq'::regclass);


--
-- TOC entry 2773 (class 2604 OID 25747)
-- Name: ratios_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratios_t ALTER COLUMN id SET DEFAULT nextval('public.ratios_t_id_seq'::regclass);


--
-- TOC entry 2778 (class 2604 OID 25748)
-- Name: users_t id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t ALTER COLUMN id SET DEFAULT nextval('public.users_t_id_seq'::regclass);


--
-- TOC entry 2781 (class 2606 OID 25750)
-- Name: foods_t foods_t_meal_id_foodstuff_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_meal_id_foodstuff_id_key UNIQUE (meal_id, foodstuff_id);


--
-- TOC entry 2783 (class 2606 OID 25752)
-- Name: foods_t foods_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2785 (class 2606 OID 25754)
-- Name: foodstuffs_t foodstuff_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2787 (class 2606 OID 25756)
-- Name: foodstuffs_t foodstuff_t_unit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foodstuffs_t
    ADD CONSTRAINT foodstuff_t_unit_name_key UNIQUE (unit, name);


--
-- TOC entry 2789 (class 2606 OID 25758)
-- Name: meals_t meals_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2791 (class 2606 OID 25760)
-- Name: meals_t meals_t_type_user_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_type_user_id_date_key UNIQUE (type, user_id, date);


--
-- TOC entry 2793 (class 2606 OID 25762)
-- Name: measurements_t measurements_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2795 (class 2606 OID 25764)
-- Name: measurements_t measurements_t_quantity_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_date_key UNIQUE (quantity_id, date);


--
-- TOC entry 2797 (class 2606 OID 25766)
-- Name: quantities_t quantities_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2799 (class 2606 OID 25768)
-- Name: quantities_t quantities_t_user_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_name_key UNIQUE (user_id, name);


--
-- TOC entry 2801 (class 2606 OID 25770)
-- Name: ratios_t ratios_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratios_t
    ADD CONSTRAINT ratios_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2803 (class 2606 OID 25772)
-- Name: ratios_t ratios_t_user_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratios_t
    ADD CONSTRAINT ratios_t_user_id_date_key UNIQUE (user_id, date);


--
-- TOC entry 2805 (class 2606 OID 25887)
-- Name: registration_codes_t registration_codes_f_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_codes_t
    ADD CONSTRAINT registration_codes_f_pkey PRIMARY KEY (code);


--
-- TOC entry 2807 (class 2606 OID 25776)
-- Name: users_t users_t_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_email_key UNIQUE (email);


--
-- TOC entry 2809 (class 2606 OID 25778)
-- Name: users_t users_t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_pkey PRIMARY KEY (id);


--
-- TOC entry 2779 (class 2606 OID 25779)
-- Name: users_t users_t_sex_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.users_t
    ADD CONSTRAINT users_t_sex_check CHECK ((sex = ANY (ARRAY['f'::bpchar, 'm'::bpchar]))) NOT VALID;


--
-- TOC entry 2818 (class 2620 OID 25780)
-- Name: users_t add_quantities_tr; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_quantities_tr AFTER INSERT ON public.users_t FOR EACH ROW EXECUTE PROCEDURE public.after_users_t_insert_f();


--
-- TOC entry 2810 (class 2606 OID 25781)
-- Name: foods_t foods_t_foodstuff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_foodstuff_id_fkey FOREIGN KEY (foodstuff_id) REFERENCES public.foodstuffs_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2811 (class 2606 OID 25786)
-- Name: foods_t foods_t_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods_t
    ADD CONSTRAINT foods_t_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2812 (class 2606 OID 25791)
-- Name: meals_t meals_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals_t
    ADD CONSTRAINT meals_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2813 (class 2606 OID 25796)
-- Name: measurements_t measurements_t_quantity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurements_t
    ADD CONSTRAINT measurements_t_quantity_id_fkey FOREIGN KEY (quantity_id) REFERENCES public.quantities_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2814 (class 2606 OID 25801)
-- Name: quantities_t quantities_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantities_t
    ADD CONSTRAINT quantities_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2815 (class 2606 OID 25806)
-- Name: ratios_t ratios_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratios_t
    ADD CONSTRAINT ratios_t_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2816 (class 2606 OID 25811)
-- Name: registration_codes_t registration_codes_f_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_codes_t
    ADD CONSTRAINT registration_codes_f_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_t(id) ON UPDATE CASCADE;


--
-- TOC entry 2817 (class 2606 OID 25816)
-- Name: users_t users_t_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_t
    ADD CONSTRAINT users_t_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users_t(id) ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2018-05-03 16:21:24

--
-- PostgreSQL database dump complete
--

