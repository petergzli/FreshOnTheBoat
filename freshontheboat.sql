--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: forum_post_flagged; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_post_flagged (
    user_who_flagged integer,
    forum_profile_flagged_id integer,
    id integer NOT NULL
);


ALTER TABLE forum_post_flagged OWNER TO "petergzliMacBookPro";

--
-- Name: forum_post_flagged_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_post_flagged_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_post_flagged_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_post_flagged_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_post_flagged_id_seq OWNED BY forum_post_flagged.id;


--
-- Name: forum_profile; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile (
    created_by integer,
    description text,
    category integer,
    title character varying(150),
    location character varying(150),
    latitude double precision,
    longitude double precision,
    created_at date,
    image_url character varying(150),
    forum_post_flagged integer,
    location_pin_latitude double precision,
    location_pin_longitude double precision,
    id integer NOT NULL,
    total_likes integer
);


ALTER TABLE forum_profile OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_id_seq OWNED BY forum_profile.id;


--
-- Name: forum_profile_likes; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_likes (
    forum_profile_id integer,
    user_who_liked integer,
    likes integer,
    dislikes integer,
    id integer NOT NULL
);


ALTER TABLE forum_profile_likes OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_likes_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_likes_id_seq OWNED BY forum_profile_likes.id;


--
-- Name: forum_profile_photo_album_photos; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_photo_album_photos (
    poster_id integer,
    forum_profile_id integer,
    image_url character varying(150),
    photo_flagged integer,
    id integer NOT NULL
);


ALTER TABLE forum_profile_photo_album_photos OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_photo_album_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_photo_album_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_photo_album_photos_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_photo_album_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_photo_album_photos_id_seq OWNED BY forum_profile_photo_album_photos.id;


--
-- Name: forum_profile_postings; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings (
    forum_id integer,
    poster_id integer,
    body text,
    created_at date,
    image_url character varying(150),
    comment_flagged integer,
    replied_to_forum_id integer,
    location_pin_latitude double precision,
    location_pin_longitude double precision,
    id integer NOT NULL
);


ALTER TABLE forum_profile_postings OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_flagged; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings_flagged (
    user_who_flagged integer,
    forum_profile_flagged_id integer,
    id integer NOT NULL
);


ALTER TABLE forum_profile_postings_flagged OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_flagged_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_postings_flagged_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_postings_flagged_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_flagged_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_postings_flagged_id_seq OWNED BY forum_profile_postings_flagged.id;


--
-- Name: forum_profile_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_postings_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_postings_id_seq OWNED BY forum_profile_postings.id;


--
-- Name: forum_profile_postings_likes; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings_likes (
    forum_profile_posting_id integer,
    user_who_liked integer,
    likes integer,
    dislikes integer,
    id integer NOT NULL
);


ALTER TABLE forum_profile_postings_likes OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE forum_profile_postings_likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_profile_postings_likes_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE forum_profile_postings_likes_id_seq OWNED BY forum_profile_postings_likes.id;


--
-- Name: user_checked_in; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE user_checked_in (
    user_who_checked_in_id integer,
    checked_into_forum_profile_id integer,
    time_checked_in date,
    id integer NOT NULL
);


ALTER TABLE user_checked_in OWNER TO "petergzliMacBookPro";

--
-- Name: user_checked_in_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE user_checked_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_checked_in_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: user_checked_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE user_checked_in_id_seq OWNED BY user_checked_in.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE users (
    username character varying(60),
    firstname character varying(60),
    lastname character varying(60),
    email character varying(100),
    encrypted_password character varying(200),
    reset_password_token character varying(100),
    authentication_token character varying(200),
    bio text,
    profile_photo character varying(100),
    main_city character varying(100),
    latitude double precision,
    longitude double precision,
    user_flagged boolean,
    device_id integer,
    id integer NOT NULL
);


