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
    id integer NOT NULL,
    user_who_flagged integer,
    forum_profile_flagged_id integer
);


ALTER TABLE forum_post_flagged OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile (
    id integer NOT NULL,
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
    location_pin_longitude double precision
);


ALTER TABLE forum_profile OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_likes; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_likes (
    id integer NOT NULL,
    forum_profile_id integer,
    user_who_liked integer,
    likes integer,
    dislikes integer
);


ALTER TABLE forum_profile_likes OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_photo_album_photos; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_photo_album_photos (
    id integer NOT NULL,
    poster_id integer,
    forum_profile_id integer,
    image_url character varying(150),
    photo_flagged integer
);


ALTER TABLE forum_profile_photo_album_photos OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings (
    id integer NOT NULL,
    forum_id integer,
    poster_id integer,
    body text,
    created_at date,
    image_url character varying(150),
    comment_flagged integer,
    replied_to_forum_id integer,
    location_pin_latitude double precision,
    location_pin_longitude double precision
);


ALTER TABLE forum_profile_postings OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_flagged; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings_flagged (
    id integer NOT NULL,
    user_who_flagged integer,
    forum_profile_flagged_id integer
);


ALTER TABLE forum_profile_postings_flagged OWNER TO "petergzliMacBookPro";

--
-- Name: forum_profile_postings_likes; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE forum_profile_postings_likes (
    id integer NOT NULL,
    forum_profile_posting_id integer,
    user_who_liked integer,
    likes integer,
    dislikes integer
);


ALTER TABLE forum_profile_postings_likes OWNER TO "petergzliMacBookPro";

--
-- Name: user_checked_in; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE user_checked_in (
    id integer NOT NULL,
    user_who_checked_in_id integer,
    checked_into_forum_profile_id integer,
    time_checked_in date
);


ALTER TABLE user_checked_in OWNER TO "petergzliMacBookPro";

--
-- Name: users; Type: TABLE; Schema: public; Owner: petergzliMacBookPro; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
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
    device_id integer
);


ALTER TABLE users OWNER TO "petergzliMacBookPro";

--
-- Data for Name: forum_post_flagged; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_post_flagged (id, user_who_flagged, forum_profile_flagged_id) FROM stdin;
\.


--
-- Data for Name: forum_profile; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile (id, created_by, description, category, title, location, latitude, longitude, created_at, image_url, forum_post_flagged, location_pin_latitude, location_pin_longitude) FROM stdin;
\.


--
-- Data for Name: forum_profile_likes; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_likes (id, forum_profile_id, user_who_liked, likes, dislikes) FROM stdin;
\.


--
-- Data for Name: forum_profile_photo_album_photos; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_photo_album_photos (id, poster_id, forum_profile_id, image_url, photo_flagged) FROM stdin;
\.


--
-- Data for Name: forum_profile_postings; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings (id, forum_id, poster_id, body, created_at, image_url, comment_flagged, replied_to_forum_id, location_pin_latitude, location_pin_longitude) FROM stdin;
\.


--
-- Data for Name: forum_profile_postings_flagged; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings_flagged (id, user_who_flagged, forum_profile_flagged_id) FROM stdin;
\.


--
-- Data for Name: forum_profile_postings_likes; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY forum_profile_postings_likes (id, forum_profile_posting_id, user_who_liked, likes, dislikes) FROM stdin;
\.


--
-- Data for Name: user_checked_in; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY user_checked_in (id, user_who_checked_in_id, checked_into_forum_profile_id, time_checked_in) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: petergzliMacBookPro
--

COPY users (id, username, firstname, lastname, email, encrypted_password, reset_password_token, authentication_token, bio, profile_photo, main_city, latitude, longitude, user_flagged, device_id) FROM stdin;
\.


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

