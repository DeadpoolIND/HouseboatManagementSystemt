--
-- PostgreSQL database dump
--

\restrict JpZASOsEg2LB7MLb2ZpL5a7UDAaabT9NTwuhVovZVZCl3zOTXzZPjTLFsyTfRvn

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: payment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status_enum AS ENUM (
    'pending',
    'paid',
    'cancelled',
    'refunded',
    'failed'
);


ALTER TYPE public.payment_status_enum OWNER TO postgres;

--
-- Name: payment_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_type_enum AS ENUM (
    'cash',
    'card',
    'online',
    'bank_transfer',
    'other'
);


ALTER TYPE public.payment_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: boats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boats (
    boat_id integer NOT NULL,
    boat_number text,
    boat_capacity integer,
    owner_id integer,
    service_id integer
);


ALTER TABLE public.boats OWNER TO postgres;

--
-- Name: boats_boat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boats_boat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.boats_boat_id_seq OWNER TO postgres;

--
-- Name: boats_boat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boats_boat_id_seq OWNED BY public.boats.boat_id;


--
-- Name: booking_boats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_boats (
    booking_id bigint NOT NULL,
    boat_id bigint NOT NULL
);


ALTER TABLE public.booking_boats OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id integer NOT NULL,
    client_id integer,
    boat_id integer,
    route_id integer,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone,
    payment_type text,
    payment_status text,
    payment_amount numeric(12,2),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_booking_id_seq OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_booking_id_seq OWNED BY public.bookings.booking_id;


--
-- Name: client_phone_numbers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_phone_numbers (
    client_phone_id integer NOT NULL,
    client_id integer NOT NULL,
    phone_number text NOT NULL
);


ALTER TABLE public.client_phone_numbers OWNER TO postgres;

--
-- Name: client_phone_numbers_client_phone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_phone_numbers_client_phone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_phone_numbers_client_phone_id_seq OWNER TO postgres;

--
-- Name: client_phone_numbers_client_phone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_phone_numbers_client_phone_id_seq OWNED BY public.client_phone_numbers.client_phone_id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    client_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text,
    client_city text,
    client_country text,
    date_of_birth date
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: clients_client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_client_id_seq OWNER TO postgres;

--
-- Name: clients_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_client_id_seq OWNED BY public.clients.client_id;


--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    owner_id integer NOT NULL,
    owner_name text NOT NULL,
    date_of_birth date,
    license_no text
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: owners_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.owners_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.owners_owner_id_seq OWNER TO postgres;

--
-- Name: owners_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.owners_owner_id_seq OWNED BY public.owners.owner_id;


--
-- Name: route_spots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.route_spots (
    route_spot_id integer NOT NULL,
    route_id integer NOT NULL,
    spot_name text NOT NULL,
    spot_order integer
);


ALTER TABLE public.route_spots OWNER TO postgres;

--
-- Name: route_spots_route_spot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.route_spots_route_spot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.route_spots_route_spot_id_seq OWNER TO postgres;

--
-- Name: route_spots_route_spot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.route_spots_route_spot_id_seq OWNED BY public.route_spots.route_spot_id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    route_id integer NOT NULL,
    source text NOT NULL,
    destination text NOT NULL
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- Name: routes_route_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.routes_route_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.routes_route_id_seq OWNER TO postgres;

--
-- Name: routes_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.routes_route_id_seq OWNED BY public.routes.route_id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id integer NOT NULL,
    service_type text NOT NULL,
    wifi_bandwidth text,
    cuisine text,
    has_bar boolean DEFAULT false,
    rate numeric(12,2)
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_service_id_seq OWNER TO postgres;

--
-- Name: services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_service_id_seq OWNED BY public.services.service_id;


--
-- Name: boats boat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats ALTER COLUMN boat_id SET DEFAULT nextval('public.boats_boat_id_seq'::regclass);


--
-- Name: bookings booking_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN booking_id SET DEFAULT nextval('public.bookings_booking_id_seq'::regclass);


--
-- Name: client_phone_numbers client_phone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_phone_numbers ALTER COLUMN client_phone_id SET DEFAULT nextval('public.client_phone_numbers_client_phone_id_seq'::regclass);


--
-- Name: clients client_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN client_id SET DEFAULT nextval('public.clients_client_id_seq'::regclass);


--
-- Name: owners owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners ALTER COLUMN owner_id SET DEFAULT nextval('public.owners_owner_id_seq'::regclass);


--
-- Name: route_spots route_spot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_spots ALTER COLUMN route_spot_id SET DEFAULT nextval('public.route_spots_route_spot_id_seq'::regclass);


--
-- Name: routes route_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes ALTER COLUMN route_id SET DEFAULT nextval('public.routes_route_id_seq'::regclass);


--
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.services_service_id_seq'::regclass);


--
-- Data for Name: boats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boats (boat_id, boat_number, boat_capacity, owner_id, service_id) FROM stdin;
1	HB-001	12	1	1
2	HB-002	8	2	2
3	HB-LUX-01	20	1	3
\.