ALTER TABLE users OWNER TO "petergzliMacBookPro";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: petergzliMacBookPro
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO "petergzliMacBookPro";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: petergzliMacBookPro
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_post_flagged ALTER COLUMN id SET DEFAULT nextval('forum_post_flagged_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile ALTER COLUMN id SET DEFAULT nextval('forum_profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile_likes ALTER COLUMN id SET DEFAULT nextval('forum_profile_likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile_photo_album_photos ALTER COLUMN id SET DEFAULT nextval('forum_profile_photo_album_photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile_postings ALTER COLUMN id SET DEFAULT nextval('forum_profile_postings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile_postings_flagged ALTER COLUMN id SET DEFAULT nextval('forum_profile_postings_flagged_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY forum_profile_postings_likes ALTER COLUMN id SET DEFAULT nextval('forum_profile_postings_likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY user_checked_in ALTER COLUMN id SET DEFAULT nextval('user_checked_in_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: petergzliMacBookPro
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: forum_post_flagged; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_post_flagged (user_who_flagged, forum_profile_flagged_id, id) FROM stdin;
\.


--
-- Name: forum_post_flagged_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_post_flagged_id_seq', 1, false);


--
-- Data for Name: forum_profile; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile (created_by, description, category, title, location, latitude, longitude, created_at, image_url, forum_post_flagged, location_pin_latitude, location_pin_longitude, id, total_likes) FROM stdin;
2	I love fried chicken guys... 	3	Where can I get some chicken around here?		34.0671239999999997	-118.444792000000007	2015-10-04		\N	34.0671239999999926	-118.444792000000007	1	2
\.


--
-- Name: forum_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_id_seq', 1, true);


--
-- Data for Name: forum_profile_likes; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_likes (forum_profile_id, user_who_liked, likes, dislikes, id) FROM stdin;
1	1	1	0	8
\.


--
-- Name: forum_profile_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_likes_id_seq', 8, true);


--
-- Data for Name: forum_profile_photo_album_photos; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_photo_album_photos (poster_id, forum_profile_id, image_url, photo_flagged, id) FROM stdin;
\.


--
-- Name: forum_profile_photo_album_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_photo_album_photos_id_seq', 1, false);


--
-- Data for Name: forum_profile_postings; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings (forum_id, poster_id, body, created_at, image_url, comment_flagged, replied_to_forum_id, location_pin_latitude, location_pin_longitude, id) FROM stdin;
1	1	What's going on new los angeles?	2015-10-04		\N	\N	\N	\N	1
1	1	check out roscoe's chicken and waffles. They're very good. 	2015-10-04		\N	\N	42.4291979999999711	-89.0165579999999892	2
1	1	How about that LA Guys?	2015-10-04		\N	\N	\N	\N	3
1	1	yoyoyo!!! what's up	2015-10-04		\N	\N	\N	\N	4
1	1	okay, now this good shit	2015-10-04		\N	4	\N	\N	5
1	1	okay, now this good shit	2015-10-04		\N	4	\N	\N	6
1	1	okay, now this good shit	2015-10-04		\N	4	\N	\N	7
1	1	Hey!	2015-10-04		\N	3	\N	\N	8
1	1	what the heck	2015-10-04		\N	3	\N	\N	9
1	1	cool	2015-10-04		\N	4	\N	\N	10
1	1	What's up YO!	2015-10-04		\N	3	34.0671239999999926	-118.444792000000007	11
\.


--
-- Data for Name: forum_profile_postings_flagged; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings_flagged (user_who_flagged, forum_profile_flagged_id, id) FROM stdin;
\.


--
-- Name: forum_profile_postings_flagged_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_postings_flagged_id_seq', 1, false);


--
-- Name: forum_profile_postings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_postings_id_seq', 11, true);


--
-- Data for Name: forum_profile_postings_likes; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings_likes (forum_profile_posting_id, user_who_liked, likes, dislikes, id) FROM stdin;
\.


--
-- Name: forum_profile_postings_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('forum_profile_postings_likes_id_seq', 1, false);


--
-- Data for Name: user_checked_in; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY user_checked_in (user_who_checked_in_id, checked_into_forum_profile_id, time_checked_in, id) FROM stdin;
\.


--
-- Name: user_checked_in_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('user_checked_in_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY users (username, firstname, lastname, email, encrypted_password, reset_password_token, authentication_token, bio, profile_photo, main_city, latitude, longitude, user_flagged, device_id, id) FROM stdin;
theBoneMan			bonehead@gmail.com	$6$rounds=713425$W5HJr46wSiFDuS4L$LKXfgUc9Yn1Q.yTsdlOzJJPMb2FQKsDmXDGitH2iMOuh.XHMonDT34G4ZbiORQQNvIxZFdDR82Lei277H.B0v/	\N	eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0Mzk4NzEyMiwiaWF0IjoxNDQzOTg2NTIyfQ.eyJpZCI6Mn0.BY2_R9nEEUUc4EM6ZiUEmQgwuyioZGwTyE5ew28i_G4	\N	\N	\N	\N	\N	\N	\N	2
callmemaybe			callmemaybe@gmail.com	$6$rounds=665335$uAIfJoRQ.hBs3GL3$4azW10Y.aUL.pVKEhqJYZE7fq87zUxJbJnIuXHFdNlbBLg9lMmGLJj0QG9TU1sth2CtIkXRsMsnhMtiW1P8hY.	\N	eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0NDAwNDQxOSwiaWF0IjoxNDQ0MDAzODE5fQ.eyJpZCI6MX0.sHRia373dwzDct9XvvBp_DFHwQ-upIV_pfgj85YImAo	\N	\N	\N	\N	\N	\N	\N	1
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: petergzliMacBookPro
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Name: forum_post_flagged_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_post_flagged
    ADD CONSTRAINT forum_post_flagged_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile_likes
    ADD CONSTRAINT forum_profile_likes_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_photo_album_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile_photo_album_photos
    ADD CONSTRAINT forum_profile_photo_album_photos_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile
    ADD CONSTRAINT forum_profile_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_postings_flagged_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile_postings_flagged
    ADD CONSTRAINT forum_profile_postings_flagged_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_postings_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile_postings_likes
    ADD CONSTRAINT forum_profile_postings_likes_pkey PRIMARY KEY (id);


--
-- Name: forum_profile_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY forum_profile_postings
    ADD CONSTRAINT forum_profile_postings_pkey PRIMARY KEY (id);


--
-- Name: user_checked_in_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY user_checked_in
    ADD CONSTRAINT user_checked_in_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: petergzliMacBookPro
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM "petergzliMacBookPro";
GRANT ALL ON SCHEMA public TO "petergzliMacBookPro";
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

