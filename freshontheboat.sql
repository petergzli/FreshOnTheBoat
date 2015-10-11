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
    id integer NOT NULL,
    total_likes integer
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