--
-- Data for Name: booking_boats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_boats (booking_id, boat_id) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
11	1
12	2
13	3
14	4
15	5
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, client_id, boat_id, route_id, from_date, to_date, payment_type, payment_status, payment_amount, created_at) FROM stdin;
1	1	1	1	2025-11-20 09:00:00+05:30	2025-11-20 18:00:00+05:30	online	paid	15000.00	2025-11-17 00:09:19.797856+05:30
2	2	2	2	2025-11-22 08:00:00+05:30	2025-11-22 12:00:00+05:30	card	pending	4000.00	2025-11-17 00:09:19.797856+05:30
3	3	3	3	2025-12-01 07:00:00+05:30	2025-12-01 17:00:00+05:30	bank_transfer	pending	30000.00	2025-11-17 00:09:19.797856+05:30
4	4	3	2	2025-11-20 18:00:00+05:30	2025-11-24 18:00:00+05:30	online	paid	15000.00	2025-11-17 00:31:20.346463+05:30
\.


--
-- Data for Name: client_phone_numbers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_phone_numbers (client_phone_id, client_id, phone_number) FROM stdin;
1	1	+91-9847012345
2	2	+91-9847098765
3	3	+91-9847080000
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (client_id, first_name, last_name, client_city, client_country, date_of_birth) FROM stdin;
1	Rohit	Menon	Alappuzha	India	1996-07-21
2	Neha	Roy	Kochi	India	1994-03-11
3	Arjun	Das	Kumarakom	India	1990-01-05
4	Aadidev	CB	Thrissur	India	2006-06-03
\.


--
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.owners (owner_id, owner_name, date_of_birth, license_no) FROM stdin;
1	Ajay Kumar	1980-05-10	LIC-001
2	Sangeetha N	1978-11-02	LIC-002
\.


--
-- Data for Name: route_spots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.route_spots (route_spot_id, route_id, spot_name, spot_order) FROM stdin;
1	1	Backwaters	0
2	1	Island	1
3	2	Old Harbour	0
4	2	Lighthouse	1
5	3	Bird Sanctuary	0
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.routes (route_id, source, destination) FROM stdin;
1	Alappuzha	Kottayam
2	Kochi	Alleppey
3	Kumarakom	Vembanad
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, service_type, wifi_bandwidth, cuisine, has_bar, rate) FROM stdin;
1	Private Charter	50 Mbps	Kerala cuisine	t	15000.00
2	Shared Tour	10 Mbps	Simple meals	f	4000.00
3	Luxury Package	100 Mbps	Multi-cuisine	t	30000.00
\.


--
-- Name: boats_boat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boats_boat_id_seq', 3, true);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 4, true);


--
-- Name: client_phone_numbers_client_phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_phone_numbers_client_phone_id_seq', 3, true);


--
-- Name: clients_client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_client_id_seq', 4, true);


--
-- Name: owners_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.owners_owner_id_seq', 2, true);


--
-- Name: route_spots_route_spot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.route_spots_route_spot_id_seq', 5, true);


--
-- Name: routes_route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.routes_route_id_seq', 3, true);


--
-- Name: services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_service_id_seq', 3, true);


--
-- Name: boats boats_boat_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_boat_number_key UNIQUE (boat_number);


--
-- Name: boats boats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_pkey PRIMARY KEY (boat_id);


--
-- Name: booking_boats booking_boats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_boats
    ADD CONSTRAINT booking_boats_pkey PRIMARY KEY (booking_id, boat_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: client_phone_numbers client_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_phone_numbers
    ADD CONSTRAINT client_phone_numbers_pkey PRIMARY KEY (client_phone_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);


--
-- Name: owners owners_license_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_license_no_key UNIQUE (license_no);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (owner_id);


--
-- Name: route_spots route_spots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_spots
    ADD CONSTRAINT route_spots_pkey PRIMARY KEY (route_spot_id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (route_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- Name: client_phone_numbers uq_client_phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_phone_numbers
    ADD CONSTRAINT uq_client_phone UNIQUE (client_id, phone_number);


--
-- Name: idx_boats_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_owner ON public.boats USING btree (owner_id);


--
-- Name: idx_boats_service; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_service ON public.boats USING btree (service_id);


--
-- Name: idx_bookings_boat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_boat ON public.bookings USING btree (boat_id);


--
-- Name: idx_bookings_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_client ON public.bookings USING btree (client_id);


--
-- Name: idx_routes_source_dest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_routes_source_dest ON public.routes USING btree (source, destination);


--
-- Name: boats boats_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(owner_id) ON DELETE SET NULL;


--
-- Name: boats boats_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(boat_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(route_id) ON DELETE SET NULL;


--
-- Name: client_phone_numbers client_phone_numbers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_phone_numbers
    ADD CONSTRAINT client_phone_numbers_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON DELETE CASCADE;


--
-- Name: route_spots route_spots_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.route_spots
    ADD CONSTRAINT route_spots_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.routes(route_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict JpZASOsEg2LB7MLb2ZpL5a7UDAaabT9NTwuhVovZVZCl3zOTXzZPjTLFsyTfRvn

